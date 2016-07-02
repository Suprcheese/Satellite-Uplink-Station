require "util"
require "stdlib/game"
require ("config")

script.on_init(function() On_Init() end)
script.on_configuration_changed(function() On_Init() end)

function On_Init()
	global.character_data = global.character_data or {}
	for i, player in pairs(game.players) do
		if player.gui.left.rocket_score and tonumber(player.gui.left.rocket_score.rocket_count.caption) > 0 then
			player.force.technologies["uplink-station"].enabled = true
		end
	end
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.element.player_index]
	local name = event.element.name
	if (name == "terminate-uplink") then
		local uplink = player.character
		if not global.character_data[event.element.player_index] or not global.character_data[event.element.player_index].valid then
			player.print({"critical-character-error"})
			return
		else
			if enableSounds then
				playSoundForPlayer("uplink-deactivate", player)
			end
			player.print({"uplink-terminated"})
			player.character = global.character_data[event.element.player_index]
		end
		uplink.destroy()
		player.driving = false
		if (player.gui.top["terminate-uplink"]) then
			player.gui.top["terminate-uplink"].destroy()
		end
	end
end)

function playSoundForPlayer(sound, player)
	player.surface.create_entity({name = sound, position = player.position})
end

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
	local player = game.players[event.player_index]
	if player.character.name == "orbital-uplink" then
		local stack = player.cursor_stack
		if stack and stack.valid_for_read then
			local name = stack.name
			if name == "ion-cannon-targeter" or name == "deconstruction-planner" or name == "filtered-deconstruction-planner" or name == "upgrade-planner" or name == "resource-monitor" then
				return
			elseif name == "dummy-armor" then
				local armor_inv = player.get_inventory(defines.inventory.player_armor)
				armor_inv[1].set_stack(stack)
				stack.clear()
			elseif name == "fusion-reactor-equipment" or name == "night-vision-equipment" then
				local armor = player.get_inventory(defines.inventory.player_armor)[1]
				armor.grid.put{name=name}
				stack.clear()
			else
				stack.clear()
			end
		end
	end
end)

script.on_event(defines.events.on_player_quickbar_inventory_changed, function(event)
	local player = game.players[event.player_index]
	if player.character.name == "orbital-uplink" then
		local quickbar = player.get_inventory(defines.inventory.player_quickbar)
		for i = 1, #quickbar do
			if quickbar[i].valid_for_read and isContraband(quickbar[i]) then
				quickbar[i].clear()
			end
		end
	end
end)

script.on_event(defines.events.on_player_gun_inventory_changed, function(event)
	local player = game.players[event.player_index]
	if player.character.name == "orbital-uplink" then
		local gun_inv = player.get_inventory(defines.inventory.player_guns)
		gun_inv.clear()
	end
end)

script.on_event(defines.events.on_player_tool_inventory_changed, function(event)
	local player = game.players[event.player_index]
	if player.character.name == "orbital-uplink" then
		local tool_inv = player.get_inventory(defines.inventory.player_tools)
		tool_inv.clear()
	end
end)

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
		for i, player in pairs(force.players) do
			if player.connected then
				if (player.gui.left.rocket_score and tonumber(player.gui.left.rocket_score.rocket_count.caption) > 0) or event.rocket.get_item_count("satellite") > 0 then
					player.force.technologies["uplink-station"].enabled = true
					Game.print_force(force, {"first-satellite-sent"})
					break
				end
			end
		end
	end
end)

script.on_event(defines.events.on_built_entity, function(event)
	if event.created_entity.name == "uplink-station" then
		event.created_entity.insert{name="coal", count=1}
		event.created_entity.operable = false
	end
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	if event.entity.name == "uplink-station" then
		return event.entity.clear_items_inside()
	end
end)

script.on_event(defines.events.on_player_driving_changed_state, function(event)
	local player = game.players[event.player_index]
	if player.vehicle and player.character.name == "orbital-uplink" then
		player.driving = false
		return
	end
	if player.vehicle and player.vehicle.name == "uplink-station" then
		player.print({"initiating-uplink"})
		if enableSounds then
			playSoundForPlayer("uplink-activate", player)
		end
		global.character_data[event.player_index] = player.character
		local uplink = player.surface.create_entity{name="orbital-uplink", position=player.position, force=player.force}
		player.character = uplink
		uplink.destructible = false
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
		player.get_inventory(defines.inventory.player_armor).insert({name="dummy-armor", count=1})
		local armor = player.get_inventory(defines.inventory.player_armor)[1]
		armor.grid.put{name="fusion-reactor-equipment"}
		armor.grid.put{name="night-vision-equipment"}
		if not player.gui.top["terminate-uplink"] then
			player.gui.top.add{type="button", name="terminate-uplink", caption={"terminate-uplink"}}
		end
	end
end)
