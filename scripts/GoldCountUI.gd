class_name GoldCountLabel
extends VSplitContainer

@onready var gold_count_label: Button = $GoldCountLabel
@onready var name_label: RichTextLabel = $TopRow/GoldCount
@onready var toggle_button: TextureButton = $TopRow/ToggleGoldButton

enum {CURRENT, TOTAL}
var mode: int = CURRENT

func _process(_delta):
	update_gold_count()


func update_gold_count() -> void:
	match mode:
		CURRENT:
			gold_count_label.text = "%s" % Gold.get_gold()
		TOTAL:
			gold_count_label.text = "%s" % Gold.get_total_gold()




func _on_total_gold_button_pressed():
	match mode:
		CURRENT:
			mode = TOTAL
			name_label.text = "[p align=center][b][u]LIFETIME GOLD[/u][/b]"
		TOTAL:
			mode = CURRENT
			name_label.text = "[p align=center][b][u]GOLD[/u][/b]"
	update_gold_count()
