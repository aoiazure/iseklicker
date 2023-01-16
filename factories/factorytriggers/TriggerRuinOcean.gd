class_name TriggerRuinOcean
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.RUIN_OCEAN
	discover_text = "Having looked now at the world from a great vantage, you realize that there is one place left to explore: the vast blue oceans. You have some letters to write."

func has_met_trigger() -> bool:
	var gold_need: bool = Gold.get_total_gold() >= 60000
	var fac_count: bool = Clicker.get_count_of_factory(FactoryName.TYPES.MARKET) >= 1
	var fac_need: bool = Clicker.get_upgrade_of_factory(FactoryName.TYPES.STUDY) >= 1
	var char_in_party: bool = Party.characters_in_party.size() >= 4
	return gold_need and fac_count and fac_need and char_in_party
