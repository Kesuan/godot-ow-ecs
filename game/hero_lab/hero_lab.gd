extends CenterContainer

const World = preload("res://addons/ow_ecs/world.gd")
const Cooldown = preload("res://game/components/cooldown.gd")
const CooldownSystem = preload("res://game/systems/cooldown_system.gd")

@export_range(0.1, 30.0, 0.1, "suffix:s") var cooldown_seconds: float = 3.0

@onready var charge: ProgressBar = %Charge
@onready var pulse_button: Button = %PulseButton

var world := World.new()
var hero: int
var cooldown: Cooldown
var pulse_requested := false


func _ready() -> void:
	hero = world.create_entity()
	cooldown = Cooldown.new(cooldown_seconds)
	world.set_component(hero, cooldown)
	charge.max_value = cooldown.duration
	pulse_button.pressed.connect(_on_pulse_pressed)
	_refresh_view()


func _on_pulse_pressed() -> void:
	pulse_requested = true


func _physics_process(delta: float) -> void:
	CooldownSystem.tick(world, delta)
	if pulse_requested:
		CooldownSystem.try_activate(world, hero)
		pulse_requested = false
	_refresh_view()


func _refresh_view() -> void:
	charge.value = cooldown.duration - cooldown.remaining
	pulse_button.disabled = cooldown.remaining > 0.0
	if pulse_button.disabled:
		pulse_button.text = "Recharging  %.1f s" % cooldown.remaining
	else:
		pulse_button.text = "Activate pulse"
