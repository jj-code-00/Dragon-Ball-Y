extends Node2D

onready var stats = get_parent()
var level
var xpToLevelUp = 10
var totalXp
onready var levelDisplay = get_parent().get_parent().get_node("UI/Level")
onready var gameManager = get_tree().get_root().get_node("Dev Island")
var kills = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_up()

func _process(delta):
	level = get_parent().powerLevel
	var string = "PL: "
	string += str(level)
	levelDisplay.text = string
# Called when the node enters the scene tree for the first time.
func _ready():
	print(stats)
	level = stats.powerLevel
	totalXp = 0
	
	var string = "PL: "
	string += str(level)
	levelDisplay.text = string

func getXp():
	pass


func _on_Player_enemyPowerLevel(powerLevel):
	kills = kills + 1
	totalXp += powerLevel
	while (totalXp >= xpToLevelUp):
		emit_signal("level_up")
		level = get_parent().powerLevel
		xpToLevelUp = xpToLevelUp * 2
		gameManager.print_to_console("Level Up!")
		var string = "PL: "
		string += str(level)
		levelDisplay.text = string
