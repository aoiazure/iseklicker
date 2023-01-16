class_name ExpeditionInfo
extends Resource

@export var members_required: int = 0
@export var max_members: int = 0

@export var expedition_time: float = 99.0

@export_group("Events")
@export var random_events: Array = []

@export var obstacles: Array = []

## Simulates expedition history
func simulate_history(party: Array) -> Array:
	print("Expedition size: %s" % party.size())
	var _log: String = ""
	var history: PackedStringArray = PackedStringArray()
	var efficiency: int = 0
	var exp_length: int = max(2, randi_range(0, obstacles.size()))
	for i in range(exp_length):
		randomize()
		## Do X random events between every obstacle
		var expedition_length: int = randi_range(2, random_events.size())
		for j in range(expedition_length):
			var event: ExpeditionEvent = get_random_event()
			var character: Character = get_random_character_in_party(party)
			var s: String = event.event_text % character.get_character_name()
			
			history.append(s)
			efficiency += event.result
		
		## tackle obstacle
		history.append("\n--- Encounter! ---")
		
		var obstacle: ExpeditionObstacle = get_random_obstacle()
		var obstacle_hp: int = 0+obstacle.obstacle_hp
		var encounter_text = obstacle.encounter_text
		history.append("%s" % encounter_text)
		
		# how many turns you have to use before you lose out on things
		var timer: int = ceil(obstacle_hp/4)+1
		# combat loop
		while obstacle_hp > 0:
			timer -= 1
			# loop through party turn:
			for idx in range(party.size()):
				var character: Character = party[idx]
				var damage = 2
				var text: String = "%s uses their %s against the %s. " % [character.get_character_name(),
					match_character_attack_type(character), obstacle.obstacle_name]
				if character.get_attack_type() == obstacle.weakness_type:
					damage *= 2
					text += "It was critically effective!"
				elif character.get_attack_type() == obstacle.resistance_type:
					damage /= 2
					text += "It wasn't very good against it."
				history.append(text)
				## Deal damage and break out if you're settled
				obstacle_hp -= damage
				if obstacle_hp <= 0:
					break
		
		# End obstacles
		if timer > 0:
			history.append("\nFortunately, the fight was wrapped up quickly.")
		elif timer == 0:
			history.append("\nThe party got past the encounter.")
		else:
			history.append("\nThe fight was brutally difficult, draining a lot of supplies.")
		history.append("")
		efficiency += timer
	
	# End of events
	history.append("The expedition returns.")
	if efficiency > 0:
		history.append("It was very bountiful!")
	elif efficiency == 0:
		history.append("They got some good loot for the cave.")
	else:
		history.append("They didn't get as much as they would have liked.")
	
	_log = "\n".join(history)
	return [_log, efficiency]




func get_random_event() -> ExpeditionEvent:
	return random_events[randi_range(0, random_events.size() - 1)]

func get_random_obstacle() -> ExpeditionObstacle:
	return obstacles[randi_range(0, obstacles.size() - 1)]

func get_random_character_in_party(party: Array) -> Character:
	return party[randi_range(0, party.size()-1)]


func match_character_attack_type(character: Character) -> String:
	match character.character_info.attack_type:
		CharacterInfo.AttackType.PHYSICAL:
			return "physical attacks"
		CharacterInfo.AttackType.FIRE:
			return "fire magics"
		CharacterInfo.AttackType.WATER:
			return "water magics"
		CharacterInfo.AttackType.WIND:
			return "wind magics"
		CharacterInfo.AttackType.EARTH:
			return "earth magics"
		CharacterInfo.AttackType.LIGHT:
			return "light magics"
		CharacterInfo.AttackType.DARK:
			return "dark magics"
	return "attacks"


