class_name TriggerVegetableFarm
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.VEGETABLE
	discover_text = "You discover the prospect of agriculture. It gives good returns on your time!"

func has_met_trigger() -> bool:
	var gold_count: bool = Gold.get_total_gold() >= 250
	var fac_count: bool = Clicker.get_count_of_factory(FactoryName.TYPES.FREELANCE) >= 1
	return gold_count and fac_count
