extends Area2D

var Xenon = preload("res://Zenon.tscn")
var Explosion = preload("res://enemy_explosion.tscn")
@export var go_speed := 200



@export var speed: float = 1.0     # how fast it loops
@export var amplitude_x: float = 100.0
@export var amplitude_y: float = 50.0
@export var approach_speed: float = 0.5   # how fast it moves toward Zenon's Y

var t: float = 0.0
var base_position: Vector2

func _ready() -> void:
	# Center of the screen
	base_position = Vector2(0, -500)

func _process(delta: float) -> void:
	# Time keeps going
	t += delta * speed

	# Infinity symbol motion
	var offset_x = sin(t) * amplitude_x
	var offset_y = sin(t) * cos(t) * amplitude_y

	# Get Zenon
	var zenon = get_tree().root.get_node("Main/Zenon")
	if zenon:
		# Slowly move base Y toward Zenon's Y
		base_position.y = lerp(base_position.y, zenon.global_position.y, delta * approach_speed)

	# Update position
	global_position = base_position + Vector2(offset_x, offset_y)


func explode():
	# Spawn the explosion
	var explosion = Explosion.instantiate()
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)

	# Remove the enemy itself
	queue_free()
	

func _on_area_entered(_area: Area2D) -> void:
	pass
