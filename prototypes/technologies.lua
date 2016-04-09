data:extend({
 {
  type = "technology",
  name = "uplink-station",
  icon = "__Satellite Uplink Station__/graphics/SatUplink.png",
  icon_size = 128,
  prerequisites = {"rocket-silo"},
  enabled = false,
  effects =
  {
   {
    type = "unlock-recipe",
    recipe = "uplink-station"
   },
  },
  unit =
  {
   count = 1000,
   ingredients =
   {
    {"science-pack-1", 2},
    {"science-pack-2", 2},
    {"science-pack-3", 2},
	{"alien-science-pack", 2},
   },
   time = 30
  },
  order = "k-z"
 },
})

if data.raw["tool"]["science-pack-4"] and enableBobUpdates then
	data.raw["technology"]["uplink-station"].unit.ingredients[4] = {"science-pack-4", 2}
end
