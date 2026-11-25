extends RefCounted

var duration: float
var remaining: float = 0.0


func _init(seconds: float) -> void:
	duration = maxf(seconds, 0.0)
