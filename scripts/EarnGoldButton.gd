extends Button

signal earn_gil

func _process(delta):
	disabled = Party.all_characters["You"].on_expedition

func _on_pressed():
	emit_signal("earn_gil")


