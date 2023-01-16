class_name Character
extends Node

@export var character_info: CharacterInfo

@onready var character_icon: Sprite2D = $CharacterIcon

var on_expedition: bool = false

func _ready():
	set_skin_icon(character_info.skin_icon)

func set_skin_icon(value) -> void:
	character_icon.texture = value

func set_skin_profile(value: Texture2D) -> void:
	pass

func get_character_name() -> String:
	return character_info.character_name

func get_attack_type() -> int:
	return character_info.attack_type
