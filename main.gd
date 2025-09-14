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
	while current_no_of_enemies <= number_of_enemies:
		var enemy = EnemyScene.instantiate()
		add_child(enemy)
		enemy.position = Vector2(0, -500)  # X=400, Y=200
		current_no_of_enemies += 1
