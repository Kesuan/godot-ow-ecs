extends RefCounted
## Each entity owns at most one component per concrete GDScript type.

var _entities: Dictionary[int, Dictionary] = {}
var _next_id: int = 1


func create_entity() -> int:
	var entity_id := _next_id
	_next_id += 1
	_entities[entity_id] = {}
	return entity_id


func destroy_entity(entity_id: int) -> void:
	_entities.erase(entity_id)


func set_component(entity_id: int, component: RefCounted) -> bool:
	if not _entities.has(entity_id) or component == null or component.get_script() == null:
		return false
	_entities[entity_id][component.get_script()] = component
	return true


func get_component(entity_id: int, component_type: Script) -> RefCounted:
	if not _entities.has(entity_id):
		return null
	return _entities[entity_id].get(component_type)


func entities_with(component_type: Script) -> Array[int]:
	var result: Array[int] = []
	for entity_id in _entities:
		if _entities[entity_id].has(component_type):
			result.append(entity_id)
	return result
