class_name ExpeditionObstacle
extends Resource

@export var obstacle_name: String = "Obstacle"
@export_multiline var encounter_text: String = "" 
## Should be an even number
@export var obstacle_hp: int = 4

@export var damage_type: CharacterInfo.AttackType = CharacterInfo.AttackType.NONE
## Doubles damage
@export var weakness_type: CharacterInfo.AttackType
## Halves damage
@export var resistance_type: CharacterInfo.AttackType
