extends RefCounted

const World = preload("res://addons/ow_ecs/world.gd")
const Cooldown = preload("res://game/components/cooldown.gd")


static func try_activate(world: World, entity_id: int) -> bool:
	var cooldown := world.get_component(entity_id, Cooldown) as Cooldown
	if cooldown == null or cooldown.remaining > 0.0:
		return false
	cooldown.remaining = cooldown.duration
	return true


static func tick(world: World, delta: float) -> void:
	for entity_id in world.entities_with(Cooldown):
		var cooldown := world.get_component(entity_id, Cooldown) as Cooldown
		cooldown.remaining = move_toward(cooldown.remaining, 0.0, delta)
