extends Node

const UI_BLIP: String = "ui_blip"
const ui_blip_sounds: Array = [
	"res://assets/sounds/ui_feedback/African2.mp3",
	"res://assets/sounds/ui_feedback/African3.mp3",
	"res://assets/sounds/ui_feedback/Coffee1.mp3",
	"res://assets/sounds/ui_feedback/Coffee2.mp3",
	"res://assets/sounds/ui_feedback/Wood Block1.mp3",
	"res://assets/sounds/ui_feedback/Wood Block2.mp3"
]

const UI_MODERN: String = "ui_modern"
const ui_modern_sounds: Array = [
#	"res://assets/sounds/ui_feedback/Modern2.mp3",
#	"res://assets/sounds/ui_feedback/Modern3.mp3",
#	"res://assets/sounds/ui_feedback/Modern4.mp3",
	"res://assets/sounds/ui_feedback/Modern5.mp3",
	"res://assets/sounds/ui_feedback/Modern6.mp3",
	"res://assets/sounds/ui_feedback/Modern7.mp3",
]

@onready var sound_players = $SoundPlayers



func play_sound_category(category: String):
	for player in sound_players.get_children():
		player = (player as AudioStreamPlayer)
		if not player.playing:
			player.stream = get_sound_from_category(category)
			player.play()
			break


func play_sound_specific(sound_path: String):
	for player in sound_players.get_children():
		player = (player as AudioStreamPlayer)
		if not player.playing:
			player.stream = load(sound_path)
			player.play()
			break

func get_sound_from_category(sound_name: String) -> AudioStream:
	var sounds: Array
	match sound_name:
		UI_BLIP:
			sounds = ui_blip_sounds
		UI_MODERN:
			sounds = ui_modern_sounds
	var sound_path: String = sounds[randi_range(0, sounds.size()-1)]
	return load(sound_path)

func set_volume(value: bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value)


