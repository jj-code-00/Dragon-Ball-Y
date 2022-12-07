extends Node2D

signal update_stats()

var health # Lifeforce, when it runs out you die
var maxHealth
var energy # Decreases drain from majority of actions.
var maxEnergy
var release

var strength # Primary damage stat for Physical Damage.
var defense # Primary defensive stat for Physical Damage and Ki Damage
var agility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection.
var force # Primary damage stat for Ki Damage.
var accuracy # Increases your chance to hit. Reduced chance of deflection.
var powerLevel # total Strength
var passiveHealthRegen
var passiveEnergyRegen
onready var healthBar = get_parent().get_node("UI/HealthBar")
onready var energyBar = get_parent().get_node("UI/EnergyBar")
var regen = false

func _process(delta):
	release = energy * 100 / maxEnergy
	change_health(passiveHealthRegen)
	change_energy(passiveEnergyRegen)
	if (health <= 0.0001):
		get_tree().reload_current_scene()
	if(regen):
		change_health(maxHealth * 0.0005)
		change_energy(maxEnergy * 0.001)

# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = 20.0
	health = maxHealth
	maxEnergy = 20.0
	energy = maxEnergy
	strength = 10.0
	defense = 1.0
	agility = 1.0
	force = 1.0
	accuracy = 1.0
	powerLevel = 5.0
	passiveHealthRegen = 0.0001
	passiveEnergyRegen = 0.0001
	emit_signal("update_stats")
	energyBar.value = (energy * 100 / maxEnergy)
	healthBar.value = (health * 100 / maxHealth)
	

func set_stats(stat, amount):
	match stat:
		"health": 
			maxHealth += amount * 5
		"energy":
			maxEnergy += amount * 10
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
			maxEnergy += amount * 10
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
	
	if (value < 0):
		value = value * -1
		var hitFor = 0.0
		if (value >= defense):
			hitFor = value * 2 - defense
		else :
			hitFor = value * value / defense
		health = health - hitFor
		$"Damage Indicator".start(.1)
		get_parent().get_node("Sprite").modulate = Color.red
	else:
		health += value
	
	health = clamp(health, 0, maxHealth)
	healthBar.value = (health * 100 / maxHealth)

func change_energy(value):
	energy += value
	energy = clamp(energy, 0, maxEnergy)
	energyBar.value = (energy * 100 / maxEnergy)

func _on_Damage_Indicator_timeout():
	get_parent().get_node("Sprite").modulate = Color.white


func _on_Player_regen():
	regen = !regen
