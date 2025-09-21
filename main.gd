extends Node2D

var EnemyScene = preload("res://Enemy.tscn")
var not_dead := true
var enemies := []
var zenon : Node2D
var can_shoot := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zenon = $Zenon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not is_instance_valid(zenon):
		return
	for enemy in enemies:
		if is_instance_valid(enemy):
			var x_dist = abs(enemy.global_position.x - zenon.global_position.x)
			var y_dist = enemy.global_position.y - zenon.global_position.y
			if is_instance_valid(enemy):
				if y_dist <= -10 and y_dist >= -300 and x_dist <= 25:
					enemy.shoot()
	if zenon.visible == false:
		$DeathCamera.enabled = true
		print("GONE")




func _on_enemy_wait_timer_timeout() -> void:
	for i in range(5): # make 5 enemies
		var enemy = EnemyScene.instantiate()
		enemy.global_position = Vector2(randf() * 600, randf() * 400) # random spot
		var enemy_position = get_tree().root.get_node("Main/Enemy")
		enemy_position.add_child(enemy)
		enemies.append(enemy)
		


func _on_warning_timeout() -> void:
	var enemy = EnemyScene.instantiate()
	enemy.global_position = Vector2(randf() * 600, randf() * 400) # random spot
	var enemy_position = get_tree().root.get_node("Main/Enemy")
	enemy_position.add_child(enemy)
	enemies.append(enemy)

	

#func _on_enemy_child_order_changed() -> void:
	#for enemy in enemies:
		#if abs(enemy.global_position.x - player.global_position.x) <= 50:
			#print("Enemy is lined up with Zenon (within 50 pixels on X)")
			
