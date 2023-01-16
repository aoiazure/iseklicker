extends Node

var gold_count: int = 0
var total_gold: int = 0
var total_spent: int = 0

# 
func set_gold(value) -> void:
	gold_count += value
	if value > 0:
		total_gold += value

# Get gold count
func get_gold() -> int:
	return gold_count

# Get total gold over lifetime
func get_total_gold() -> int:
	return total_gold

# Spend gold
func spend_gold(amount: int) -> void:
	set_gold(-1 * absi(amount))
	total_spent += absi(amount)

# Check if enough gold
func has_enough_gold_to_pay(amount) -> bool:
	return get_gold() >= amount
