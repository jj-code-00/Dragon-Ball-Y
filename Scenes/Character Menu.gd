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
	for i in Globals.skill_master_list.size():
		var skill = load("res://Scenes/Skill_Button_Template.tscn").instance()
		skill.text = Globals.skill_master_list[i].name
		var string = Globals.skill_master_list[i].description + " AP cost: " + str(Globals.skill_master_list[i].AP_cost)
		skill.set_tooltip(string)
		skill.ap_cost = Globals.skill_master_list[i].AP_cost
		skill.mouse_filter = 1
		$CenterContainer/TabContainer/Skills/MarginContainer/ScrollContainer/skill_list.add_child(skill)
	for k in Globals.ki_attack_master_list.size():
		var ki_attack = load("res://Scenes/Ki_Attack_Button_Template.tscn").instance()
		ki_attack.text = Globals.ki_attack_master_list[k].name
		var string = Globals.ki_attack_master_list[k].description + " AP cost: " + str(Globals.ki_attack_master_list[k].AP_cost)
		ki_attack.set_tooltip(string)
		ki_attack.ap_cost = Globals.ki_attack_master_list[k].AP_cost
		ki_attack.mouse_filter = 1
		$"CenterContainer/TabContainer/Ki Attacks/MarginContainer/ScrollContainer/ki_attack_list".add_child(ki_attack)
	# add race check
	for j in Globals.saiyan_transformation_master_list.size():
		var form = load("res://Scenes/Transformation_Button_Template.tscn").instance()
		form.text = Globals.saiyan_transformation_master_list[j].name
		var string = Globals.saiyan_transformation_master_list[j].description + " AP cost: " + str(Globals.saiyan_transformation_master_list[j].AP_cost)
		form.set_tooltip(string)
		form.ap_cost = Globals.saiyan_transformation_master_list[j].AP_cost
		form.mouse_filter = 1
		$"CenterContainer/TabContainer/Transformations/MarginContainer/ScrollContainer/transformations_list".add_child(form)
	set_process(false)
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
	if(round(player_stats.ap_required)>=1):
		xp_remaining_display.text = str(round(player_stats.ap_required))
	else:
		xp_remaining_display.text = "1"
	ap_display.text = str(player_stats.AP)


func _on_vitality_button_pressed():
	if (player_stats.AP >= player_stats.ap_required):
		stats.set_stats("vitality",1)
		print(str(player_stats.AP))
		player_stats.AP = player_stats.AP - player_stats.ap_required
		player_stats.level += 1
		get_parent().get_parent().get_node("Stats/Level Up Manager").level_up_formula()
	
func _on_strength_button_pressed():
	if (player_stats.AP >= player_stats.ap_required):
		stats.set_stats("strength",1)
		player_stats.AP = player_stats.AP - player_stats.ap_required
		player_stats.level += 1
		get_parent().get_parent().get_node("Stats/Level Up Manager").level_up_formula()

func _on_agility_button_pressed():
	if (player_stats.AP >= player_stats.ap_required):
		stats.set_stats("agility",1)
		player_stats.AP = player_stats.AP - player_stats.ap_required
		player_stats.level += 1
		get_parent().get_parent().get_node("Stats/Level Up Manager").level_up_formula()

func _on_durability_button_pressed():
	if (player_stats.AP >= player_stats.ap_required):
		stats.set_stats("durability",1)
		player_stats.AP = player_stats.AP - player_stats.ap_required
		player_stats.level += 1
		get_parent().get_parent().get_node("Stats/Level Up Manager").level_up_formula()

func _on_spirit_button_pressed():
	if (player_stats.AP >= player_stats.ap_required):
		stats.set_stats("spirit",1)
		player_stats.AP = player_stats.AP - player_stats.ap_required
		player_stats.level += 1
		get_parent().get_parent().get_node("Stats/Level Up Manager").level_up_formula()

func _on_force_button_pressed():
	if (player_stats.AP >= player_stats.ap_required):
		stats.set_stats("force",1)
		player_stats.AP = player_stats.AP - player_stats.ap_required
		player_stats.level += 1
		get_parent().get_parent().get_node("Stats/Level Up Manager").level_up_formula()
