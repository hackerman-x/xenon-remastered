extends Node2D

var Main = preload("res://main.tscn")

func _ready() -> void:
	$Camera2D.enabled = true

func _on_button_pressed() -> void:
	var main = Main.instantiate()

	if Global.starting and Global.starting.has_node("THE GAME"):
		var place = Global.starting.get_node("THE GAME")
		place.add_child(main)
	else:
		push_error("Global.starting or 'THE GAME' not found!")
