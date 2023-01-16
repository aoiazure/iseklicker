class_name FactoryMenu
extends Control

signal output(factory, specific_amount)

@export var factory_info: FactoryInfo = FactoryInfo.new() : set = update_info

@export_file("*.mp3") var sound: String

## Name label
@onready var fac_name_label: RichTextLabel = $FactoryNameLabel

## Buttons
@onready var buy_button: Button = $Interactions/BuyButton
@onready var upgrade_button: Button = $Interactions/UpgradeButton
## 
@onready var prog_bar: ProgressBar = $Interactions/ProgressBar

@onready var timer: Timer = $Timer

func _ready():
	update_info(factory_info)
	add_to_group("factories", true)


## Move prog bar
func _process(delta):
	if not timer.is_stopped():
		if not prog_bar.visible:
			prog_bar.visible = true
		var prog: float =  prog_bar.max_value - ((timer.time_left / timer.wait_time) * (prog_bar.max_value))
		prog_bar.value = prog
	else:
		prog_bar.visible = false
	
	set_buy_button_disabled()
	set_upgrade_button_disabled()



## Make sure the UI reflects the state of things
func update_info(value: FactoryInfo) -> void:
	# Set the value
	factory_info = value
	
	if not fac_name_label:
		await $FactoryNameLabel.ready
	## Factory Name
	var fac_name: String = factory_info.factory_name
	var upgrade_count: int = factory_info.upgrade_count
	if upgrade_count > 0:
		fac_name = "%s +%s" % [fac_name, upgrade_count]
	
	var count = ""
	if factory_info.count > 0:
		count = " (x%s)" % factory_info.count
	if not fac_name_label:
		await $FactoryNameLabel.ready
	fac_name_label.text = "[p align=center][b]%s[/b]%s" % [fac_name, count]
	
	## Buy Button
	var buy_cost: int = factory_info.calculate_buy_cost()
	buy_button.text = "Buy 1 (%s)" % buy_cost
	## Upgrade Button
	make_upgrade_button_text()
	upgrade_button.disabled = check_upgrade_button_usability()
	## Timer
	if factory_info.output_rate > 0:
		timer.wait_time = factory_info.output_rate
		if factory_info.count > 0 and timer.is_stopped():
			timer.start()
	## Progress Bar
	show_progress_bar()

## Set upgrade text
func make_upgrade_button_text() -> void:
	var upgrade_cost: int = factory_info.calculate_upgrade_cost()
	upgrade_button.text = "Enhance (%s)" % upgrade_cost

## Check if upgrade button can be used
func check_upgrade_button_usability() -> bool:
	return (factory_info.count == 0)

##
func show_progress_bar() -> void:
	if factory_info.output_rate <= 0:
		prog_bar.visible = false



func _on_buy_button_pressed():
	Events.buy_factory(factory_info.factory_type)

func _on_upgrade_button_pressed():
	Events.upgrade_factory(factory_info.factory_type)



func _on_timer_timeout():
	do_output()
	# 
	prog_bar.value = 0
	if sound:
		SoundPlayer.play_sound_specific(sound)
	else:
		SoundPlayer.play_sound_category(SoundPlayer.UI_BLIP)

func do_output() -> void:
	emit_signal("output", factory_info.factory_type)


func set_buy_button_disabled() -> void:
	buy_button.disabled = (Gold.get_gold() < factory_info.calculate_buy_cost())

func set_upgrade_button_disabled() -> void:
	var gold: bool = (Gold.get_gold() < factory_info.calculate_upgrade_cost())
	var count: int = Clicker.get_count_of_factory(factory_info.factory_type) < 1
	upgrade_button.disabled = gold or count
