extends Node2D

onready var stats = get_parent()
var level
var xpToLevelUp = 10
var totalXp
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_up()

func _process(delta):
	level = get_parent().powerLevel
	var string = "PL: "
	string += str(level)
	$Level.text = string
# Called when the node enters the scene tree for the first time.
func _ready():
	print(stats)
	level = stats.powerLevel
	totalXp = 0
	
	var string = "PL: "
	string += str(level)
	$Level.text = string

func getXp():
	pass


func _on_Player_enemyPowerLevel(powerLevel):
	totalXp += powerLevel
	while (totalXp >= xpToLevelUp):
		emit_signal("level_up")
		level = get_parent().powerLevel
		xpToLevelUp = xpToLevelUp * 2
		print("Leveled Up!")
		var string = "PL: "
		string += str(level)
		$Level.text = string
