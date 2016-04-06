require "util"
require "defines"
require ("config")

script.on_init(function() On_Init() end)
script.on_configuration_changed(function() On_Init() end)

function On_Init()
	if not global.character_data then
		global.character_data = {}
	end
	for i, player in ipairs(game.players) do
		if player.gui.left.rocket_score and tonumber(player.gui.left.rocket_score.rocket_count.caption) > 0 then
			player.force.technologies["uplink-station"].enabled = true
		end
	end
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.element.player_index]
	local name = event.element.name
	if (name == "terminate-uplink") then
		if enableSounds then
			playSoundForPlayer("uplink-deactivate", player)
		end
		messagePlayer({"uplink-terminated"}, player)
		local uplink = player.character
		player.character = global.character_data[event.element.player_index]
		uplink.destroy()
		player.driving = false
		if (player.gui.top["terminate-uplink"]) then
			player.gui.top["terminate-uplink"].destroy()
		end
		return
	end
end)

function messageForce(mes, force)
  for i, player in ipairs(force.players) do
	if player.connected then
		player.print(mes)
	end
  end
end

function messagePlayer(mes, player)
    player.print(mes)
end

function playSoundForPlayer(sound, player)
	player.surface.create_entity({name = sound, position = player.position})
end

function isContraband(item)
	if item.name == "ion-cannon-targeter" or item.name == "deconstruction-planner" or item.name == "filtered-deconstruction-planner" or item.name == "upgrade-planner" or item.name == "resource-monitor" then
		return false
	else
		return true
	end
end

script.on_event(defines.events.on_rocket_launched, function(event)
	local force = event.rocket.force
	if not force.technologies["uplink-station"].enabled then
		for i, player in ipairs(force.players) do
			if player.connected then
				if (player.gui.left.rocket_score and tonumber(player.gui.left.rocket_score.rocket_count.caption) > 0) or event.rocket.get_item_count("satellite") > 0 then
					player.force.technologies["uplink-station"].enabled = true
					messageForce({"first-satellite-sent"}, force)
					break
				end
			end
		end
	end
end)

if disableLogisticsWhileUplinked then
	script.on_event(defines.events.on_tick, function(event)
		if game.tick % 60 == 2 then
			for i, player in ipairs(game.players) do
				if player.connected and player.character.name == "orbital-uplink" then
					for i = 1, #player.get_inventory(defines.inventory.player_quickbar) do
						if player.get_inventory(defines.inventory.player_quickbar)[i].valid_for_read and isContraband(player.get_inventory(defines.inventory.player_quickbar)[i]) then
							if player.get_inventory(defines.inventory.player_tools).can_insert(player.get_inventory(defines.inventory.player_quickbar)[i]) then
								player.get_inventory(defines.inventory.player_tools).insert(player.get_inventory(defines.inventory.player_quickbar)[i])
							end
							if player.get_inventory(defines.inventory.player_guns).can_insert(player.get_inventory(defines.inventory.player_quickbar)[i]) then
								player.get_inventory(defines.inventory.player_guns).insert(player.get_inventory(defines.inventory.player_quickbar)[i])
							end
							if player.get_inventory(defines.inventory.player_armor).can_insert(player.get_inventory(defines.inventory.player_quickbar)[i]) then
								player.get_inventory(defines.inventory.player_armor).insert(player.get_inventory(defines.inventory.player_quickbar)[i])
							end
							player.get_inventory(defines.inventory.player_quickbar)[i].clear()
						end
					end
				end
			end
		end
		if game.tick % 30 == 23 then
			for i, player in ipairs(game.players) do
				if not player.get_inventory(defines.inventory.player_trash).is_empty() then
					for i = 1, #player.get_inventory(defines.inventory.player_trash) do
						if player.get_inventory(defines.inventory.player_trash)[i].valid_for_read then
							player.insert(player.get_inventory(defines.inventory.player_trash)[i])
							player.get_inventory(defines.inventory.player_trash)[i].clear()
						end
					end
				end
			end
		end
	end)
end

script.on_event(defines.events.on_built_entity, function(event)
	if event.created_entity.name == "uplink-station" then
		event.created_entity.insert{name="coal", count=1}
		event.created_entity.operable = false
		return
	end
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	if event.entity.name == "uplink-station" then
		return event.entity.clear_items_inside()
	end
end)

script.on_event(defines.events.on_player_driving_changed_state, function(event)
	local player = game.get_player(event.player_index)
	if player.vehicle and player.character.name == "orbital-uplink" then
		player.driving = false
		return
	end
	if player.vehicle and player.vehicle.name == "uplink-station" then
		messagePlayer({"initiating-uplink"}, player)
		if enableSounds then
			playSoundForPlayer("uplink-activate", player)
		end
		global.character_data[event.player_index] = player.character
		local uplink = player.surface.create_entity{name="orbital-uplink", position=player.position, force=player.force}
		player.character = uplink
		if game.item_prototypes["ion-cannon-targeter"] then
			player.insert({name="ion-cannon-targeter", count=1})
		end
		if game.item_prototypes["filtered-deconstruction-planner"] then
			player.insert({name="filtered-deconstruction-planner", count=1})
		else
			player.insert({name="deconstruction-planner", count=1})
		end
		if game.item_prototypes["upgrade-planner"] then
			player.insert({name="upgrade-planner", count=1})
		end
		if game.item_prototypes["resource-monitor"] then
			player.insert({name="resource-monitor", count=1})
		end
		player.get_inventory(defines.inventory.player_tools).insert({name="dummy-axe", count=1})
		player.get_inventory(defines.inventory.player_guns).insert({name="dummy-gun", count=1})
		player.get_inventory(defines.inventory.player_guns).insert({name="dummy-gun-2", count=1})
		player.get_inventory(defines.inventory.player_guns).insert({name="dummy-gun-3", count=1})
		player.get_inventory(defines.inventory.player_armor).insert({name="power-armor-mk2", count=1})
		local armor = player.get_inventory(defines.inventory.player_armor)[1]
		armor.grid.put{name="fusion-reactor-equipment"}
		armor.grid.put{name="night-vision-equipment"}
		if not player.gui.top["terminate-uplink"] then
			player.gui.top.add{type="button", name="terminate-uplink", caption={"terminate-uplink"}}
		end
	end
end)
