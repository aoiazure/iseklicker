class_name TriggerMining
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.MINING
	discover_text = "You begin to have a need for minerals and ore, and likely others do too."

func has_met_trigger() -> bool:
	var gold_need: bool = Gold.get_total_gold() >= 2000 
	var fac_count: bool = Clicker.get_upgrade_of_factory(FactoryName.TYPES.STUDY) >= 1
	return gold_need and fac_count
