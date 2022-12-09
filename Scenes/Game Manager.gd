extends Node2D

onready var player = $Player
onready var console = $"UI/On Screen UI/HBoxContainer/VBoxContainer/Panel/MarginContainer/CenterContainer/Console"
onready var kills = $UI/Kills
var player_position
var killsNum = 0
var enemyNum = 0
var enemyLimitReached = false

# Called when the node enters the scene tree for the first time.
func _ready():
	console.add_text("Welcome to Cell island!\nThere are Cells for you to kill to the left.\n")
	console.add_text("Controls:\nMove - WASD\nPunch - SPACE or left click\nMeditate - J\nRemember to aim your punches with your mouse!\n")
	kills.text = "Kills: 0"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_position = player.position
	
	if(enemyNum >= 50):
		enemyLimitReached = true
	else:
		enemyLimitReached = false
func get_player_position():
	return player_position
func get_player():
	return player
	
func print_to_console(text):
	var string = str(text)
	console.add_text(string)
	console.add_text("\n")

func _on_Player_enemyPowerLevel(powerLevel):
	killsNum = killsNum + 1
	kills.text = "Kills: "
	var string = str(killsNum)
	kills.add_text(string)


func _on_Spawner_spawned():
	enemyNum = enemyNum + 1


func _on_Enemies_enemy_died(powerLevel):
	enemyNum = enemyNum - 1
