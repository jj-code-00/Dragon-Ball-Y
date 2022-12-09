extends Node2D

onready var stats = get_parent()
onready var powerLevel = get_parent().powerLevel
var level
var xpToLevelUp
var totalXp
onready var levelDisplay = get_parent().get_parent().get_node("UI/Player HUD/Player GUI/VBoxContainer/Power Level")
onready var gameManager = get_tree().get_root().get_node("Dev Island")
var kills = 0
signal ki_attack_unlocked
signal flight_unlocked
signal transform_1_unlocked
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_up()

func _process(delta):
	powerLevel = get_parent().powerLevel
	update_level_display()
# Called when the node enters the scene tree for the first time.
func _ready():
	powerLevel = get_parent().powerLevel
	level = 1
	totalXp = 0
	level_up_formula()
	update_level_display()

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
		elif level == 4:
			emit_signal("transform_1_unlocked")
		powerLevel = get_parent().powerLevel
		level_up_formula()
		gameManager.print_to_console("Level Up!")
		update_level_display()

func level_up_formula():
	xpToLevelUp = pow(level/.25, 2)
	
func update_level_display():
	var string = "PL: "
	string += str(round(powerLevel))
	levelDisplay.text = string
