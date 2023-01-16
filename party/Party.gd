extends PopupPanel

signal start

@export var duplicate_protection: bool = true
@export_group("Characters")
@export var char_info: Array

@onready var info_label: RichTextLabel = $Body/VSplitContainer/InfoLabel
@onready var confirm_button: Button = $Body/ConfirmButton

@onready var CharacterSelect: PackedScene = preload("res://party/CharacterSelectNode.tscn")
@onready var party_menu: VBoxContainer = $Body/VSplitContainer/PartyMenu/PartyMenu

@onready var _character: PackedScene = preload("res://party/Character.tscn")


enum Action { VIEW, EXPEDITION }

var action_mode: Action = Action.VIEW


var expedition_ref: ExpeditionMenu
var max_selections: int = 1
var req_selections: int = 0
var num_selected: int = 0

###
# 25 characters so:
# 3 - 12	
# 4 - 8		Dawn, Hynjan, Jester, Mura, Orin, Rion, Thaddeus, Verity
# 5 - 5		Cyan, Epoch, Lilac, Ulther, Zeroth		(You)
### Character names
var all_characters: Dictionary = {
	"Abjura": null,		# 3 Light
	"Belle": null,		# 3 Physical
	"Cyan": null,		# 5 		Wind
	"Dawn": null,		# 4 	Fire
	"Epoch": null,		# 5 		Water
	"Falcon": null,		# 3 Fire
	"Gael": null,		# 3 Wind
	"Hynjan": null,		# 4 	Water
	"Iris": null,		# 3 Water
	"Jester": null,		# 4 	Light
	"Kynan": null,		# 3 Water
	"Lilac": null,		# 5 		Earth
	"Mura": null,		# 4 	Wind
	"Nova": null,		# 3 Light
	"Orin": null,		# 4 	Earth
	"Preston": null,	# 3 Physical
	"Quell": null,		# 3 Earth
	"Rion": null,		# 4 	Dark
	"Sai": null,		# 3 Fire
	"Thaddeus": null,	# 4 	Dark
	"Ulther": null,		# 5 		Fire
	"Verity": null,		# 4 	Light
	"Wendell": null,	# 3 Wind
	"Xander": null,		# 3 Dark
	"You": null,		# 5 		Physical
	"Zeroth": null,		# 5 		Dark
}



## Characters you own
var characters_in_party: Array = []



func _ready():
	self.visible = false
	create_all_characters()
	add_character_to_party(all_characters["You"])
	emit_signal("start")

func create_all_characters() -> void:
	for ci in char_info:
		# Ignore empties
		if not ci:
			continue
		ci = (ci as CharacterInfo)
		var _char: Character = _character.instantiate()
		_char.character_info = ci
		all_characters[ci.character_name] = _char


func summon_random_character() -> Character:
	var c: Character = Character.new()
	randomize()
	var roll: int = randi_range(1, 100)
	# 3
	if roll < 80:
		var a = get_all_of_rarity(CharacterInfo.Rarity.THREE)
		if a.size() > 0:
			return get_random_character_from_array(a)
	# 4
	if roll < 95:
		var a = get_all_of_rarity(CharacterInfo.Rarity.FOUR)
		if a.size() > 0:
			return get_random_character_from_array(a)
	# 5
	var a = get_all_of_rarity(CharacterInfo.Rarity.FIVE)
	if a.size() > 0:
		return get_random_character_from_array(a)
	return c

#
func get_random_character_from_array(a: Array) -> Character:
	var c: Character
	randomize()
	var i = randi_range(0, a.size() - 1)
	c = a[i]
	return c

#
func get_all_of_rarity(rarity: CharacterInfo.Rarity) -> Array:
	var a: Array = []
	
	for c in all_characters.values():
		if c is Character and (c as Character).character_info.rarity == rarity:
			var _name: String = c.character_info.character_name
			if not duplicate_protection:
				a.append(all_characters[_name])
			elif not character_is_in_party(_name):
				a.append(all_characters[_name])
	
	return a





## Add a character to your party and set up the menu
func add_character_to_party(character: Character, reinitialize: bool = true) -> void:
	if not character_is_in_party(character.character_info.character_name):
		characters_in_party.append(character.character_info.character_name)
		characters_in_party.sort_custom(custom_sort)
		
		if reinitialize:
			reinit_party_menu()

