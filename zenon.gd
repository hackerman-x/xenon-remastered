extends CharacterBody2D


var newLaser = preload("res://Laser.tscn")
var Explosion = preload("res://Explosions/player_explosion.tscn")
var Laser = preload("res://LaserPower.tscn")


@export var health := 9
@export var UP_SPEED = 250.0
@export var ACCELERATION = 700   # how fast we reach top speed
@export var FRICTION = 900      # how fast we slow down
@export var MAX_SPEED = 300      # top speed
@export var Energy = 200
var camera:Camera2D
var can_shoot := true
var Hitscreen :Sprite2D
var Regenscreen :Sprite2D
var PowerUp :Sprite2D
var rect :ColorRect
var rectborder:ColorRect
var energy :ColorRect
var energyborder:ColorRect
var faster := false
var fastest := false
var right := false
var left := false
var slow := false
var idle := true
var Hittime := 1
var dead := false
var PowerdUp := false
var going_right = false
var going_left = false
var energydown = 0


func _process(_delta: float) -> void:
	if Energy <= 200 and not Input.is_action_pressed("Boost"):
		energydown += 0.8
		Energy += 0.8
		if energy.size.x < 200:
			energy.size.x += 0.8

func start_process_later():
	if not is_processing():
		await get_tree().create_timer(3.0).timeout  # wait 2 seconds
		set_process(true)  # starts _process()
	if is_processing():
		await get_tree().create_timer(3.0).timeout  # wait 2 seconds
		set_process(true)  # starts _process()
		

func _physics_process(delta: float) -> void:
	if Energy == 0:
		$Thrusters/BoostDown.emitting = true
	if Energy <= 200 and not Input.is_action_pressed("Boost"):
		start_process_later()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("Up", "Down")
	if direction_y:
		idle = false
		velocity.y = move_toward(velocity.y, direction_y * UP_SPEED, ACCELERATION * delta)
		if Input.is_action_pressed("Up"):
			$Thrusters/Exhaust.emitting = false
			slow = false
			faster = true
			if Input.is_action_pressed("Boost"):
				if health > 2 and Energy > 0:
					set_process(false)
					energydown += 0.8
					Energy -= 0.8
					energy.size.x -= 0.8
					$Thrusters/Exhaust.emitting = true
					fastest = true
					UP_SPEED = 450
					FRICTION = 600
					$Thrusters/Left.play("boost")
					$Thrusters/Right.play("boost")
				elif health <= 2:
					$Thrusters/BoostDown.emitting = true
			elif Input.is_action_just_released("Boost"):
				$Thrusters/BoostDown.emitting = false
				$Thrusters/Exhaust.emitting = false
				fastest = false
				UP_SPEED = 250.0
				FRICTION = 900
				$Thrusters/Left.play("forward")
				$Thrusters/Right.play("forward")
		if Input.is_action_pressed("Down"):
			$Thrusters/Exhaust.emitting = false
			slow = true
			UP_SPEED = 250.0
			FRICTION = 900
	else:
		idle = true
		slow = false
		faster = false
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
		$Thrusters/Left.play("idle")
		$Thrusters/Exhaust.emitting = false
		$Thrusters/Right.play("idle")
	if Input.is_action_just_pressed("Up"):
		camera.move_up()
		$Thrusters/Left.play("forward")
		$Thrusters/Right.play("forward")
	if Input.is_action_just_released("Up"):
		camera.move_back()
	elif Input.is_action_just_pressed("Down"):
		camera.move_down()
		$Thrusters/Left.play("back")
		$Thrusters/Right.play("back")
	if Input.is_action_just_released("Down"):
		camera.move_back()
