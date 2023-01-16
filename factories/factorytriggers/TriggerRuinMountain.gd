class_name TriggerRuinMountain
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.RUIN_MOUNTAIN
	discover_text = "Settled with great rewards from your travels, you set your eyes on a new destination: the mountaintops."

func has_met_trigger() -> bool:
	var gold_need: bool = Gold.get_total_gold() >= 30000
	var fac_count: bool = Clicker.get_count_of_factory(FactoryName.TYPES.MINING) >= 2
	var fac_need: bool = Clicker.get_upgrade_of_factory(FactoryName.TYPES.STUDY) >= 1
	var exp_delve: bool = Clicker.get_count_of_factory(FactoryName.TYPES.DELVE) >= 2
	var char_in_party: bool = Party.characters_in_party.size() >= 2
	return (gold_need and fac_count and fac_need) or exp_delve or char_in_party
