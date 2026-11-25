extends SceneTree

const World = preload("res://addons/ow_ecs/world.gd")
const Cooldown = preload("res://game/components/cooldown.gd")
const CooldownSystem = preload("res://game/systems/cooldown_system.gd")

var failures: int = 0


func _initialize() -> void:
	var world := World.new()
	var scout := world.create_entity()
	var medic := world.create_entity()
	var spectator := world.create_entity()
	var short_cooldown := Cooldown.new(1.0)
	var long_cooldown := Cooldown.new(3.0)
	world.set_component(scout, short_cooldown)
	world.set_component(medic, long_cooldown)

	check(world.entities_with(Cooldown).size() == 2, "Only heroes have cooldowns")
	check(not CooldownSystem.try_activate(world, spectator), "A spectator has no ability")
	check(CooldownSystem.try_activate(world, scout), "Scout can activate")
	check(not CooldownSystem.try_activate(world, scout), "Cooldown blocks a second activation")
	check(CooldownSystem.try_activate(world, medic), "Medic can activate independently")

	CooldownSystem.tick(world, 1.25)
	check(short_cooldown.remaining == 0.0, "Short cooldown stops at zero")
	check(is_equal_approx(long_cooldown.remaining, 1.75), "Long cooldown keeps counting down")
	check(CooldownSystem.try_activate(world, scout), "Scout can activate again")

	world.destroy_entity(medic)
	check(world.entities_with(Cooldown) == [scout], "Destroyed hero leaves the query")
	check(not CooldownSystem.try_activate(world, medic), "Destroyed hero cannot activate")
	if failures == 0:
		print("PASS: cooldown smoke test")
	quit(1 if failures > 0 else 0)


func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)
