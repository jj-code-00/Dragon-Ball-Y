class_name SaveGameAsJSON
extends Reference

const SAVE_GAME_PATH := "user://save.json"

var character: Resource = Character.new()

var global_position := Vector2.ZERO

var _file := File.new()

func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)

func write_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.WRITE)
	if error != OK:
		printerr("Could not open the file %s. Aborting save operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return
	
	var data := {
		"global_position":
		{
			"x": global_position.x,
			"y": global_position.y,
		},
		"player":
		{
			"vitality": character.vitality,
			"health": character.health,
			"maxHealth": character.maxHealth,
			"spirit": character.spirit,
			"energy": character.energy,
			"maxEnergy": character.maxEnergy,
			"strength": character.strength,
			"agility": character.agility,
			"durability": character.agility,
			"force": character.force,
			"powerLevel": character.powerLevel,
			"movement_speed": character.movement_speed,
			"knock_back": character.knock_back,
			"level": character.level,
			"ap_required": character.ap_required,
			"AP": character.AP,
			"has_ki_blast": character.has_ki_blast,
			"has_flight": character.has_flight,
			"has_transformation_1": character.has_transformation_1
		}
	}
	var json_string := JSON.print(data)
	_file.store_string(json_string)
	_file.close()
	
func load_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.READ)
	if error != OK:
		printerr("Could not open the file %s. Aborting load operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var content := _file.get_as_text()
	_file.close()

	var data: Dictionary = JSON.parse(content).result
	global_position = Vector2(data.global_position.x, data.global_position.y)
	
	character = Character.new()
	character.vitality = data.player.vitality
	character.health = data.player.health
	character.maxHealth = data.player.maxHealth
	character.spirit = data.player.spirit
	character.energy = data.player.energy
	character.maxEnergy = data.player.maxEnergy
	character.strength = data.player.strength
	character.agility = data.player.agility
	character.durability = data.player.durability
	character.force = data.player.force
	character.powerLevel = data.player.powerLevel
	character.movement_speed = data.player.movement_speed
	character.knock_back = data.player.knock_back
	character.level = data.player.level
	character.ap_required = data.player.ap_required
	character.AP = data.player.AP
	character.has_ki_blast = data.player.has_ki_blast
	character.has_flight = data.player.has_flight
	character.has_transformation_1 = data.player.has_transformation_1
