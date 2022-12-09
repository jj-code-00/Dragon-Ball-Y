extends Node2D

onready var stats = get_parent()
onready var powerLevel = get_parent().powerLevel
var level
var xpToLevelUp
var totalXp
var remaining_xp
onready var levelDisplay = get_parent().get_parent().get_node("UI/Player HUD/Player GUI/VBoxContainer/Power Level")
onready var gameManager = get_tree().get_root().get_node("Dev Island")
var kills = 0
var AP
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
	AP = 0
	powerLevel = get_parent().powerLevel
	level = 1
	totalXp = 0
	level_up_formula()
	remaining_xp = xpToLevelUp - totalXp
	update_level_display()

func _on_Player_enemyPowerLevel(powerLevel):
	kills = kills + 1

func level_up_formula():
	# needs work
	xpToLevelUp = pow(level/1, 1.1)
	remaining_xp = xpToLevelUp - totalXp
	
func update_level_display():
	var string = "PL: "
	string += str(round(powerLevel))
	levelDisplay.text = string
	
func gain_xp_on_hit(damage,total_health,power_level):
	var xp_gained = (damage / total_health) * power_level
	totalXp += xp_gained
	while (totalXp >= xpToLevelUp):
		totalXp = totalXp - xpToLevelUp
		AP = AP + 1
		# move away from levels
		level = level + 1
		if(level == 3):
			emit_signal("flight_unlocked")
		elif (level == 5):
			emit_signal("ki_attack_unlocked")
		elif level == 10:
			emit_signal("transform_1_unlocked")
		powerLevel = get_parent().powerLevel
		level_up_formula()
		gameManager.print_to_console("AP gained!")
		update_level_display()
	remaining_xp = xpToLevelUp - totalXp
	