## Check if character in party
func character_is_in_party(_name: String) -> bool:
	return characters_in_party.has(_name)

## Expedition menu
func show_expedition_menu(expedition: ExpeditionMenu, info: ExpeditionInfo) -> void:
	reinit_party_menu()
	action_mode = Action.EXPEDITION
	expedition_ref = expedition
	## Enable views
	info_label.visible = true
	set_visible_checkboxes(true)
	confirm_button.visible = true
	# disable button since none selected
	confirm_button.disabled = true
	
	confirm_button.text = "Send Selected on Expedition"
	
	max_selections = info.max_members if info.max_members > 0 else 99999
	req_selections = info.members_required
	
	# If limited,
	if info.max_members < 99999:
		# And if you need to send a certain number of people
		if req_selections > 0:
			info_label.text = "Select at least %s characters to send, up to %s." % [req_selections, max_selections]
		# Otherwise, any number will do
		else:
			info_label.text = "Select any number of characters."
	# Otherwise, unlimited
	else: 
		# And if you need to send a certain number of people
		if req_selections > 0:
			info_label.text = "Select at least %s characters to send." % [req_selections]
		# Otherwise, any number will do
		else:
			info_label.text = "Select any number of characters."
	popup_centered(size)


## View menu
func show_view_menu() -> void:
	action_mode = Action.VIEW
	# Enable views
	info_label.visible = false
	set_visible_checkboxes(false)
	confirm_button.visible = false
	
	popup_centered(size)


## On confirm pressed
func _on_confirm_button_pressed():
	var selected: Array = get_all_selected_characters()
	expedition_ref.go_on_expedition(selected)
#	for c in selected:
#		(c as Character).on_expedition = true
	# Hide
	self.hide()




## Highlight and select and all that
func _on_character_selected(button_pressed: bool) -> void:
	# If you selected someone and not at max
	if num_selected < max_selections and button_pressed:
		num_selected += 1
	# If you deselected someone
	elif not button_pressed:
		num_selected = max(0, num_selected-1)
	
	confirm_button.disabled = (num_selected < req_selections) or (num_selected > max_selections)
	# Enable/disable all the others if you've selected the max or not 
	for label in party_menu.get_children():
		var check: CheckBox = (label as CharacterSelectNode).checkbox
		if not check.button_pressed:
			check.disabled = (num_selected == max_selections) or Party.all_characters[label.character_name].on_expedition


func get_all_selected_characters() -> Array:
	var a: Array = []
	for label in party_menu.get_children():
		if label.checkbox.button_pressed:
			a.append(all_characters[label.character_name])
	
	return a


## Enable or disable the visibility of checkboxes
func set_visible_checkboxes(visibility: bool) -> void:
	for label in party_menu.get_children():
		label.checkbox.visible = visibility

# Setup party menu in the right order
func reinit_party_menu() -> void:
	# remove them all, then re-add them
	for n in party_menu.get_children():
		party_menu.remove_child(n)
	
	for _name in characters_in_party:
		add_select(all_characters[_name])

## Add character to menu
func add_select(character: Character, visibility: bool = true) -> void:
	var char_select: CharacterSelectNode = CharacterSelect.instantiate()
	char_select.visible = visibility
	party_menu.add_child(char_select)
	char_select.init(character)
	
	char_select.checkbox.disabled = Party.all_characters[character.get_character_name()].on_expedition
	
	char_select.checkbox.connect("toggled", _on_character_selected)

## Custom sorts
func custom_sort(a, b) -> bool:
	if a == "You":
		return true
	elif b == "You":
		return false
	else:
		return a.naturalnocasecmp_to(b) < 0

func character_sort(a: Character, b: Character) -> bool:
	if a.character_info.character_name == "You":
		return true
	elif b.character_info.character_name == "You":
		return false
	else:
		return a.character_info.character_name.naturalnocasecmp_to(b.character_info.character_name) < 0

## Print all characters in party
func print_party():
	for _name in characters_in_party:
		print(_name)


func _on_popup_hide():
	# reset
	num_selected = 0
	for label in party_menu.get_children():
		label.checkbox.button_pressed = false
