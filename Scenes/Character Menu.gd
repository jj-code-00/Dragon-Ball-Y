extends MarginContainer

onready var stats = get_parent().get_parent().get_node("Stats")
onready var vitality_display = $CenterContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/vitality_button
onready var strength_display = $CenterContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/strength_button
onready var agility_display = $CenterContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/agility_button
onready var durability_display = $CenterContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/durability_button
onready var force_display = $CenterContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/force_button
onready var spirit_display = $CenterContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/spirit_button
onready var power_level_display = $"CenterContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/CenterContainer/Power Level"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_stats_display()
	
func _process(delta):
	refresh_stats_display()

func refresh_stats_display():
	vitality_display.text = str(stats.vitality)
	strength_display.text = str(stats.strength)
	agility_display.text = str(stats.agility)
	durability_display.text = str(stats.defense)
	force_display.text = str(stats.force)
	spirit_display.text = str(stats.spirit)
	power_level_display.text = str(round(stats.powerLevel))
