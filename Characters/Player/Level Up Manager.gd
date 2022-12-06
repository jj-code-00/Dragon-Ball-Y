extends Node2D

var level
var xpToLevelUp = 10
var totalXp
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_up()


# Called when the node enters the scene tree for the first time.
func _ready():
	level = 1
	totalXp = 0
	
	var string = "Level: "
	string += str(level)
	get_node("Level").display_text(string)

func getXp():
	pass


func _on_Player_enemyPowerLevel(powerLevel):
	totalXp += powerLevel
	while (totalXp >= xpToLevelUp):
		level = level + 1
		emit_signal("level_up")
		xpToLevelUp = xpToLevelUp * 2
		print("Leveled Up!")
		var string = "Level: "
		string += str(level)
		get_node("Level").display_text(string)
