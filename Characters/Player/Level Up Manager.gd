extends Node2D

onready var player_stats = get_parent().get_parent().stats
var xpToLevelUp
var totalXp
onready var levelDisplay = get_parent().get_parent().get_node("UI/Player HUD/Player GUI/VBoxContainer/Power Level")
onready var gameManager = get_tree().get_root().get_node("Dev Island")
var kills = 0
signal ki_attack_unlocked
signal flight_unlocked
signal transform_1_unlocked

signal level_up()

func _process(delta):
	update_level_display()
# Called when the node enters the scene tree for the first time.
func _ready():
	totalXp = 0
	level_up_formula()

func _on_Player_enemyPowerLevel(powerLevel):
	kills = kills + 1

func level_up_formula():
	# needs work
	player_stats.ap_required = pow(player_stats.level/1, 1.1)
	
func update_level_display():
	var string = "PL: "
	string += str(round(player_stats.powerLevel))
	levelDisplay.text = string
	
func gain_xp_on_hit(damage,total_health,power_level):
	player_stats.AP += (damage / total_health) * power_level
