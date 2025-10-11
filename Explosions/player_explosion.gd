extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.play()
	$explosion.emitting = true

func _on_player_blowup_animation_finished() -> void:
	$explosion.emitting = false
	queue_free()
