class_name FactoryInfo
extends Resource

@export_category("Core")
@export var factory_name: String = "Factory Name"
@export var factory_type: FactoryName.TYPES

## Whether the factory creates automatically
@export var automated: bool = false
## How many of the factory you own
@export var count: int = 0
## Cost per
@export var buy_cost: int = 1
##
@export var growth_rate: float = 1.07
## How many upgrades you have purchased
@export var upgrade_count: int = 0
## How much upgrades cost more per upgrade already bought
@export var upgrade_cost_ratio: int = 10

@export_multiline var event_text

@export_group("Output")
## How much it gives by default
@export var base_output: int = 1
## Output rate every `output_rate` seconds
@export var output_rate: int = -1

var _event_occur_text: Array = []

func setup() -> FactoryInfo:
	if event_text:
		var t: PackedStringArray = event_text.split('\n')
		_event_occur_text.append_array(t)
	return self

## Calculate how much a factory will create
func calculate_output() -> int:
	var o: int
	o =  max(1, count+1) * (base_output * (upgrade_count+1))
	return o

# Calculate how much it costs to buy a new one
func calculate_buy_cost() -> int:
	var cost = buy_cost * pow(growth_rate, count)
	return ceili(cost)

# Calculate how much it costs to buy an upgrade
func calculate_upgrade_cost() -> int:
	var cost = upgrade_cost_ratio * pow(growth_rate, upgrade_count)
	return ceili(cost)

# Get random event text to play
func get_event_text() -> String:
	if _event_occur_text.size() == 0:
		return ""
	var i = randi_range(0, _event_occur_text.size() - 1)
	return _event_occur_text[i]


