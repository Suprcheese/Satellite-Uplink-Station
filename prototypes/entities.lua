local empty_animation = {
	filename = "__core__/graphics/empty.png",
	priority = "low",
	width = 0,
	height = 0,
	direction_count = 18,
	frame_count = 1,
	animation_speed = 1,
	shift = {0,0},
	axially_symmetrical = false,
}

local null = {
	idle = empty_animation,
	idle_mask = empty_animation,
	idle_with_gun = empty_animation,
	idle_with_gun_mask = empty_animation,
	mining_with_hands = empty_animation,
	mining_with_hands_mask = empty_animation,
	mining_with_tool = empty_animation,
	mining_with_tool_mask = empty_animation,
	running_with_gun = empty_animation,
	running_with_gun_mask = empty_animation,
	running = empty_animation,
	running_mask = empty_animation,
}

data:extend({
	{
		type = "player",
		name = "orbital-uplink",
		icon = "__base__/graphics/icons/player.png",
		flags = {"placeable-off-grid", "not-on-map", "not-repairable"},
		max_health = 1,
		healing_per_tick = 0,
		collision_box = {{-0, -0}, {0, 0}},
		selection_box = {{-0, -0}, {0, 0}},
		crafting_categories = {"null"},
		mining_categories = {"null"},
		inventory_size = 0,
		build_distance = 0,
		drop_item_distance = 0,
		reach_distance = 0,
		item_pickup_distance = 0,
		loot_pickup_distance = 0,
		reach_resource_distance = 0,
		ticks_to_keep_gun = 0,
		ticks_to_keep_aiming_direction = 0,
		ticks_to_stay_in_combat = 0,
		damage_hit_tint = {r = 0, g = 0, b = 0, a = 0},
		running_speed = 1.5,
		distance_per_frame = 0.13,
		maximum_corner_sliding_distance = 0.7,
		subgroup = "creatures",
		order="z",
		eat =
		{
			{
				filename = "__base__/sound/eat.ogg",
				volume = 0
			}
		},
		heartbeat =
		{
			{
				filename = "__base__/sound/heartbeat.ogg",
				volume = 0
			}
		},
		animations = {
			level1 = null,
			level2addon = null,
			level3addon = null,
		},
		light = nil,
		mining_speed = 0,
		collision_mask = {},
		mining_with_hands_particles_animation_positions = {},
		mining_with_tool_particles_animation_positions = {},
		running_sound_animation_positions = {}
	},
	{
		type = "car",
		name = "uplink-station",
		icon = "__Satellite Uplink Station__/graphics/UplinkStationIcon.png",
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 3, result = "uplink-station"},
		mined_sound = { filename = "__core__/sound/deconstruct-large.ogg" },
		max_health = 200,
		corpse = "big-remnants",
		dying_explosion = "massive-explosion",
		energy_per_hit_point = 1,
		resistances =
		{
			{
				type = "fire",
				percent = 50
			}
		},
		collision_box = {{-2.0, -3.0}, {2.0, 1.0}},
		selection_box = {{-2.5, -3.5}, {2.5, 1.5}},
		effectivity = 0,
		braking_power = "0W",
		burner =
		{
			effectivity = 0.01,
			fuel_inventory_size = 1,
		},
		consumption = "0W",
		friction = 1,
		light = {intensity = 0, size = 0},
		animation =
		{
			layers =
			{
				{
					width = 992,
					height = 913,
					frame_count = 1,
					direction_count = 1,
					shift = {1.0, -2.5},
					animation_speed = 1,
					max_advance = 0,
					scale = 0.33,
					priority = "low",
					filename = "__Satellite Uplink Station__/graphics/UplinkStation.png",
				},
			}
		},
		sound_minimum_speed = 0.2;
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.75 },
		working_sound =
		{
			sound =
			{
				filename = "__base__/sound/radar.ogg",
				volume = 0.6
			},
			activate_sound =
			{
				filename = "__Satellite Uplink Station__/sound/Activate.ogg",
				volume = 0
			},
			deactivate_sound =
			{
				filename = "__Satellite Uplink Station__/sound/Deactivate.ogg",
				volume = 0
			},
			match_speed_to_activity = false,
		},
		rotation_speed = 0,
		weight = 700,
		-- equipment_grid = "small-equipment-grid",
		inventory_size = 0
	},
	{
		type = "sound",
		name = "uplink-activate",
		variations =
		{
			{
				filename = "__Satellite Uplink Station__/sound/Activate.ogg",
				volume = 0.6
			},
		}
	},
	{
		type = "sound",
		name = "uplink-deactivate",
		variations =
		{
			{
				filename = "__Satellite Uplink Station__/sound/Deactivate.ogg",
				volume = 0.6
			},
		}
	},
	{
		type = "explosion",
		name = "null",
		flags = {"not-on-map"},
		animations =
		{
			{
				filename = "__core__/graphics/empty.png",
				priority = "low",
				width = 1,
				height = 1,
				frame_count = 1,
				line_length = 1,
				animation_speed = 1
			},
		},
		light = {intensity = 0, size = 0},
		sound =
		{
			{
				filename = "__Satellite Uplink Station__/sound/Deactivate.ogg",
				volume = 0
			},
		},
	},
})

if settings.startup["sat-uplink-full-control"].value then
	data.raw["player"]["orbital-uplink"].reach_distance = 8
end
