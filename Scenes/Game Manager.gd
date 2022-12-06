extends Node2D

onready var player = $Player
onready var console = $UI/RichTextLabel
onready var kills = $UI/Kills
var player_position
var killsNum = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	console.add_text("Welcome to Cell island!\nYour goal is to kill as many as possible without dying.\n")
	console.add_text("Controls:\nMove - WASD\nFly - R\nPunch - SPACE or left click\nMeditate - J\n")
	kills.text = "Kills: 0"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_position = player.position
	
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
