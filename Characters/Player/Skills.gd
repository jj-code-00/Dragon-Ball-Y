extends Node2D

onready var player_stats = get_parent().get_parent().stats

var is_meditating

func _ready():
	is_meditating = false

func _on_Player_ki_blast():
	if(player_stats.has_ki_blast && player_stats.energy >= 2.5):
		get_parent().change_energy(-2.5)
		var scene = load("res://Ki Attacks/Ki Blast.tscn")
		var ki_blast = scene.instance()
		ki_blast.position = get_parent().get_parent().position + ((get_global_mouse_position() - get_parent().get_parent().position).normalized() * 32)
		get_tree().get_root().get_node("Dev Island").add_child(ki_blast)
	else:
		get_parent().get_node("Level Up Manager").gameManager.print_to_console("You can't use that right now")

func _on_Player_transform_one():
	if player_stats.has_transformation_1:
		get_parent().get_parent().get_node("Hair").modulate = Color(3.46,2.33,0)
		get_parent().get_parent().get_node("Aura").modulate = Color(4.05,3.49,0.37) 
		get_parent().get_parent().get_node("Aura").modulate.a = 0.25
		get_parent().get_parent().get_node("Aura").visible = true
		get_parent().formMulti = 2.0
		get_parent().set_stats("all",0)

func _on_Player_base_form():
	get_parent().get_parent().get_node("Hair").modulate = Color.white
	get_parent().get_parent().get_node("Aura").modulate = Color(0.53,1.74,3.47)
	get_parent().get_parent().get_node("Aura").modulate.a = 0.25
	get_parent().get_parent().get_node("Aura").visible = false
	get_parent().formMulti = 1.0
	get_parent().set_stats("all",0)

func _on_Player_is_meditating(value):
	is_meditating = value

func _on_Player_timer_tick():
	if (is_meditating):
		get_parent().change_energy(.05 * player_stats.maxEnergy)
		get_parent().change_health(.05 * player_stats.maxHealth)
