extends Node2D

@export var no_of_stars := 100

var StarScene = preload("res://starsformain.tscn")
var StarScene2 = preload("res://starsformain2.tscn")
var StarScene3 =preload("res://starsformain3.tscn")
var Earth = preload("res://Earth.tscn")
var Zenon = preload("res://Zenon.tscn")
var PowerUp = preload("res://health_powerup.tscn")
var EnemyScene = preload("res://Enemies/Enemy.tscn")
var EnemyScene2 = preload("res://Enemies/Enemy2.tscn")
var EnemyScene3 = preload("res://Enemies/Enemy3.tscn")
var EnemyScene4 = preload("res://Enemies/Enemy4.tscn")
var EnemyScene5 = preload("res://Enemies/Enemy5.tscn")
var EnemyScene6 = preload("res://Enemies/Enemy6.tscn")
var current_no_of_enemies := 1.0
var Star :Node2D
var enemy_difficulty := 0
var not_dead := true
var spawn_pos = Vector2.ZERO
var x_min := -910
var x_max := 910
var y_min := -480
var y_max := 480
var enemies := []
var stars := []
var enemyiesize : int
var zenon : Node2D
var can_shoot := false
var score := 0
var score_str :String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Health.color = Color.RED
	$HealthBarBorder.color = Color.DARK_RED
	zenon = $Zenon
	spawn_star()

func _process(_delta: float) -> void:
	if not is_instance_valid(zenon):
		var new_zenon = get_tree().get_root().find_child("Zenon", true, false)
		if new_zenon:
			zenon = new_zenon
		else:
			return  # player still missing
	if not is_instance_valid(zenon):
		set_physics_process(false)
	if is_instance_valid(zenon):
		set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy) and is_instance_valid(zenon):
			var x_dist = abs(enemy.global_position.x - zenon.global_position.x)
			var y_dist = enemy.global_position.y - zenon.global_position.y
			if is_instance_valid(enemy):
				if y_dist <= -30 and y_dist >= -300 and x_dist <= 25:
					enemy.shoot()
	if enemies.size() > 0 and not is_instance_valid(zenon):
		for enemy in enemies:
			enemy.queue_free()
	

func spawn_star() -> void:
	for star in no_of_stars:
		Star = StarScene.instantiate()
		get_node("Background/Stars").add_child(Star)
		stars.append(Star)
	for star in no_of_stars:
		Star = StarScene2.instantiate()
		get_node("Background/Stars").add_child(Star)
		stars.append(Star)
	for star in no_of_stars:
		Star = StarScene3.instantiate()
		get_node("Background/Stars").add_child(Star)
		stars.append(Star)
	#var earth = Earth.instantiate()
	#get_node("Background/Earth").add_child(earth)
	
	
func zenon_spawn() -> void:
	var zenon1 = Zenon.instantiate()
	add_child(zenon1)  # add it to Main
	$Zenon.respawn()
	zenon1.position = Vector2(200, 100)  # set its position in the scene
	move_child(zenon1, 5)
	

func spawn():
	var viewport_rect = get_viewport().get_visible_rect()
	var margin = 100  # how far outside to spawn

	var side = randi_range(0, 3)  # 0=top, 1=bottom, 2=left, 3=right

	match side:
		0: # Top
			spawn_pos.x = randf_range(viewport_rect.position.x, viewport_rect.position.x + viewport_rect.size.x)
			spawn_pos.y = viewport_rect.position.y - margin

		1: # Bottom
			spawn_pos.x = randf_range(viewport_rect.position.x, viewport_rect.position.x + viewport_rect.size.x)
			spawn_pos.y = viewport_rect.position.y + viewport_rect.size.y + margin

		2: # Left
			spawn_pos.x = viewport_rect.position.x - margin
			spawn_pos.y = randf_range(viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)

		3: # Right
			spawn_pos.x = viewport_rect.position.x + viewport_rect.size.x + margin
			spawn_pos.y = randf_range(viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)
			
	return spawn_pos

