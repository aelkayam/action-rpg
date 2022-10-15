extends Control

var max_hearts setget set_max_hearts
var hearts setget set_hearts

onready var hearts_ui_empty: TextureRect = $HeartsUIEmpty
onready var hearts_ui_full: TextureRect = $HeartsUIFull


func set_hearts(value: int) -> void:
	hearts = value
	if hearts_ui_full != null:
		hearts_ui_full.margin_right = hearts * 15


func set_max_hearts(value: int) -> void:
	max_hearts = value
	if hearts_ui_empty != null:
		hearts_ui_empty.margin_right = max_hearts * 15


func _ready() -> void:
	set_max_hearts(PlayerStats.max_health)
	set_hearts(PlayerStats.health)
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_change", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_change", self, "set_max_hearts")
