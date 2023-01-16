extends VSplitContainer

signal summon_finished(character)

@onready var summon_button: Button = $Buttons/SummonButton

@onready var summon_dialog_popup: Popup = $SummonDialogPopup
@onready var info_popup: Popup = $InfoPopup
@onready var cost_label := $SummonDialogPopup/Body/Label


@onready var summon_popup: Popup = $SummonPopup
@onready var summon_timer: Timer = $SummonPopup/Timer
@onready var name_label: RichTextLabel = $SummonPopup/Container/NameLabel
@onready var stars_label: Label = $SummonPopup/Container/StarsLabel
@onready var summon_dialog: Label = $SummonPopup/Container/SummonTextLabel
@onready var art: TextureRect = $SummonPopup/Container/SummonArt
@onready var close_button: Button = $SummonPopup/Container/CloseButton

@onready var blank_art: Texture2D = preload("res://assets/Blank192.png")

@onready var ap: AnimationPlayer = $SummonPopup/AnimationPlayer


var is_summoning: bool = false

@export var summon_cost: int = 500
@export var growth_rate: float = 1.5
var times_summoned: int = 0


func _ready():
	summon_dialog_popup.visible = false
	summon_popup.visible = false


func _process(delta):
	if summon_popup.visible != is_summoning:
		summon_popup.popup_centered(summon_popup.size)
	if summon_dialog_popup.visible:
		var d = (Gold.get_gold() < calculate_summon_cost()) or (Party.characters_in_party.size() == 26)
		$SummonDialogPopup/Body/Buttons/ConfirmSummonButton.disabled = d
	# Disable summon if you've maxed out
	if Party.duplicate_protection:
		summon_button.disabled = (Party.characters_in_party.size() == Party.all_characters.keys().size())


## Set the cost
func set_summon_cost(cost: int) -> void:
	summon_cost = cost
	cost_label.text = "Do you want to summon?\nCost: [%s gold]" % cost

func calculate_summon_cost() -> int:
	return ceil(summon_cost * pow(growth_rate, times_summoned))


## Pull info
func _on_info_button_pressed():
	info_popup.popup_centered(info_popup.size)


### SUMMONING
## Press Summon Button
func _on_summon_button_pressed():
	var d = (Gold.get_gold() < calculate_summon_cost()) or (Party.characters_in_party.size() == 26)
	$SummonDialogPopup/Body/Buttons/ConfirmSummonButton.disabled = d
	cost_label.text="Do you want to summon?\nCost: [%s gold]" % calculate_summon_cost()
	summon_dialog_popup.popup_centered(summon_dialog_popup.size)

## On Confirm you want to summon
func _on_confirm_button_pressed():
	# Close
	summon_dialog_popup.hide()
	# Spend da money
	Gold.spend_gold(calculate_summon_cost())
	# Do da summon here
	perform_summon()

## Cancel
func _on_cancel_button_pressed():
	summon_dialog_popup.hide()

## Perform da summon
func perform_summon() -> void:
	times_summoned += 1
	is_summoning = true
	# Set blank/hidden
	art.texture = blank_art
	name_label.visible = false
	summon_dialog.visible = false
	close_button.visible = false
	# Show menu
	summon_popup.popup_centered(summon_popup.size)
	# Ease
	summon_timer.start()
	Events.screenshake(15, 1)
	await summon_timer.timeout
	# Set infos
	var character: Character = Party.summon_random_character()
	
	var char_name: String = (character as Character).character_info.character_name
	name_label.text = "[p align=center][b]%s[/b]!" % char_name
	var char_summon: String = (character as Character).character_info.summon_quote
	summon_dialog.text = "\"%s\"" % char_summon
	# Play anim
	var rarity: CharacterInfo.Rarity = character.character_info.rarity
	match rarity:
		CharacterInfo.Rarity.THREE:
			ap.play("three_star")
			for i in range(3):
				await get_tree().create_timer(0.2).timeout
				Events.screenshake(5, 5)
		
		CharacterInfo.Rarity.FOUR:
			ap.play("four_star")
			for i in range(4):
				await get_tree().create_timer(0.3).timeout
				Events.screenshake(5, 5)
		
		CharacterInfo.Rarity.FIVE:
			ap.play("five_star")
			for i in range(4):
				await get_tree().create_timer(0.4).timeout
				Events.screenshake(5, 5)
	await get_tree().create_timer(0.5).timeout
	
	SoundPlayer.play_sound_specific("res://assets/sounds/Retro10.mp3")
	
	# Show visible
	art.texture = (character as Character).character_info.skin_profile
	name_label.visible = true
	summon_dialog.visible = true
	close_button.visible = true
	
	Events.screenshake(30, 3)
	Party.add_character_to_party(character)
	
	ap.play("show_summon_text")
	await ap.animation_finished
	
	is_summoning = false
	emit_signal("summon_finished", character)


func _on_close_button_pressed():
	summon_popup.hide()
	stars_label.visible_characters = 0

func _on_summon_popup_popup_hide():
	stars_label.visible_characters = 0
