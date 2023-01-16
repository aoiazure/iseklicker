extends Panel

@onready var gold_count_label: GoldCountLabel = $UI/Column1/GoldCountUI

## Columns
# 1
@onready var column1: Control = $UI/Column1
@onready var vsep1: Control = $UI/VSeparator
# 2
@onready var column2: Control = $UI/Column2
@onready var vsep2: Control = $UI/VSeparator2
# 3
@onready var column3: Control = $UI/Column3
@onready var vsep3: Control = $UI/VSeparator3
# 4
@onready var column4: Control = $UI/Column4
#@onready var vsep4: Control = $UI/VSeparator4

@onready var summon_panel: Control = $UI/Column1/TabContainer/Summon
@onready var party_menu: PartyMenu = $UI/Column4/PartyMenu

## Menus to upgrade
@onready var _manual_factory_upgrade: FactoryMenu = $UI/Column2/Scroll/Container/ManualMenu
@onready var _free_factory_upgrade: FactoryMenu = $UI/Column2/Scroll/Container/FreelanceMenu
@onready var _veggie_factory_upgrade: FactoryMenu = $UI/Column2/Scroll/Container/VeggieMenu
@onready var _study_factory_upgrade: FactoryMenu = $UI/Column2/Scroll/Container/StudyMenu
@onready var _mining_factory_upgrade: FactoryMenu = $UI/Column2/Scroll/Container/MiningMenu
@onready var _market_factory_upgrade: FactoryMenu = $UI/Column2/Scroll/Container/MarketMenu

## Expedition menus
@onready var _delve_menu: ExpeditionMenu = $UI/Column3/Scroll/Container/DelveMenu
@onready var _mountain_menu: ExpeditionMenu = $UI/Column3/Scroll/Container/MountainMenu
@onready var _ocean_menu: ExpeditionMenu = $UI/Column3/Scroll/Container/OceanMenu
@onready var _abyss_menu: ExpeditionMenu = $UI/Column3/Scroll/Container/AbyssMenu


## MASTER GIL
# gold tracked in Gold.gd

var manual_timer: Timer

# RATIOS
var outputs: Dictionary = {
	FactoryName.TYPES.MANUAL: preload("res://factories/info/FactoryManual.tres"),
	## Auto Factories
	FactoryName.TYPES.FREELANCE: preload("res://factories/info/FactoryFreelance.tres"),
	FactoryName.TYPES.VEGETABLE: preload("res://factories/info/FactoryVegetable.tres"),
	FactoryName.TYPES.STUDY: preload("res://factories/info/FactoryStudy.tres"),
	FactoryName.TYPES.MINING: preload("res://factories/info/FactoryMining.tres"),
	FactoryName.TYPES.MARKET: preload("res://factories/info/FactoryMarket.tres"),
	## Expeditions
	FactoryName.TYPES.DELVE: preload("res://factories/info/FactoryDelve.tres"),
	FactoryName.TYPES.RUIN_MOUNTAIN: preload("res://factories/info/FactoryRuinMountain.tres"),
	FactoryName.TYPES.RUIN_OCEAN: preload("res://factories/info/FactoryRuinOcean.tres"),
	FactoryName.TYPES.TIME_ABYSS: preload("res://factories/info/FactoryTimeAbyss.tres"),
}

# EVENTS
var events: Dictionary = {
	## Auto facs
	"has_freelance": TriggerFreelance.new(),
	"has_veggie_farm": TriggerVegetableFarm.new(),
	"has_study": TriggerStudy.new(),
	"has_mining": TriggerMining.new(),
	"has_market": TriggerMarket.new(),
	## Expeditions
	"has_delve": TriggerDelve.new(),
	"has_mountain": TriggerRuinMountain.new(),
	"has_ocean": TriggerRuinOcean.new(),
	"has_abyss": TriggerTimeAbyss.new(),
}




#
func _ready(): 
	if not Party:
		await Party.ready
	## Connect
	Events.connect("factory_discovered", discover_factory)
	Events.connect("factory_bought", buy_factory)
	Events.connect("factory_upgraded", buy_upgrade)
	summon_panel.connect("summon_finished", add_to_party)
	summon_panel.connect("summon_finished", party_menu.add_to_menu)
	
	column3.visible = false
	vsep3.visible = false
	column4.visible = false
	
	var facs = get_tree().get_nodes_in_group("factories")
	for f in facs:
		f.connect("output", _on_factory_output)
	## for manual clicking
	manual_timer = Timer.new()
	manual_timer.wait_time = 1.0
	manual_timer.one_shot = true
	add_child(manual_timer)
	## Set resources for upgrade menus
	update_outputs()
	
	for key in outputs.keys():
		outputs[key] = (outputs[key] as FactoryInfo).setup()

#
func _process(delta):
	_check_for_events()
#	if Input.is_action_just_pressed("cheat"):
#		set_gold(10000)
#
#	Engine.time_scale = 8.0 if Input.is_action_pressed("speed_up") else 1.0