#
#
	var direction_x := Input.get_axis("Left", "Right")
	if direction_x < 0: # Moving left now. 
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	elif direction_x == 0: 
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if Input.is_action_just_pressed("Left"):
		going_left = true
		left = true
		camera.move_left()
		$Zenon_animated.flip_h = false
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Left"):
		going_left = false
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
		going_right = true
		right = true
		camera.move_right()
		$Zenon_animated.flip_h = true
		$Zenon_animated.play("turn")
	if Input.is_action_just_released("Right"):
		going_right = false
		right = false
		camera.move_back()
		$Zenon_animated.play_backwards("turn")
	if Input.is_action_just_pressed("Right") and Input.is_action_just_pressed("Left"):
		if going_right:
			$Zenon_animated.play("turn")
		if going_left:
			$Zenon_animated.play_backwards("turn")


	if Input.is_action_pressed("Shoot") and can_shoot:
		if PowerdUp:
			var laser2 = Laser.instantiate()
			laser2.position = position
			var parent_node2 = get_tree().root.get_node("Starting Screen/THE GAME/Main/Laser")
			parent_node2.add_child(laser2)
		else:
			var laser = newLaser.instantiate()
			laser.position = position
			var parent_node = get_tree().root.get_node("Starting Screen/THE GAME/Main/Laser")
			parent_node.add_child(laser)
#
		can_shoot = false
		$ShootTimer.start()
		
	move_and_slide()
	
	
func respawn() -> void:
	set_process(false)  # make sure it starts off
	Hitscreen.visible = false
	dead = false
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
	var score = get_parent().get_node("Score")
	score.text = "0"

func _ready() -> void:
	dead = false
	Global.zenon_ref = self
	rect = get_parent().get_node("Health")
	rectborder = get_parent().get_node("HealthBarBorder")
	energy = get_parent().get_node("Energy")
	energyborder = get_parent().get_node("EnergyBarBorder")
	Hitscreen = get_parent().get_node("Hit")
	Regenscreen =  get_parent().get_node("Regen")
	PowerUp = get_parent().get_node("PowerUp")
	camera = get_parent().get_node("Camera")
	


func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func powerUp() -> void:
	PowerdUp = true
	$PowerUp3.play()
	$LaserPower.emitting = true
	PowerUp.visible = true
	$PowerUp2.start()
	var tween = create_tween()
	tween.tween_property(rect, "color", Color.YELLOW, 0.5) # change to red in 1 second
	tween.tween_property(rect, "color", Color.RED, 0.5) # then back to white in 1 second
	tween.tween_property(rectborder, "color", Color.YELLOW, 0.5) # change to red in 1 second
	tween.tween_property(rectborder, "color", Color.DARK_RED, 0.5) # then back to white in 1 second
	

func regen() -> void:
	$Regen.emitting = true
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
	$Regen.emitting = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		rect.size.x -= 20
		$Hit.emitting = true
		$Zenon_animated.modulate = Color("#ff7c6b")
		$HitTimer.start()
		health -= 1
		Hitscreen.visible = true
		Hittime += 1
		area.get_parent().explode()
		$Timer.start()
		camera.start_shake(5)
	if area.is_in_group("PowerUpHealth"):
		area.pickup()
	if area.is_in_group("PowerUpLaser"):
		area.pickup()
	if area.is_in_group("EnemyBullet"):
		rect.size.x -= 20
		area.explode()
		if health > 0:
			$Hit.emitting = true
			$Zenon_animated.modulate = Color("#ff7c6b")
			$HitTimer.start()
			health -= 1
			Hitscreen.visible = true
			Hittime += 1
			$Timer.start()
			camera.start_shake(5)
		elif health == 0:
			var explosion = Explosion.instantiate()
			camera.start_shake(1)
			explosion.global_position = global_position
			get_tree().root.add_child(explosion)
			
			visible = false
			dead = true
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
	$Hit.emitting = false


func _on_timer_2_timeout() -> void:
	Regenscreen.visible = false



func _on_power_up_2_timeout() -> void:
	PowerUp.visible = false
	$LaserPower.emitting = false
	


func _on_power_up_3_finished() -> void:
	PowerdUp = false


		
