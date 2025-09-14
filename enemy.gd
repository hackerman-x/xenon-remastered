extends Area2D

var Xenon = preload("res://Zenon.tscn")
var Explosion = preload("res://enemy_explosion.tscn")
@export var go_speed := 200



var orbit_speed := 2.0
var orbit_radius := 80.0
var angle := 0.0
var approach_speed: float = 1   # how fast it moves toward Zenon's Y\
var in_orbit := false

var t: float = 0.0
var base_position: Vector2

func _ready() -> void:
	# Center of the screen
	base_position = Vector2(0, -500)

func _physics_process(delta: float) -> void:
	var zenon := get_tree().root.get_node("Main/Zenon")
	var direction = zenon.global_position - global_position
	var distance = direction.length()
	if not in_orbit:
		if distance > orbit_radius:
			position += direction * approach_speed * delta
		else:
			# Enter orbit
			in_orbit = true
			angle = (global_position - zenon.global_position).angle()
	else:
		# If Zenon is too far, stop orbiting
		if distance > orbit_radius * 1.5:
			in_orbit = false
		else:
			# Instead of snapping, MOVE toward the orbit point
			angle += orbit_speed * delta
			var target_pos = zenon.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius
			global_position = global_position.lerp(target_pos, 0.05) # smooth transition

	
func explode():
	# Spawn the explosion
	var explosion = Explosion.instantiate()
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)

	# Remove the enemy itself
	queue_free()
	

func _on_area_entered(_area: Area2D) -> void:
	pass
