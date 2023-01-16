class_name CharacterInfo
extends Resource

enum Rarity { THREE, FOUR, FIVE }
enum AttackType { NONE, PHYSICAL, FIRE, WATER, WIND, EARTH, LIGHT, DARK }

@export var character_name: String = ""
@export var rarity: Rarity

@export_group("Lines")
@export_multiline var character_bio: String = ""
@export_multiline var summon_quote: String = ""

@export_group("Combat")
@export var attack_type: AttackType
@export var hp: int = 0
@export var exploration_skill: int = 0

@export_group("Skins")
@export var skin_icon: Texture2D
@export var skin_profile: Texture2D
