extends Camera2D

onready var top_left_position: Position2D = $Limits/TopLeftPosition
onready var bottom_right_position: Position2D = $Limits/BottomRightPosition


func _ready() -> void:
	limit_top = top_left_position.position.y as int
	limit_left = top_left_position.position.x as int
	limit_bottom = bottom_right_position.position.y as int
	limit_right = bottom_right_position.position.x as int
