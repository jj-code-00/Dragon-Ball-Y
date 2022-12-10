extends MarginContainer

func _on_New_Game_pressed():
	SaveOrLoad.new_game = true
	get_tree().change_scene("res://Scenes/Dev Island.tscn")
	

func _on_Button_pressed():
	SaveOrLoad.load_game = true
	get_tree().change_scene("res://Scenes/Dev Island.tscn")
