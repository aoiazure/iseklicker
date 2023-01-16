extends TextureButton

@onready var on_icon: Texture2D = preload("res://assets/sound-on.svg")
@onready var off_icon: Texture2D = preload("res://assets/sound-off.svg")

@onready var slider: HSlider = $PopupPanel/VBoxContainer/VolumeSlider

@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

var lowest: float = -48


func _on_pressed():
	$PopupPanel.popup_centered($PopupPanel.size)

func _on_volume_slider_value_changed(value):
	var volume_prop := lowest - ((float(slider.value) / float(slider.max_value)) * lowest)
	if slider.value == 0.0:
		volume_prop = -72
	AudioServer.set_bus_volume_db(_bus, volume_prop)

