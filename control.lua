require "util"

script.on_init(function() On_Init() end)
script.on_configuration_changed(function() On_Init() end)

function On_Init()
	global.character_data = global.character_data or {}
	global.station_data = global.station_data or {}
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.element.player_index]
	if event.element.name == "terminate-uplink" then
		local uplink = player.character
		if not global.character_data[event.element.player_index] or not global.character_data[event.element.player_index].valid then
			player.print({"critical-character-error"})
			return
		else
			if settings.get_player_settings(player)["sat-uplink-enable-sounds"].value then
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

script.on_event(defines.events.on_entity_died, function(event)
	local entity = event.entity
	if entity.name == "uplink-station" then
		for i, player in pairs(game.players) do
			local index = player.index
			if global.station_data[index] and global.station_data[index].valid and (entity == global.station_data[index]) and player.character and player.character.name == "orbital-uplink" then
				local uplink = player.character
				if not global.character_data[index] or not global.character_data[index].valid then
					player.print({"critical-character-error"})
					return
				else
					if settings.get_player_settings(player)["sat-uplink-enable-sounds"].value then
						playSoundForPlayer("uplink-deactivate", player)
					end
					player.print({"uplink-terminated"})
					player.character = global.character_data[index]
				end
				uplink.destroy()
				if (player.gui.top["terminate-uplink"]) then
					player.gui.top["terminate-uplink"].destroy()
				end
			end
		end
	end
end)

function playSoundForPlayer(sound, player)
	player.surface.create_entity({name = sound, position = player.position})
end

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
	local player = game.players[event.player_index]
	if player.character and player.character.name == "orbital-uplink" then
		local stack = player.cursor_stack
		if stack and stack.valid_for_read then
			local name = stack.name
			if not isContraband(stack) then
				player.character_build_distance_bonus = 5000
				return
			elseif name == "dummy-armor" then
				local armor_inv = player.get_inventory(defines.inventory.player_armor)
				armor_inv[1].set_stack(stack)
				stack.clear()
				player.character_build_distance_bonus = 0
			elseif name == "fusion-reactor-equipment" or name == "night-vision-equipment" or name == "belt-immunity-equipment" then
				local armor = player.get_inventory(defines.inventory.player_armor)[1]
				armor.grid.put{name=name}
				stack.clear()
				player.character_build_distance_bonus = 0
			else
				stack.clear()
				player.character_build_distance_bonus = 0
			end
		end
	end
end)

script.on_event(defines.events.on_player_quickbar_inventory_changed, function(event)
	local player = game.players[event.player_index]
	if player.character and player.character.name == "orbital-uplink" then
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
	if player.character and player.character.name == "orbital-uplink" then
		local gun_inv = player.get_inventory(defines.inventory.player_guns)
		gun_inv.clear()
	end
end)

script.on_event(defines.events.on_player_tool_inventory_changed, function(event)
	local player = game.players[event.player_index]
	if player.character and player.character.name == "orbital-uplink" then
		local tool_inv = player.get_inventory(defines.inventory.player_tools)
		tool_inv.clear()
	end
end)

--- Maps the item name to true for all items that are allowed while uplinked
local g_isAllowed =
{
	["ion-cannon-targeter"] = true,
	["deconstruction-planner"] = true,
	["filtered-deconstruction-planner"] = true,
	["upgrade-builder"] = true,
	["resource-monitor"] = true,
	["blueprint"] = true,
	["blueprint-book"] = true,
	["unit-remote-control"] = true,
	["zone-planner"] = true,
	["tree-deconstructor"] = true,
	["alien-artifact-deconstructor"] = true,
	["ping-tool"] = true,
}

function isContraband(item)
	return not(g_isAllowed[item.name])
end

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	if entity.name == "uplink-station" then
		entity.insert{name="coal", count=1}
		entity.operable = false
	end
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	if event.entity.name == "uplink-station" then
		return event.entity.clear_items_inside()
	end
end)

function insertIfExists(item, inventory)
	if game.item_prototypes[item] then
		inventory.insert({name=item, count=1})
	end
end

script.on_event(defines.events.on_player_driving_changed_state, function(event)
	local player = game.players[event.player_index]
	local vehicle = player.vehicle
	if not player.character then -- Handle sandbox scenario, where there is no player.character
		if vehicle and vehicle.name and vehicle.name == "uplink-station" then
			player.driving = false
			player.print({"sandbox-mode"})
		end
		return
	end
	if vehicle and player.character.name == "orbital-uplink" then
		player.driving = false
		return
	end
	if vehicle and vehicle.name == "uplink-station" then
		player.print({"initiating-uplink"})
		if settings.get_player_settings(player)["sat-uplink-enable-sounds"].value then
			playSoundForPlayer("uplink-activate", player)
		end
		global.character_data[event.player_index] = player.character
		global.station_data[event.player_index] = vehicle
		local uplink = player.surface.create_entity{name="orbital-uplink", position=player.position, force=player.force}
		player.character = uplink
		uplink.destructible = false
		vehicle.passenger = global.character_data[event.player_index]
		local quickbar = player.get_inventory(defines.inventory.player_quickbar)
		insertIfExists("ion-cannon-targeter", quickbar)
		insertIfExists("deconstruction-planner", quickbar)
		insertIfExists("upgrade-builder", quickbar)
		insertIfExists("resource-monitor", quickbar)
		insertIfExists("unit-remote-control", quickbar)
		insertIfExists("zone-planner", quickbar)
		insertIfExists("tree-deconstructor", quickbar)
		insertIfExists("alien-artifact-deconstructor", quickbar)
		insertIfExists("ping-tool", quickbar)
		player.get_inventory(defines.inventory.player_armor).insert({name="dummy-armor", count=1})
		local armor = player.get_inventory(defines.inventory.player_armor)[1]
		armor.grid.put{name="fusion-reactor-equipment"}
		armor.grid.put{name="night-vision-equipment"}
		armor.grid.put{name="belt-immunity-equipment"}
		if not player.gui.top["terminate-uplink"] then
			player.gui.top.add{type="button", name="terminate-uplink", caption={"terminate-uplink"}}
		end
	end
end)
