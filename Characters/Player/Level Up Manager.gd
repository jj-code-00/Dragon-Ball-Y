extends Node2D

onready var stats = get_parent()
var powerLevel
var level
var xpToLevelUp = 10
var totalXp
onready var levelDisplay = get_parent().get_parent().get_node("UI/Level")
onready var gameManager = get_tree().get_root().get_node("Dev Island")
var kills = 0
signal ki_attack_unlocked
signal flight_unlocked
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_up()

func _process(delta):
	powerLevel = get_parent().powerLevel
	var string = "PL: "
	string += str(powerLevel)
	levelDisplay.text = string
# Called when the node enters the scene tree for the first time.
func _ready():
	print(stats)
	powerLevel = stats.powerLevel
	level = 1
	totalXp = 0
	
	var string = "PL: "
	string += str(powerLevel)
	levelDisplay.text = string

func _on_Player_enemyPowerLevel(powerLevel):
	kills = kills + 1
	totalXp += powerLevel
	while (totalXp >= xpToLevelUp):
		emit_signal("level_up")
		level = level + 1
		if(level == 2):
			emit_signal("flight_unlocked")
		elif (level == 3):
			emit_signal("ki_attack_unlocked")
		powerLevel = get_parent().powerLevel
		xpToLevelUp = xpToLevelUp * 2
		gameManager.print_to_console("Level Up!")
		var string = "PL: "
		string += str(powerLevel)
		levelDisplay.text = string
