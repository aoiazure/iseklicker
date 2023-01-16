class_name TriggerTimeAbyss
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.TIME_ABYSS
	discover_text = "Having conquered all of the material plane, you know one thing very clearly: this world is not real. You know that you must find the true world. The depths of the world, now."

func has_met_trigger() -> bool:
	var gold_need: bool = Gold.get_total_gold() >= 150000
	var exp_mountain: bool = Clicker.get_count_of_factory(FactoryName.TYPES.RUIN_MOUNTAIN) >= 3
	var exp_ocean: bool = Clicker.get_count_of_factory(FactoryName.TYPES.RUIN_OCEAN) >= 3
	var char_in_party: bool = Party.characters_in_party.size() >= 10
	return (gold_need and exp_mountain and exp_ocean) or char_in_party
