extends Node2D

signal update_stats()

var health # Lifeforce, when it runs out you die
var maxHealth
var energy # Decreases drain from majority of actions.

var strength # Primary damage stat for Physical Damage.
var defense # Primary defensive stat for Physical Damage and Ki Damage
var agility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection.
var force # Primary damage stat for Ki Damage.
var accuracy # Increases your chance to hit. Reduced chance of deflection.
var powerLevel # total Strength
onready var healthBar = $ProgressBar
var regen = false

func _process(delta):
	if (health <= 0):
		get_tree().reload_current_scene()
	if(regen && health < maxHealth):
		change_health(0.001 * powerLevel)

# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = 10
	health = maxHealth
	energy = 20
	strength = 1
	defense = 1
	agility = 1
	force = 1
	accuracy = 1
	powerLevel = 5
	emit_signal("update_stats")
	healthBar.value = (health * 100 / maxHealth)

func set_stats(stat, amount):
	match stat:
		"health": 
			maxHealth += amount * 5
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
			maxHealth += amount * 5
			energy += amount * 10
			strength += amount
			defense += amount
			agility += amount
			force += amount
			accuracy += amount
			
	powerLevel = strength + defense + agility + force + accuracy
	healthBar.value = (health * 100 / maxHealth)
	emit_signal("update_stats")

func _on_Level_Up_Manager_level_up():
	set_stats("all", 1)
	
func change_health(value):
	health += value
	healthBar.value = (health * 100 / maxHealth)
	if (value < 0):
		$"Damage Indicator".start(.1)
		get_parent().get_node("Sprite").modulate = Color.red


func _on_Damage_Indicator_timeout():
	get_parent().get_node("Sprite").modulate = Color.white


func _on_Player_regen():
	regen = !regen
