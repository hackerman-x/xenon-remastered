extends Node2D

var number_of_enemies := 8
var current_no_of_enemies := 0
var EnemyScene = preload("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_enemy_wait_timer_timeout() -> void:
	for i in range(5): # make 5 enemies
		var enemy = EnemyScene.instantiate()
		enemy.global_position = Vector2(randf() * 600, randf() * 400) # random spot
		get_parent().add_child(enemy)


func _on_warning_timeout() -> void:
	var enemy = EnemyScene.instantiate()
	enemy.global_position = Vector2(randf() * 600, randf() * 400) # random spot
	get_parent().add_child(enemy)
