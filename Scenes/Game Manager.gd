extends Node2D

onready var player = $Player
onready var console = get_node("Player/UI/Player HUD/HBoxContainer/VBoxContainer2/Panel/MarginContainer/CenterContainer/Console")
#onready var kills = $UI/Kills
var player_position
var killsNum = 0
var enemyNum = 0
var enemyLimitReached = false

# Called when the node enters the scene tree for the first time.
func _ready():
	console.add_text("You've woken up on a strange island! It seems you're surrounded by weird bug men, and they seem to be getting stronger!\n")
	console.add_text("Controls:\nMove - WASD\nPunch - SPACE or left click\nMeditate - J\nRaise Release - C\nCharacter Sheet - I\nRemember to aim your punches with your mouse, and spend your AP by opening the character sheet with I!\n")
	#kills.text = "Kills: 0"
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
	#kills.text = "Kills: "
	var string = str(killsNum)
	#kills.add_text(string)


func _on_Spawner_spawned():
	enemyNum = enemyNum + 1


func _on_Enemies_enemy_died(powerLevel):
	enemyNum = enemyNum - 1
