local dummy_armor = util.table.deepcopy(data.raw["armor"]["power-armor-mk2"])

dummy_armor.name = "dummy-armor"
dummy_armor.icon = "__Satellite Uplink Station__/graphics/null.png"
dummy_armor.resistances = {}
dummy_armor.subgroup = "armor"
dummy_armor.order = "z[dummy]"
dummy_armor.inventory_size_bonus = 0

data:extend({dummy_armor})

data:extend({
	{
		type = "item",
		name = "uplink-station",
		icon = "__Satellite Uplink Station__/graphics/UplinkStationIcon.png",
		flags = {"goes-to-quickbar"},
		place_result = "uplink-station",
		subgroup = "defensive-structure",
		order = "c[uplink]",
		stack_size = 1,
	}
})
