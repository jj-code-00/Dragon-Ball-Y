extends Node2D

var has_ki_blast = false

# master list of all skills 
func _ready():
	has_ki_blast = true

func _on_Player_ki_blast():
	if(has_ki_blast && get_parent().energy > 5.0):
		get_parent().change_energy(-2.5)
		var scene = load("res://Ki Attacks/Ki Blast.tscn")
		var ki_blast = scene.instance()
		ki_blast.position = get_parent().get_parent().position + (get_parent().get_parent().facing.normalized() * 32)
		get_tree().get_root().get_node("Dev Island").add_child(ki_blast)
	else:
		get_parent().get_node("Level Up Manager").gameManager.print_to_console("You can't use that right now")
	