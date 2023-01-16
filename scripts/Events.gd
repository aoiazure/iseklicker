extends Node

signal screen_shake(strength, decay_rate)

signal event(event_text)

signal factory_discovered(factory_name)

signal factory_bought(factory_name)
signal factory_upgraded(factory_name)

## Add an event to the console
func add_event(event_text: String) -> void:
	if len(event_text) == 0:
		return
	emit_signal("event", event_text)


## Manage all this good stuff
func discover_factory(factory: int) -> void:
	emit_signal("factory_discovered", factory)

func buy_factory(factory: int) -> void:
	emit_signal("factory_bought", factory)

func upgrade_factory(factory: int) -> void:
	emit_signal("factory_upgraded", factory)

func screenshake(strength: float, decay: float) -> void:
	emit_signal("screen_shake", strength, decay)
