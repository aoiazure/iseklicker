class_name FactoryTrigger
extends Resource

var happened: bool = false
var discover_text: String

var associated_factory: FactoryName.TYPES

func has_met_trigger() -> bool:
	return true


func set_happened(value) -> void:
	happened = value
	Events.add_event(discover_text)
	Events.discover_factory(associated_factory)


func has_happened() -> bool:
	return happened


