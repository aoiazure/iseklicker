class_name TriggerMarket
extends FactoryTrigger

func _init():
	associated_factory = FactoryName.TYPES.MARKET
	discover_text = "Now that you've built up some resources, it's time to see what others are willing to buy it for."

func has_met_trigger() -> bool:
	var gold_need: bool = Gold.get_total_gold() >= 40000 
	var fac_count: bool = Clicker.get_count_of_factory(FactoryName.TYPES.MINING) >= 3
	var fac_upgrade: bool = Clicker.get_upgrade_of_factory(FactoryName.TYPES.MINING) >= 1
	return gold_need and fac_count and fac_upgrade
