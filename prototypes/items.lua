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
	},
	{
		type = "armor",
		name = "dummy-armor",
		icon = "__Satellite Uplink Station__/graphics/null.png",
		flags = {"goes-to-main-inventory"},
		resistances = {},
		durability = 10000,
		subgroup = "armor",
		order = "z[dummy]",
		stack_size = 1,
		equipment_grid = {width = 10, height = 10},
		inventory_size_bonus = 0
	}
})