func enemy1() -> void:
	spawn()
	var enemy = EnemyScene.instantiate()
	var enemy_position_intree = get_tree().root.get_node("Starting Screen/THE GAME/Main/Enemy")
	enemy_position_intree.add_child(enemy)
	enemy.global_position = spawn_pos
	enemies.append(enemy)
	enemyiesize = enemies.size()
	
	enemy.tree_exited.connect(func ():
		if enemies.has(enemy):
			enemies.erase(enemy)
			score += 5
			score_str = str(score)
			$Score.text = score_str
	)
	
func enemy2() -> void:
	spawn()
	var enemy = EnemyScene2.instantiate()
	var enemy_position_intree = get_tree().root.get_node("Starting Screen/THE GAME/Main/Enemy")
	enemy_position_intree.add_child(enemy)
	enemy.global_position = spawn_pos
	enemies.append(enemy)
	enemyiesize = enemies.size()
	
	enemy.tree_exited.connect(func ():
		if enemies.has(enemy):
			enemies.erase(enemy)
			score += 10
			score_str = str(score)
			$Score.text = score_str
	)

func enemy3() -> void:
	spawn()
	var enemy = EnemyScene3.instantiate()
	var enemy_position_intree = get_tree().root.get_node("Starting Screen/THE GAME/Main/Enemy")
	enemy_position_intree.add_child(enemy)
	enemy.global_position = spawn_pos
	enemies.append(enemy)
	enemyiesize = enemies.size()
	
	enemy.tree_exited.connect(func ():
		if enemies.has(enemy):
			enemies.erase(enemy)
			score += 10
			score_str = str(score)
			$Score.text = score_str
	)

func enemy4() -> void:
	spawn()
	var enemy = EnemyScene4.instantiate()
	var enemy_position_intree = get_tree().root.get_node("Starting Screen/THE GAME/Main/Enemy")
	enemy_position_intree.add_child(enemy)
	enemy.global_position = spawn_pos
	enemies.append(enemy)
	enemyiesize = enemies.size()
	
	enemy.tree_exited.connect(func ():
		if enemies.has(enemy):
			enemies.erase(enemy)
			score += 5
			score_str = str(score)
			$Score.text = score_str
	)

func enemy5() -> void:
	spawn()
	var enemy = EnemyScene5.instantiate()
	var enemy_position_intree = get_tree().root.get_node("Starting Screen/THE GAME/Main/Enemy")
	enemy_position_intree.add_child(enemy)
	enemy.global_position = spawn_pos
	enemies.append(enemy)
	enemyiesize = enemies.size()
	
	enemy.tree_exited.connect(func ():
		if enemies.has(enemy):
			enemies.erase(enemy)
			score += 20
			score_str = str(score)
			$Score.text = score_str
	)

func enemy6() -> void:
	spawn()
	var enemy = EnemyScene6.instantiate()
	var enemy_position_intree = get_tree().root.get_node("Starting Screen/THE GAME/Main/Enemy")
	enemy_position_intree.add_child(enemy)
	enemy.global_position = spawn_pos
	enemies.append(enemy)
	enemyiesize = enemies.size()
	
	enemy.tree_exited.connect(func ():
		if enemies.has(enemy):
			enemies.erase(enemy)
			score += 20
			score_str = str(score)
			$Score.text = score_str
	)

func random() -> void:
	var num = randi_range(1, 6)
	if num == 1:
		enemy1()
	if num == 2:
		enemy2()
	if num == 3:
		enemy3()
	if num == 4:
		enemy4()
	if num == 5:
		enemy5()
	if num == 6:
		enemy6()

func _on_warning_timeout() -> void:
	random()
	print("spawning")


func _on_enemy_wait_timer_timeout() -> void:
	if is_instance_valid(zenon):
		print("spawning")
		$EnemyWaitTimer.wait_time = 5
		if enemies.size() == 0:
			$EnemyWaitTimer.wait_time = 5
		elif enemies.size() > 0:
			$EnemyWaitTimer.wait_time += 3
		$EnemyWaitTimer.start()
		for i in range(current_no_of_enemies):
			random()
	else:
		while is_instance_valid(zenon):
			$EnemyWaitTimer.wait_time += 1


func _on_difficulty_timeout() -> void:
	current_no_of_enemies += 1
	$Difficulty.start()
