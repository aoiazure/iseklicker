class_name PartyMenu
extends VBoxContainer

@onready var row_five: GridContainer = $Barracks/Container/FiveStars
@onready var row_four: GridContainer = $Barracks/Container2/FourStars
@onready var row_three: GridContainer = $Barracks/Container3/ThreeStars

@onready var display = preload("res://UI/CharacterDisplayButton.tscn")
@onready var blank = preload("res://assets/BlankQuestion.png")

func _ready():
	set_up_blanks()
	for c in Party.characters_in_party:
		add_to_menu(Party.all_characters[c])
	

func match_rarity(character: Character) -> Container:
	match character.character_info.rarity:
		CharacterInfo.Rarity.FIVE:
			return row_five
		CharacterInfo.Rarity.FOUR:
			return row_four
	return row_three


func set_up_blanks() -> void:
	for char_name in Party.all_characters.keys():
		var character: Character = Party.all_characters[char_name]
		var row: Container = match_rarity(character)
		var button: CharacterDisplayButton = display.instantiate()
		row.add_child(button)
		button.name = "%sButton" % char_name
		button.icon = blank
	pass


func add_to_menu(character: Character) -> void:
	var row: Container = match_rarity(character)
	for button in row.get_children():
		button = (button as CharacterDisplayButton)
		if character.get_character_name() in button.name:
			button.setup(character)
#	var button: CharacterDisplayButton = display.instantiate()
#	row.add_child(button)
#	button.setup(character)
#	button.custom_minimum_size = Vector2(80, 80)




