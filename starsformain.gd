extends Node2D

@export var speed: float = 100.0   # how fast the star falls
@export var y_min: float = -520.0  # spawn range min Y
@export var y_max: float = 520.0   # spawn range max Y
@export var x_max: float = 945.0
@export var x_min: float = -945.0

func _ready():
	randomize()
	
	# random X inside viewport
	var random_x = randf_range(x_min,x_max)
	# random Y in given range
	var random_y = randf_range(y_min, y_max)
	
	position = Vector2(random_x, random_y)

func _process(delta):
	if Global.zenon_ref and Global.zenon_ref.faster:
		speed = 200

	if Global.zenon_ref and Global.zenon_ref.fastest:
		speed = 300
		
	if Global.zenon_ref and Global.zenon_ref.idle:
		speed = 100
			
	if Global.zenon_ref and Global.zenon_ref.slow:
		speed = 100
		
	position.y += speed * delta
	
	
	# if star goes below the viewport
	if position.y > 480:
		# reset back up with new random X
		position.x = randf_range(x_min,x_max)
		position.y = y_min
