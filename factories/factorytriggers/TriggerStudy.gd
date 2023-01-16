class_name TriggerStudy
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.STUDY
	discover_text = "It might be a good idea to hit the books. You have a lot of things to learn."

func has_met_trigger() -> bool:
	var gold_need: bool = Gold.get_total_gold() >= 500
	var fac_count: bool = Clicker.get_count_of_factory(FactoryName.TYPES.VEGETABLE) >= 2
	return gold_need and fac_count
