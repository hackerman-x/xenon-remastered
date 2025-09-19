extends RigidBody2D

var Explosion = preload("res://enemy_explosion.tscn")

@export var health := 5
var min_distance := 50
var orbit_speed := 1.5
var orbit_radius := 120.0
var angle := 0.0
var approach_speed: float = 0.8   # how fast it moves toward Zenon's Y\
var in_orbit := false
var base_position: Vector2

func _ready() -> void:
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
	#if area.is_in_group("Enemies"):
		#var push = (global_position - area.global_position).normalized() * 10
		#global_position += push
		pass



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		if health == 1:
			var explosion = Explosion.instantiate()
			explosion.global_position = global_position
			get_tree().root.add_child(explosion)
			# Remove the enemy itself
			queue_free()
		elif health > 0:
			health -= 1
			print(health)
