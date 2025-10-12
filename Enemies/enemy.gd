extends RigidBody2D




# VARIABELLLLLS
var Explosion = preload("res://Explosions/enemy_explosion.tscn")
var BulletScene = preload("res://EnemyLaser.tscn")
var PowerUp = preload("res://health_powerup.tscn")
var PowerUp2 = preload("res://laser_powerup.tscn")

@export var health := 4
@export var chase_distance: float = 1000.0  # how close player must be
@export var speed: float = 100.0           # enemy movement speed
@export var y_stop_range: float = 90.0


var num = randi_range(0, 3)
var aggro: bool = false
var can_shoot := true
var last_x: float = 0.0
var moving_left: bool = false
var moving_right: bool = false
var min_distance := 50
var powerup_enable = false
var orbit_speed := 1.5
var old_health: int = 5
var orbit_radius := 120.0
var player: Node2D
var angle := 0.0
var approach_speed: float = 0.8   # how fast it moves toward Zenon's Y\
var in_orbit := false
var base_position: Vector2
var previous_y = 0
var moving_up = false
var moving_down = false
var zenon:CharacterBody2D
# VARIABELLLLLS



func _ready() -> void:
	zenon = get_tree().root.get_node_or_null("Starting Screen/THE GAME/Main/Zenon")
	base_position = Vector2(0, -500)
	last_x = global_position.x
	previous_y = position.y  # store initial y
	if is_instance_valid(Global.zenon_ref):
		player = Global.zenon_ref
	else:
		player = null  # or handle player missing

func _process(_delta: float) -> void:
	if not is_instance_valid(zenon):
		var new_zenon = get_tree().get_root().find_child("Zenon", true, false)
		if new_zenon:
			zenon = new_zenon
		else:
			return  # player still missing
	if is_instance_valid(Global.zenon_ref):
		player = Global.zenon_ref
	else:
		player = null  # or handle player missing
	if not is_instance_valid(player) or player == null:
		set_physics_process(false)
	if is_instance_valid(player) or not player == null:
		set_physics_process(true)


func circling(delta) -> void:
	# How close in X before enemy stops circling
	if is_instance_valid(zenon):
		var x_dist = abs(global_position.x - zenon.global_position.x)
		var y_dist = global_position.y - zenon.global_position.y

		# ✅ Only move vertically if aligned in X AND enemy is ABOVE Zenon
		if x_dist <= 20 and global_position.y <= zenon.global_position.y:
			# Move DOWN toward Zenon until within y_stop_range
			if y_dist < -y_stop_range:  # enemy is more than 20 px above
				global_position.y += min(speed * delta, -y_dist - y_stop_range)
		else:
			# ✅ Go back to circling
			var direction = zenon.global_position - global_position
			var distance = global_position.distance_to(player.global_position)
			if not in_orbit or aggro:
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

func _physics_process(delta: float):
	
	circling(delta)
	
	var x_speed = global_position.x - last_x
	
	if position.y < previous_y:
		moving_up = true
		$Left.play("forward")
		$Right.play("forward")
		moving_down = false
	elif position.y > previous_y:
		moving_up = false
		$Left.play("back")
		$Right.play("back")
		moving_down = true
	else:
		moving_up = false
		$Left.play("idle")
		$Right.play("idle")
		moving_down = false

	previous_y = position.y  # update for next frame
	
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


	
	

func shoot() -> void:
	if can_shoot:
		var bullet = BulletScene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		
		
		can_shoot = false
		$ShootTimer.start()
	

func explode() -> void:
	var explosion = Explosion.instantiate()
	var camera = get_tree().root.get_node("Starting Screen/THE GAME/Main/Camera")
	camera.start_shake(8)
	explosion.global_position = global_position
	get_tree().root.call_deferred("add_child", explosion)
	call_deferred("queue_free")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		# Explode the bullet safely
		area.call_deferred("explode")

		if health <= 0 or area.is_in_group("Player"):
			if num == 1:
				var HEALTH = PowerUp.instantiate()
				HEALTH.global_position = position
				var place = get_tree().root.get_node("Starting Screen/THE GAME/Main/PowerUps")
				place.call_deferred("add_child", HEALTH)
			if num == 2:
				var Damage = PowerUp2.instantiate()
				Damage.global_position = position
				var place = get_tree().root.get_node("Starting Screen/THE GAME/Main/PowerUps")
				place.call_deferred("add_child", Damage)

			explode()

		elif health > 0:
			if Global.zenon_ref.PowerdUp:
				health -= 5
				$Enemy_animated.modulate = Color("#ff7c6b")
				$EnemyHitTimer.start()
			else:
				health -= 1
				$Enemy_animated.modulate = Color("#ff7c6b")
				$EnemyHitTimer.start()


func _on_shoot_timer_timeout() -> void:
	can_shoot = true


func _on_enemy_hit_timer_timeout() -> void:
	$Enemy_animated.modulate = Color.WHITE
