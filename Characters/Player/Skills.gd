extends Node2D

var has_ki_blast
var has_flight
var has_transformation_1
var is_meditating
# Color(100.0,3.49,0.58)
# master list of all skills 
func _ready():
	has_ki_blast = false
	has_flight = false
	has_transformation_1 = false
	is_meditating = false

func _on_Player_ki_blast():
	if(has_ki_blast && get_parent().energy > 5.0 && get_parent().get_parent().canMove):
		get_parent().change_energy(-2.5)
		var scene = load("res://Ki Attacks/Ki Blast.tscn")
		var ki_blast = scene.instance()
		ki_blast.position = get_parent().get_parent().position + ((get_global_mouse_position() - get_parent().get_parent().position).normalized() * 32)
		get_tree().get_root().get_node("Dev Island").add_child(ki_blast)
	else:
		get_parent().get_node("Level Up Manager").gameManager.print_to_console("You can't use that right now")

func _on_Level_Up_Manager_ki_attack_unlocked():
	get_parent().get_node("Level Up Manager").gameManager.print_to_console("You can now use Ki Blast! Hit F")
	has_ki_blast = true


func _on_Level_Up_Manager_flight_unlocked():
	get_parent().get_node("Level Up Manager").gameManager.print_to_console("You can now Fly! Hit R")
	has_flight = true


func _on_Player_transform_one():
	if has_transformation_1:
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


func _on_Level_Up_Manager_transform_1_unlocked():
	get_parent().get_node("Level Up Manager").gameManager.print_to_console("You unlocked Super Saiyan! Hit G")
	has_transformation_1 = true


func _on_Player_is_meditating(value):
	is_meditating = value

func _on_Player_timer_tick():
	if (is_meditating):
		get_parent().change_energy(.01 * get_parent().maxEnergy)
		get_parent().change_health(.01 * get_parent().maxHealth)
