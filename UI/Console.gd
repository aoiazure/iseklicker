class_name ConsoleLog
extends TextEdit

var max_size: int = 30
var text_in_console: Array = []


func _ready():
	# Connect to Event
	Events.connect("event", add_event)

## Console
func add_event(event: String) -> void:
	var length = text_in_console.size()
	
	var _time = Time.get_time_dict_from_system()
	var hr = _time.hour
	if hr < 10:
		hr = "0"+str(hr)
	var minute = _time.minute
	if minute < 10:
		minute = "0"+str(minute)
	var time = "%s:%s" % [hr, minute]
	
	if length >= max_size:
		text_in_console.pop_front()
	
	text_in_console.append("[%s] %s" % [time, event])
	self.text = "\n".join(PackedStringArray(text_in_console))
	
	if int(scroll_vertical) != text_in_console.size():
		scroll_vertical = text_in_console.size()
