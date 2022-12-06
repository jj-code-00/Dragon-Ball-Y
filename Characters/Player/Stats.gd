extends Node2D

signal update_stats()

var health # Lifeforce, when it runs out you die
var energy # Decreases drain from majority of actions.

var strength # Primary damage stat for Physical Damage.
var defense # Primary defensive stat for Physical Damage and Ki Damage
var agility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection.
var force # Primary damage stat for Ki Damage.
var accuracy # Increases your chance to hit. Reduced chance of deflection.
var powerLevel # total Strength

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 10
	energy = 20
	strength = 1
	defense = 1
	agility = 1
	force = 1
	accuracy = 1
	powerLevel = 5
	emit_signal("update_stats")

func get_health(): 
	return health
	
func get_energy(): 
	return energy
	
func get_strength(): 
	return strength
	
func get_defense(): 
	return defense
	
func get_agility(): 
	return agility
	
func get_force(): 
	return force

func get_accuracy(): 
	return accuracy
	
func set_stats(stat, amount):
	match stat:
		"health": 
			health += amount * 5
		"energy":
			energy += amount * 10
		"strength":
			strength += amount
		"defense":
			defense += amount
		"agility":
			agility += amount
		"force":
			force += amount
		"accuracy":
			accuracy += amount
		"all":
			health += amount * 5
			energy += amount * 10
			strength += amount
			defense += amount
			agility += amount
			force += amount
			accuracy += amount
			
	powerLevel = strength + defense + agility + force + accuracy
	emit_signal("update_stats")

func _on_Level_Up_Manager_level_up():
	set_stats("all", 1)
