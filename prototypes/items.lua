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
    type = "gun",
    name = "dummy-gun",
    icon = "__Satellite Uplink Station__/graphics/null.png",
    flags = {"goes-to-main-inventory", "hidden"},
    subgroup = "gun",
    order = "a[basic-clips]-z[dummy]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "railgun",
      cooldown = 10,
      movement_slow_down_factor = 0,
      shell_particle =
      {
        name = "shell-particle",
        direction_deviation = 0.1,
        speed = 0.1,
        speed_deviation = 0.03,
        center = {0, 0.1},
        creation_distance = -0.5,
        starting_frame_speed = 0.4,
        starting_frame_speed_deviation = 0.1
      },
      projectile_creation_distance = 0,
      range = 0,
      sound = make_light_gunshot_sounds(),
    },
    stack_size = 1
  },
  {
    type = "gun",
    name = "dummy-gun-2",
    icon = "__Satellite Uplink Station__/graphics/null.png",
    flags = {"goes-to-main-inventory", "hidden"},
    subgroup = "gun",
    order = "a[basic-clips]-z[dummy]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "railgun",
      cooldown = 10,
      movement_slow_down_factor = 0,
      shell_particle =
      {
        name = "shell-particle",
        direction_deviation = 0.1,
        speed = 0.1,
        speed_deviation = 0.03,
        center = {0, 0.1},
        creation_distance = -0.5,
        starting_frame_speed = 0.4,
        starting_frame_speed_deviation = 0.1
      },
      projectile_creation_distance = 0,
      range = 0,
      sound = make_light_gunshot_sounds(),
    },
    stack_size = 1
  },
    {
    type = "gun",
    name = "dummy-gun-3",
    icon = "__Satellite Uplink Station__/graphics/null.png",
    flags = {"goes-to-main-inventory", "hidden"},
    subgroup = "gun",
    order = "a[basic-clips]-z[dummy]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "railgun",
      cooldown = 10,
      movement_slow_down_factor = 0,
      shell_particle =
      {
        name = "shell-particle",
        direction_deviation = 0.1,
        speed = 0.1,
        speed_deviation = 0.03,
        center = {0, 0.1},
        creation_distance = -0.5,
        starting_frame_speed = 0.4,
        starting_frame_speed_deviation = 0.1
      },
      projectile_creation_distance = 0,
      range = 0,
      sound = make_light_gunshot_sounds(),
    },
    stack_size = 1
  },
  {
    type = "mining-tool",
    name = "dummy-axe",
    icon = "__Satellite Uplink Station__/graphics/null.png",
    flags = {"goes-to-main-inventory", "hidden"},
    {
      type="direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
            type = "create-entity",
            entity_name = "null"
        }
      }
    },
    durability = 5000,
    subgroup = "tool",
    order = "a[mining]-z[dummy]",
    speed = 1,
    stack_size = 1
  }
})
