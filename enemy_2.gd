extends RigidBody2D

var Explosion = preload("res://enemy_explosion.tscn")
var BulletScene = preload("res://EnemyLaser.tscn")

@export var health := 5
var can_shoot := true
var last_x: float = 0.0
var moving_left: bool = false
var moving_right: bool = false
var min_distance := 50
var orbit_speed := 1.5
var orbit_radius := 120.0
var angle := 0.0
var approach_speed: float = 0.8   # how fast it moves toward Zenon's Y\
var in_orbit := false
var base_position: Vector2

func _ready() -> void:
	base_position = Vector2(0, -500)
	last_x = global_position.x


func _physics_process(delta: float) -> void:
	var zenon = get_tree().root.get_node_or_null("Main/Zenon")

	if zenon:  # only runs if Zenon is still in the scene
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
				
	var x_speed = global_position.x - last_x
	
	# Moving LEFT
	if x_speed < 0:
		if not moving_left:
			$Enemy_animated.flip_h = false
			$Enemy_animated.play("turn")
			moving_left = true
		moving_right = false  # reset right flag

	# Moving RIGHT
	elif x_speed > 0:
		if not moving_right:
			$Enemy_animated.flip_h = true
			$Enemy_animated.play("turn")
			moving_right = true
		moving_left = false  # reset left flag

	# Stopped moving
	else:
		if moving_left:
			$Enemy_animated.play_backwards("turn")
			moving_left = false
		if moving_right:
			$Enemy_animated.play_backwards("turn")
			moving_right = false

	last_x = global_position.x






func explode():
	# Spawn the explosion
	var explosion = Explosion.instantiate()
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)
	# Remove the enemy itself
	queue_free()
	
	

func shoot() -> void:
	if can_shoot:
		var bullet = BulletScene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		
		
		can_shoot = false
		$ShootTimer.start()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		area.explode()
		if health == 1:
			var explosion = Explosion.instantiate()
			explosion.global_position = global_position
			get_tree().root.add_child(explosion)
			# Remove the enemy itself
			queue_free()
		elif health > 0:
			health -= 1


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
