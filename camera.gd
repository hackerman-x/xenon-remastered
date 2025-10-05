extends Camera2D

var shake_strength: float = 0.0
var shake_decay: float = 5.0
var start_x = 0
var start_y = 0
var target_x = 0
var target_y = 0
var moving = false

func _ready() -> void:
	start_x = position.x  # remember where the camera starts
	start_y = position.y

func start_shake(strength: float = 10.0):
	shake_strength = strength

func move_right():
	target_x = start_x + 25
	moving = true

func move_left():
	target_x = start_x - 25
	moving = true


func move_back():
	target_x = start_x
	moving = true

func _process(delta: float):
	if moving:
		position.x = lerp(position.x, target_x, 5 * delta)
		
		if abs(position.x - target_x) < 0.5:
			position.x = target_x
			moving = false
	
	if shake_strength > 0:
		offset = Vector2(randf_range(-shake_strength, shake_strength),
						 randf_range(-shake_strength, shake_strength))
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		offset = Vector2.ZERO
