class_name ExpeditionMenu
extends FactoryMenu

@export var expedition_info: ExpeditionInfo

@onready var expedition_popup: Popup = $ExpeditionFinishPopup
@onready var textbox: TextEdit = $ExpeditionFinishPopup/Container/TextEdit

@onready var end_game_panel: PopupPanel = $EndGamePanel
@onready var credits_scene: PackedScene = preload("res://UI/Credits.tscn")
var has_ended:bool = false

enum Progress { WAITING, ONGOING, FINISHED }
var on_expedition: Progress = Progress.WAITING

var party_members: Array = []

var efficiency: int = 0

func _ready():
	super()
	expedition_popup.hide()
	end_game_panel.hide()

func go_on_expedition(party: Array) -> void:
	Events.add_event("The expedition heads out.")
	party_members = party
	# Set members as away
	for c in party_members:
		Party.all_characters[c.get_character_name()].on_expedition = true
	
	timer.wait_time = expedition_info.expedition_time
	timer.start()
	on_expedition = Progress.ONGOING
	make_upgrade_button_text()
	var history = expedition_info.simulate_history(party_members)
	textbox.text = history[0]
	textbox.scroll_vertical = 0
	efficiency = history[1]
	efficiency = clampi(efficiency, -5, 5)

## Output
func do_output() -> void:
	on_expedition = Progress.FINISHED
	make_upgrade_button_text()




## Show menu when button pressed
func _on_upgrade_button_pressed() -> void:
	match on_expedition:
		Progress.WAITING:
			Party.show_expedition_menu(self, expedition_info)
		Progress.ONGOING:
			return
		Progress.FINISHED:
			expedition_popup.popup_centered(expedition_popup.size)
			emit_signal("output", factory_info.factory_type, efficiency)
			# increment count to scale rewards
			(Clicker.outputs[factory_info.factory_type] as FactoryInfo).count += 1




## Set upgrade text
func make_upgrade_button_text() -> void:
	var text: String = ""
	match on_expedition:
		Progress.WAITING:
			text = "Send Members"
			upgrade_button.disabled = false
		Progress.ONGOING:
			text = "Ongoing..."
			upgrade_button.disabled = true
		Progress.FINISHED:
			text = "Finished!"
			upgrade_button.disabled = false
	upgrade_button.text = text

func check_upgrade_button_usability() -> bool:
	return false

func set_upgrade_button_disabled() -> void:
	pass

func _on_close_button_pressed():
	expedition_popup.hide()
	on_expedition = Progress.WAITING
	make_upgrade_button_text()

func _on_expedition_finish_popup_popup_hide():
	Events.add_event("The expedition returned.")
	textbox.text = ""
	textbox.scroll_vertical = 0
	on_expedition = Progress.WAITING
	make_upgrade_button_text()
	
	for c in party_members:
		Party.all_characters[c.get_character_name()].on_expedition = false
	party_members = []
	Party.reinit_party_menu()
	## 
	if factory_info.factory_type == FactoryName.TYPES.TIME_ABYSS and not has_ended:
		has_ended = true
		end_game_panel.popup_centered(end_game_panel.size)

## End the game
func _on_end_button_pressed():
	end_game_panel.hide()
	get_tree().change_scene_to_packed(credits_scene)

## Return
func _on_return_button_pressed():
	end_game_panel.hide()