## Check for milestones and the like
func _check_for_events() -> void:
	if events.size() == 0:
		return
	for trigger in events.values():
		trigger = (trigger as FactoryTrigger)
		if not trigger.has_happened():
			if trigger.has_met_trigger():
				trigger.set_happened(true)
				events.erase(trigger)

## Check if an event has happened
func has_event_occurred(event_name: String) -> bool:
	if name not in events.keys():
		return false
	
	return events[event_name]

## Update UI details whenever something is bought
func update_outputs() -> void:
	# Auto facs
	(_manual_factory_upgrade as FactoryMenu).update_info(outputs[FactoryName.TYPES.MANUAL])
	(_free_factory_upgrade as FactoryMenu).update_info(outputs[FactoryName.TYPES.FREELANCE])
	(_veggie_factory_upgrade as FactoryMenu).update_info(outputs[FactoryName.TYPES.VEGETABLE])
	(_study_factory_upgrade as FactoryMenu).update_info(outputs[FactoryName.TYPES.STUDY])
	(_mining_factory_upgrade as FactoryMenu).update_info(outputs[FactoryName.TYPES.MINING])
	(_market_factory_upgrade as FactoryMenu).update_info(outputs[FactoryName.TYPES.MARKET])


## 
func add_to_party(character: Character) -> void:
	if not column4.visible:
		column4.visible = true
	pass

## 
func discover_factory(name_of_factory: FactoryName.TYPES) -> void:
	if name_of_factory > 4:
		column3.visible = true
		vsep3.visible = true
	
	match name_of_factory:
		# Autos
		FactoryName.TYPES.FREELANCE:
			_free_factory_upgrade.visible = true
		FactoryName.TYPES.VEGETABLE:
			_veggie_factory_upgrade.visible = true
		FactoryName.TYPES.STUDY:
			_study_factory_upgrade.visible = true
		FactoryName.TYPES.MINING:
			_mining_factory_upgrade.visible = true
		FactoryName.TYPES.MARKET:
			_market_factory_upgrade.visible = true
		# Expeditions
		FactoryName.TYPES.DELVE:
			_delve_menu.visible = true
		FactoryName.TYPES.RUIN_MOUNTAIN:
			_mountain_menu.visible = true
		FactoryName.TYPES.RUIN_OCEAN:
			_ocean_menu.visible = true
		FactoryName.TYPES.TIME_ABYSS:
			_abyss_menu.visible = true
	pass

## Purchase a new factory
func buy_factory(name_of_factory: int) -> void:
	var factory: FactoryInfo = get_factory_info(name_of_factory)
	var cost: int = (factory as FactoryInfo).calculate_buy_cost()
	# if you can afford it
	if Gold.has_enough_gold_to_pay(cost):
		spend_gold(cost)
		(outputs[name_of_factory] as FactoryInfo).count += 1
	update_outputs()

## Purchasing upgrades and the like
func buy_upgrade(name_of_upgrade: FactoryName.TYPES) -> void:
	var factory: FactoryInfo = get_factory_info(name_of_upgrade)
	var cost: int = (factory as FactoryInfo).calculate_upgrade_cost()
	# if you can afford it
	if Gold.has_enough_gold_to_pay(cost):
		spend_gold(cost)
		(outputs[name_of_upgrade] as FactoryInfo).upgrade_count += 1
	update_outputs()

# Double check the upgrade exists in the thing
func has_factory_data(name_of_upgrade: int) -> bool:
	return name_of_upgrade in outputs.keys()

# Get upgrade info
func get_factory_info(name_of_upgrade: int) -> FactoryInfo:
	if not has_factory_data(name_of_upgrade):
		return FactoryInfo.new()
	return outputs[name_of_upgrade]

# Get number of factory owned
func get_count_of_factory(name_of_factory: FactoryName.TYPES) -> int:
	return get_factory_info(name_of_factory).count

# Get factory upgrades
func get_upgrade_of_factory(name_of_factory: FactoryName.TYPES) -> int:
	return get_factory_info(name_of_factory).upgrade_count

## Add or subtract gold
func set_gold(value) -> void:
	Gold.set_gold(value)

## Return how much gold you currently have
func get_gold() -> int:
	return Gold.gold_count

## Spend gold
func spend_gold(value) -> void:
	Gold.spend_gold(value)



func _on_factory_output(factory, percent_diff: float = 0):
	var info: FactoryInfo = get_factory_info(factory)
	var output: int = info.calculate_output()
	
	if percent_diff != 0:
		output += (output * (percent_diff/10.0))
	
	set_gold(output)
	Events.add_event(info.get_event_text())


## MANUAL
func _on_earn_gil_button_earn_gil():
	var _manual_info: FactoryInfo = get_factory_info(FactoryName.TYPES.MANUAL)
	var _output: int = _manual_info.calculate_output()
	set_gold(_output)
	if manual_timer.is_stopped():
		Events.add_event(_manual_info.get_event_text())
		SoundPlayer.play_sound_category(SoundPlayer.UI_MODERN)
		manual_timer.start()

