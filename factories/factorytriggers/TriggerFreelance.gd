class_name TriggerFreelance
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.FREELANCE
	discover_text = "You realize working for others has a better guaranteed income than hoping you find coins. You begin posting ads."

func has_met_trigger() -> bool:
	var gold_count: bool = Gold.get_total_gold() >= 25
	return gold_count
