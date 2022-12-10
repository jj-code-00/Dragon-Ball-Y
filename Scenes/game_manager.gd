extends Node2D

var _save := SaveGameAsJSON.new()

onready var _player := get_tree().get_root().get_node("Dev Island").get_node("Player")

func _ready():
	_player = get_tree().get_root().get_node("Dev Island").get_node("Player")
	_create_or_load_save()
	
func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
	else:
		_save = SaveGameAsJSON.new()

		_save.global_position = _player.global_position

		_save.write_savegame()

	# After creating or loading a save resource, we need to dispatch its data
	# to the various nodes that need it.
	_player.global_position = _save.global_position
	_player.stats = _save.character
func _save_game() -> void:
	_save.global_position = _player.global_position
	_save.write_savegame()
