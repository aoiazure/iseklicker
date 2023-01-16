class_name TriggerDelve
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.DELVE
	discover_text = "You found the entrance to a dungeon. Perhaps there's something to be found there..."

func has_met_trigger() -> bool:
	var gold_need: bool = Gold.get_total_gold() >= 1000
	var fac_count: bool = Clicker.get_count_of_factory(FactoryName.TYPES.VEGETABLE) >= 2
	var char_in_party: bool = Party.characters_in_party.size() >= 2
	return (gold_need and fac_count) or char_in_party
