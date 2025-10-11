extends Node2D

@export var speed: float = 0.1   # how fast the star falls
@export var y_min: float = -320.0  # spawn range min Y
@export var y_max: float = -325.0   # spawn range max Y
@export var x_max: float = 600.0
@export var x_min: float = -900.0

func _ready():
	
	# random X inside viewport
	var random_x = randf_range(x_min,x_max)
	# random Y in given range
	var random_y = randf_range(y_min, y_max)
	
	position = Vector2(random_x, random_y)

func _process(delta):
	if Global.zenon_ref and Global.zenon_ref.faster:
		speed = 0.2

	if Global.zenon_ref and Global.zenon_ref.fastest:
		speed = 0.3
		
	if Global.zenon_ref and Global.zenon_ref.idle:
		speed = 0.1
			
	if Global.zenon_ref and Global.zenon_ref.slow:
		speed = 0.1
		
	position.y += speed * delta
	
	
	# if star goes below the viewport
	if position.y > 480:
		# reset back up with new random X
		position.x = randf_range(x_min,x_max)
		position.y = y_min
