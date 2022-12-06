extends Node2D

onready var player = $Player
var player_position
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_position = player.position
	
func get_player_position():
	return player_position
func get_player():
	return player
