extends Node2D


func _on_player_blowup_animation_finished() -> void:
	queue_free()
