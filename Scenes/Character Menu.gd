extends MarginContainer

onready var player_stats = get_parent().get_parent().stats
onready var stats = get_parent().get_parent().get_node("Stats")
onready var level_manager = get_parent().get_parent().get_node("Stats").get_node("Level Up Manager")
onready var vitality_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/vitality_button
onready var strength_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/strength_button
onready var agility_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/agility_button
onready var durability_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/durability_button
onready var force_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/force_button
onready var spirit_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/spirit_button
onready var power_level_display = $"CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/CenterContainer/Power Level"
onready var ap_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/CenterContainer2/AP
onready var xp_remaining_display = $"CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer2/CenterContainer4/Remaining XP"
onready var calc_strength_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer3/CenterContainer/calc_strength
onready var calc_agility_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer3/CenterContainer2/calc_agility
onready var calc_durability_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer3/CenterContainer3/calc_durability
onready var calc_force_display = $CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/VBoxContainer3/CenterContainer4/calc_force
# Called when the node enters the scene tree for the first time.

func _ready():
	refresh_stats_display()

func _process(delta):
	refresh_stats_display()
	

func refresh_stats_display():
	vitality_display.text = str(player_stats.vitality)
	strength_display.text = str(player_stats.strength)
	calc_strength_display.text = str(stats.strength)
	agility_display.text = str(player_stats.agility)
	calc_agility_display.text = str(stats.agility)
	durability_display.text = str(player_stats.durability)
	calc_durability_display.text = str(stats.defense)
	force_display.text = str(player_stats.force)
	calc_force_display.text = str(stats.force)
	spirit_display.text = str(player_stats.spirit)
	power_level_display.text = str(round(player_stats.powerLevel))
	if(round(player_stats.remaining_xp)>=1):
		xp_remaining_display.text = str(round(player_stats.remaining_xp))
	else:
		xp_remaining_display.text = "1"
	ap_display.text = str(player_stats.AP)


func _on_vitality_button_pressed():
	if (player_stats.AP >= 1):
		stats.set_stats("vitality",1)
		player_stats.AP = player_stats.AP - 1
	
func _on_strength_button_pressed():
	if (player_stats.AP >= 1):
		stats.set_stats("strength",1)
		player_stats.AP = player_stats.AP - 1

func _on_agility_button_pressed():
	if (player_stats.AP >= 1):
		stats.set_stats("agility",1)
		player_stats.AP = player_stats.AP - 1

func _on_durability_button_pressed():
	if (player_stats.AP >= 1):
		stats.set_stats("durability",1)
		player_stats.AP = player_stats.AP - 1

func _on_spirit_button_pressed():
	if (player_stats.AP >= 1):
		stats.set_stats("spirit",1)
		player_stats.AP = player_stats.AP - 1

func _on_force_button_pressed():
	if (player_stats.AP >= 1):
		stats.set_stats("force",1)
		player_stats.AP = player_stats.AP - 1
