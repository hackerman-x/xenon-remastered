extends Node2D

var EnemyScene = preload("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_wait_timer_timeout() -> void:
	var enemy = EnemyScene.instantiate()
	add_child(enemy)
