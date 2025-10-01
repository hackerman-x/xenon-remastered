extends Node2D

var Main = preload("res://main.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$AudioStreamPlayer.playing = false
	var main = Main.instantiate()
	get_node("THE GAME").add_child(main)
	$Camera2D.enabled = false
	$Button.visible = false
