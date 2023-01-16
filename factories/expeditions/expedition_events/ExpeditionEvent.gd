class_name ExpeditionEvent
extends Resource

enum Result { NEGATIVE=-1, NEUTRAL=0, POSITIVE=1}

@export_multiline var event_text: String = "%s"
@export var result: Result
