require "util"
require ("config")

script.on_init(function() On_Init() end)
script.on_configuration_changed(function() On_Init() end)

function On_Init()
	global.character_data = global.character_data or {}
	global.station_data = global.station_data or {}
	for i, player in pairs(game.players) do
		if player.gui.left.rocket_score and tonumber(player.gui.left.rocket_score.rocket_count.caption) > 0 then
			player.force.technologies["uplink-station"].enabled = true
		end
	end
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.element.player_index]
	if event.element.name == "terminate-uplink" then
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
					if enableSounds then
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
}

function isContraband(item)
	return not(g_isAllowed[item.name])
end

script.on_event(defines.events.on_rocket_launched, function(event)
	local force = event.rocket.force
	if not force.technologies["uplink-station"].enabled then
		for i, player in pairs(force.players) do
			if player.connected then
				if (player.gui.left.rocket_score and tonumber(player.gui.left.rocket_score.rocket_count.caption) > 0) or event.rocket.get_item_count("satellite") > 0 then
					player.force.technologies["uplink-station"].enabled = true
					player.force.print({"first-satellite-sent"})
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

function getBlueprintBookData(stack)
	data = {}
	data.main = {}
	if stack.name == "blueprint-book" then
		local inventory = stack.get_inventory(defines.inventory.item_active)
		if (inventory[1].valid_for_read and inventory[1].is_blueprint_setup()) then
			data.active = {
				label = inventory[1].label,
				entities = inventory[1].get_blueprint_entities(),
				icons = inventory[1].blueprint_icons,
				tiles = inventory[1].get_blueprint_tiles()
			}
		end
		inventory = stack.get_inventory(defines.inventory.item_main)
		for i = 1, #(inventory) do
			if (inventory[i].valid_for_read and inventory[i].is_blueprint_setup()) then
				table.insert(data.main, {
					label = inventory[i].label,
					entities = inventory[i].get_blueprint_entities(),
					icons = inventory[i].blueprint_icons,
					tiles = inventory[i].get_blueprint_tiles()
				})
			end
		end
	end
	return data
end

function getBlueprintBooks(player)
	local books = {}
	local inventory = player.get_inventory(defines.inventory.player_main)
	for i = 1, #inventory do
		if inventory[i].valid_for_read then
			if inventory[i].name == "blueprint-book" then
				table.insert(books, getBlueprintBookData(inventory[i]))
			end
		end
	end
	inventory = player.get_inventory(defines.inventory.player_quickbar)
	for i = 1, #inventory do
		if inventory[i].valid_for_read then
			if inventory[i].name == "blueprint-book" then
				table.insert(books, getBlueprintBookData(inventory[i]))
			end
		end
	end
	return books
end

function insertBlueprint(stack, data)
	stack.set_blueprint_entities(data.entities)
	stack.set_blueprint_tiles(data.tiles)
	stack.blueprint_icons = data.icons
	if data.label then
		stack.label = data.label
	end
end

function insertBlueprintBook(stack, data)
	local inventory = stack.get_inventory(defines.inventory.item_main)
	if data.active then
		stack.get_inventory(defines.inventory.item_active).insert("blueprint")
		insertBlueprint(stack.get_inventory(defines.inventory.item_active)[1], data.active)
	end
	for i = 1, #(data.main) do
		inventory.insert("blueprint")
		insertBlueprint(inventory[i], data.main[i])
	end
end

function isBlueprintBookEmpty(stack)
	local inv = stack.get_inventory(defines.inventory.item_active)
	if (inv[1].valid_for_read and inv[1].is_blueprint_setup()) then
		return false
	end
	inv = stack.get_inventory(defines.inventory.item_main)
	for i = 1, #(inv) do
		if (inv[i].valid_for_read and inv[i].is_blueprint_setup()) then
			return false
		end
	end
	return true
end

function getWritableBlueprintBook(player)
	local inv = player.get_inventory(defines.inventory.player_quickbar)
	for i = 1, #inv do
		if (not inv[i].valid_for_read and inv[i].valid and inv[i].can_set_stack({name="blueprint-book", count=1})) then
			inv[i].set_stack({name="blueprint-book", count=1})
			return inv[i]
		end
	end
end

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
		if enableSounds then
			playSoundForPlayer("uplink-activate", player)
		end
		local blueprintBooks = getBlueprintBooks(player)
		global.character_data[event.player_index] = player.character
		global.station_data[event.player_index] = vehicle
		local uplink = player.surface.create_entity{name="orbital-uplink", position=player.position, force=player.force}
		player.character = uplink
		uplink.destructible = false
		local quickbar = player.get_inventory(defines.inventory.player_quickbar)
		insertIfExists("ion-cannon-targeter", quickbar)
		insertIfExists("deconstruction-planner", quickbar)
		insertIfExists("upgrade-builder", quickbar)
		insertIfExists("resource-monitor", quickbar)
		insertIfExists("unit-remote-control", quickbar)
		insertIfExists("zone-planner", quickbar)
		insertIfExists("tree-deconstructor", quickbar)
		insertIfExists("alien-artifact-deconstructor", quickbar)
		player.get_inventory(defines.inventory.player_armor).insert({name="dummy-armor", count=1})
		local armor = player.get_inventory(defines.inventory.player_armor)[1]
		armor.grid.put{name="fusion-reactor-equipment"}
		armor.grid.put{name="night-vision-equipment"}
		for i = 1, #blueprintBooks do
			insertBlueprintBook(getWritableBlueprintBook(player), blueprintBooks[i])
		end
		if not player.gui.top["terminate-uplink"] then
			player.gui.top.add{type="button", name="terminate-uplink", caption={"terminate-uplink"}}
		end
	end
end)
