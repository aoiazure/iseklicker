class_name CharacterDisplayButton
extends Button

@onready var info_popup: PopupPanel = $InfoPopup

@onready var profile_tx: TextureRect = $InfoPopup/Container/Split/Profile
@onready var icon_tx: TextureRect = $InfoPopup/Container/Split/Icon
@onready var info_label: RichTextLabel = $InfoPopup/Container/InfoLabel

var character: Character

func setup(c: Character = null):
	if not c:
		return
	
	character = c
	self.icon = character.character_info.skin_icon
	
	profile_tx.texture = c.character_info.skin_profile
	icon_tx.texture = c.character_info.skin_icon
	var _name: String = c.character_info.character_name
	var _bio : String = c.character_info.character_bio
	info_label.text = "[p align=center][b]%s[/b]\n\n[p align=left]%s" % [_name, _bio]
	info_popup.hide()


func _on_pressed():
	info_popup.popup_centered(info_popup.size)
