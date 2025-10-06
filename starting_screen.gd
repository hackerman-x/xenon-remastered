extends Node2D

var Main = preload("res://main.tscn")
var max_y := 1360
var can_move := false
var next := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if can_move:
		$Scroll.position.y -= 75 * delta
	if Input.is_action_pressed("Skip"):
		$Timer2.start()
	if Input.is_action_just_released("Skip"):
		$Timer2.stop()



func _on_button_pressed() -> void:
	$AudioStreamPlayer.playing = false
	can_move = true
	$AudioStreamPlayer2.play()
	$Timer.start()


func _on_timer_timeout() -> void:
	can_move = false
	$Scroll.queue_free()
	$Camera2D.enabled = false
	$STARS.queue_free()
	$Button.visible = false
	var main = Main.instantiate()
	get_node("THE GAME").add_child(main)


func _on_timer_2_timeout() -> void:
	$AudioStreamPlayer2.seek(32)
	$Timer.wait_time = 0.1
