extends MarginContainer

onready var saving_func = get_tree().get_root().get_node("Dev Island").get_node("Save & Load")

func _ready():
	self.visible = false
	self.set_process(false)

func _on_Save_Game_pressed():
	saving_func._save_game()
	get_tree().get_root().get_node("Dev Island").print_to_console("Game Saved!")

func _on_Load_Game_pressed():
	SaveOrLoad.load_game = true
	saving_func._create_or_load_save()
	get_tree().get_root().get_node("Dev Island").print_to_console("Loaded Game!")

func _on_Exit_pressed():
	get_tree().quit()
