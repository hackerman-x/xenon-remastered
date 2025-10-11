extends Node2D

var Main = preload("res://main.tscn")
var Explosion = preload("res://Explosions/intro_explosion.tscn")
var max_y := 1360
var can_move := false
var next := false
var Go := false
var introstart:= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.starting = self
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("Skip"):
		$Timer2.start()
	if Input.is_action_just_released("Skip"):
		$Timer2.stop()
	if Go and not is_instance_valid(Global.zenon_ref):
		$AudioStreamPlayer2.stop()
		$Death/Death.visible = true
		$Death/Button.visible = true
	if introstart:
		$Intro/Text.global_position.y -= 1.7
		

func _on_button_pressed() -> void:
	$Button.disabled = true
	$Button.visible = false
	$AudioStreamPlayer.playing = false
	$AudioStreamPlayer2.play()
	$Timer.start()
	intro()

func fade_in(thing):
	var time = 1.0  # seconds for fade
	var steps = 30  # how smooth it looks

	for i in range(steps + 1):
		thing.modulate.a = i / float(steps)
		await get_tree().create_timer(time / steps).timeout
		

func fade_out(thing):
	var time = 1.0  # seconds for fade
	var steps = 30  # how smooth it looks

	for i in range(steps + 1):
		thing.modulate.a = 1.0 - i / float(steps)
		await get_tree().create_timer(time / steps).timeout

func intro() -> void:
	introstart = true
	fade_in($Intro/BG)
	await get_tree().create_timer(2.0).timeout
	fade_in($"Intro/1")
	await get_tree().create_timer(6.0).timeout
	fade_out($"Intro/1")
	await get_tree().create_timer(1.0).timeout
	fade_in($"Intro/2")
	await get_tree().create_timer(6.0).timeout
	fade_out($"Intro/2")
	await get_tree().create_timer(1.0).timeout
	fade_in($"Intro/3")
	await get_tree().create_timer(3.5).timeout
	fade_out($"Intro/3")
	await get_tree().create_timer(1.0).timeout
	fade_in($"Intro/31")
	await get_tree().create_timer(3.5).timeout
	fade_out($"Intro/31")
	await get_tree().create_timer(1.0).timeout
	fade_in($"Intro/4")
	await get_tree().create_timer(4.5).timeout
	introstart = false
	
	

func _on_timer_timeout() -> void:
	$ColorRect.visible = true
	$Intro.visible = false
	$AnimatedSprite2D.visible = false
	can_move = false
	$STARS.queue_free()
	var explode = Explosion.instantiate()
	explode.position = Vector2(0, 495)
	add_child(explode)
	$AnimationPlayer.play("Intro")
	await get_tree().create_timer(3.0).timeout
	$AnimationPlayer.play("RESET")
	$Camera2D.enabled = false
	$ColorRect.visible = false
	var main = Main.instantiate()
	get_node("THE GAME").add_child(main)
	if is_instance_valid(Global.zenon_ref):
		Go = true


func _on_timer_2_timeout() -> void:
	$AudioStreamPlayer2.seek(32)
	$Timer.wait_time = 0.1


func _on_button_pressed2() -> void:
	$"THE GAME"/Main.zenon_spawn()
	$AudioStreamPlayer2.play()
	$Death/Death.visible = false
	$Death/Button.visible = false
