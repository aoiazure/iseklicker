class_name CharacterSelectNode
extends Panel

@onready var checkbox: CheckBox = $HSplitContainer/CheckBox
@onready var character_details: Label = $HSplitContainer/Label

var character: Character : set = set_character
var character_name: String = ""

func init(_char: Character):
	if not character_details:
		await character_details.ready
	set_character(_char)

func set_character(value: Character) -> void:
	character = value
	character_name = value.get_character_name()
	checkbox.icon = value.character_info.skin_profile
	if Party.all_characters[character_name].on_expedition:
		checkbox.text = "On Expedition"
	else:
		checkbox.text = "Send %s" % value.character_info.character_name
	character_details.text = value.character_info.character_bio


