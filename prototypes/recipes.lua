data:extend({
 {
  type = "recipe",
  name = "uplink-station",
  energy_required = 30,
  enabled = false,
  ingredients =
  {
   {"advanced-circuit", 50},
   {"steel-plate", 100},
   {"rocket-control-unit", 50},
   {"fusion-reactor-equipment", 5},
   {"copper-cable", 100},
   {"radar", 1},
  },
  result = "uplink-station"
 },
})

if data.raw["item"]["advanced-processing-unit"] and enableBobUpdates then
	data.raw["recipe"]["uplink-station"].ingredients[1] = {"advanced-processing-unit", 50}
end

if data.raw["item"]["gilded-copper-cable"] and enableBobUpdates then
	data.raw["recipe"]["uplink-station"].ingredients[5] = {"insulated-cable", 100}
end
