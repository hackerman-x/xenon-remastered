extends Node2D

var Main = preload("res://main.tscn")
var Explosion = preload("res://Explosions/intro_explosion.tscn")
var StarScene = preload("res://starsformain.tscn")
var StarScene2 = preload("res://starsformain2.tscn")
var StarScene3 = preload("res://starsformain3.tscn")
var no_of_stars = 200
var max_y := 1360
var can_move := false
var next := false
var Go := false
var introstart:= false
var Star: Node2D
var stars := []
var hold_time := 0.0 
var max_hold := 5.0  
var radius := 40.0
var line_width := 8.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.starting = self
	$AudioStreamPlayer.play()
	$TextureProgressBar.min_value = 0
	$TextureProgressBar.max_value = max_hold
	$TextureProgressBar.value = 0

func _process(delta: float) -> void:
	if introstart:
		$Label.visible = true
		$TextureProgressBar.visible = true
		if Input.is_action_pressed("Skip"):  # ESC key
			hold_time += delta
			$TextureProgressBar.value = hold_time
			if hold_time >= 5.0:
				$AudioStreamPlayer3.stop()
				$AudioStreamPlayer2.play(1)
				$Timer.wait_time = 0.01
				$Intro.visible = false
				$Timer.start()
				$TextureProgressBar.value = 0
				hold_time = 0.0  # reset so it doesn't keep triggering
				introstart = false
		else:
			hold_time = 0.0  # reset if released
			$TextureProgressBar.value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Go and not is_instance_valid(Global.zenon_ref):
		$AudioStreamPlayer2.stop()
		$Death/Death.visible = true
		$Death/Button.visible = true
	if introstart:
		$Intro/Text.global_position.y -= 1.7
		

func _on_button_pressed() -> void:
	$Button.disabled = true
	$Button.visible = false
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer3.play()
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
	$AnimatedSprite2D.visible = false
	$STARS.queue_free()
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
	
func spawn_star() -> void:
	for star in no_of_stars:
		Star = StarScene.instantiate()
		get_node("STAR").add_child(Star)
		stars.append(Star)
	for star in no_of_stars:
		Star = StarScene2.instantiate()
		get_node("STAR").add_child(Star)
		stars.append(Star)
	for star in no_of_stars:
		Star = StarScene3.instantiate()
		get_node("STAR").add_child(Star)
		stars.append(Star)

func _on_timer_timeout() -> void:
	$TextureProgressBar.queue_free()
	$Label.visible = false
	$Intro.visible = false
	$ColorRect.visible = true
	spawn_star()
	var explode = Explosion.instantiate()
	explode.position = Vector2(0, 495)
	add_child(explode)
	$AnimationPlayer.play("Intro")
	await get_tree().create_timer(3.2).timeout
	$AnimationPlayer.play("RESET")
	$Camera2D.enabled = false
	var main = Main.instantiate()
	get_node("THE GAME").add_child(main)
	$AudioStreamPlayer2.volume_db = -1
	if is_instance_valid(Global.zenon_ref):
		Go = true


func _on_button_pressed2() -> void:
	$AnimationPlayer.play("Intro")
	$AudioStreamPlayer2.play(1)
	await get_tree().create_timer(3.2).timeout
	$AnimationPlayer.play("RESET")
	$"THE GAME"/Main.zenon_spawn()
	$Death/Death.visible = false
	$Death/Button.visible = false
	$Death/Button.disabled = true


func _on_audio_stream_player_2_finished() -> void:
	$AudioStreamPlayer2.play(1)
