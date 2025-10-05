extends CharacterBody2D


var newLaser = preload("res://Laser.tscn")
var Explosion = preload("res://Explosions/player_explosion.tscn")


@export var health := 9
@export var UP_SPEED = 250.0
@export var ACCELERATION = 700   # how fast we reach top speed
@export var FRICTION = 900      # how fast we slow down
@export var MAX_SPEED = 300      # top speed
var camera:Camera2D
var can_shoot := true
var Hitscreen :Sprite2D
var Regenscreen :Sprite2D
var rect :ColorRect
var rectborder:ColorRect
var faster := false
var fastest := false
var right := false
var left := false
var slow := false
var idle := true
var Hittime := 1



func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("Up", "Down")
	if direction_y:
		idle = false
		velocity.y = move_toward(velocity.y, direction_y * UP_SPEED, ACCELERATION * delta)
		if Input.is_action_pressed("Up"):
			slow = false
			faster = true
			if Input.is_action_pressed("Boost"):
				fastest = true
				UP_SPEED = 450
				FRICTION = 600
				$Thrusters/Left.play("boost")
				$Thrusters/Right.play("boost")
			elif Input.is_action_just_released("Boost"):
				fastest = false
				UP_SPEED = 250.0
				FRICTION = 900
				$Thrusters/Left.play("forward")
				$Thrusters/Right.play("forward")
		if Input.is_action_pressed("Down"):
			slow = true
			UP_SPEED = 250.0
			FRICTION = 900
	else:
		idle = true
		slow = false
		faster = false
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
		$Thrusters/Left.play("idle")
		$Thrusters/Right.play("idle")
	if Input.is_action_just_pressed("Up"):
		$Thrusters/Left.play("forward")
		$Thrusters/Right.play("forward")
	elif Input.is_action_just_pressed("Down"):
		$Thrusters/Left.play("back")
		$Thrusters/Right.play("back")
#
#
	var direction_x := Input.get_axis("Left", "Right")
	if direction_x < 0: # Moving left now. 
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	elif direction_x == 0: 
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if Input.is_action_just_pressed("Left"):
		left = true
		camera.move_left()
		$Zenon_animated.flip_h = false
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Left"):
		left = false
		camera.move_back()
		$Zenon_animated.play_backwards("turn")
#
#
	if direction_x > 0:
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	elif direction_x == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
#
#
	if Input.is_action_just_pressed("Right"):
		right = true
		camera.move_right()
		$Zenon_animated.flip_h = true
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Right"):
		right = false
		camera.move_back()
		$Zenon_animated.play_backwards("turn")


	if Input.is_action_pressed("Shoot") and can_shoot:
		var laser = newLaser.instantiate()
		laser.position = position
		var parent_node = get_tree().root.get_node("Starting Screen/THE GAME/Main/Laser")
		parent_node.add_child(laser)
#
		can_shoot = false
		$ShootTimer.start()
		
	move_and_slide()
	


func _ready() -> void:
	Global.zenon_ref = self
	rect = get_parent().get_node("Health")
	rectborder = get_parent().get_node("HealthBarBorder")
	Hitscreen = get_parent().get_node("Hit")
	Regenscreen =  get_parent().get_node("Regen")
	camera = get_parent().get_node("Camera")
	


func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func regen() -> void:
	rect.size.x = 200
	Regenscreen.visible = true
	$Timer2.start()
	Hittime = 0
	var tween = create_tween()
	tween.tween_property(rect, "color", Color.DEEP_SKY_BLUE, 0.5) # change to red in 1 second
	tween.tween_property(rect, "color", Color.RED, 0.5) # then back to white in 1 second
	tween.tween_property(rectborder, "color", Color.DEEP_SKY_BLUE, 0.5) # change to red in 1 second
	tween.tween_property(rectborder, "color", Color.DARK_RED, 0.5) # then back to white in 1 second
	health = 9


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBullet"):
		rect.size.x -= 20
		if health > 0:
			$Zenon_animated.modulate = Color("#ff7c6b")
			$HitTimer.start()
			health -= 1
			Hitscreen.visible = true
			Hittime += 1
			$Timer.start()
			var camera = get_tree().root.get_node("Starting Screen/THE GAME/Main/Camera")
			camera.start_shake(5)
		elif health == 0:
			var explosion = Explosion.instantiate()
			var camera = get_tree().root.get_node("Starting Screen/THE GAME/Main/Camera")
			camera.start_shake(50)
			explosion.global_position = global_position
			get_tree().root.add_child(explosion)
			
			visible = false
			queue_free()
			



func _on_hit_timer_timeout() -> void:
	$Zenon_animated.modulate = Color.WHITE


func _on_timer_timeout() -> void:
	if Hittime == 1:
		Hitscreen.modulate = Color("#490000")
	if Hittime == 2:
		Hitscreen.modulate = Color("#720000")
	if Hittime == 3:
		Hitscreen.modulate = Color("#990000")
	if Hittime == 4:
		Hitscreen.modulate = Color("#c70000")
	if Hittime == 5:
		Hitscreen.modulate = Color("#f20000")
	if Hittime == 6:
		Hitscreen.modulate = Color("#ff4d3c")
	if Hittime == 7:
		Hitscreen.modulate = Color("#ff7a68")
	if Hittime == 8:
		Hitscreen.modulate = Color("#ffa99b")
	if Hittime == 9:
		Hitscreen.modulate = Color("#ffffff")
	Hitscreen.visible = false


func _on_timer_2_timeout() -> void:
	Regenscreen.visible = false
