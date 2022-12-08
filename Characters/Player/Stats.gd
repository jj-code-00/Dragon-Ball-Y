extends Node2D

signal update_stats()
signal knocked_back(knockback_vector)

var health # Lifeforce, when it runs out you die
var maxHealth
var energy # Decreases drain from majority of actions.
var maxEnergy
var release 

var baseStrength # Primary damage stat for Physical Damage.
var baseDefense # Primary defensive stat for Physical Damage and Ki Damage
var baseAgility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection.
var baseForce # Primary damage stat for Ki Damage.

var strength # Primary damage stat for Physical Damage. (used for math)
var defense # Primary defensive stat for Physical Damage and Ki Damage (used for math)
var agility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection. (used for math)
var force # Primary damage stat for Ki Damage. (used for math)
var powerLevel # total Strength
onready var healthBar = get_parent().get_node("UI/HealthBar")
onready var energyBar = get_parent().get_node("UI/EnergyBar")
onready var releaseLevel = get_parent().get_node("UI/Release")
var formMulti
var releasing = false
var knock_back_vector

# Called when the node enters the scene tree for the first time.
func _ready():
	release = 1.0
	maxHealth = 20.0
	health = maxHealth
	maxEnergy = 20.0
	energy = maxEnergy
	baseStrength = 1.0
	baseDefense = 1.0
	baseAgility = 1.0
	baseForce = 1.0
	formMulti = 1.0
	strength = baseStrength * formMulti * release
	defense = baseDefense * formMulti * release
	agility = baseAgility * formMulti * release
	force = baseForce * formMulti * release
	powerLevel = (strength + defense + agility + force)
	emit_signal("update_stats")
	energyBar.value = (energy * 100 / maxEnergy)
	healthBar.value = (health * 100 / maxHealth)
	releaseLevel.text = str(release * 100)

func _process(delta):
	if (health <= 0.0001):
		get_tree().reload_current_scene()

func set_stats(stat, amount):
	match stat:
		"health": 
			maxHealth += amount * 10
		"energy":
			maxEnergy += amount * 10
		"strength":
			baseStrength += amount
		"defense":
			baseDefense += amount
		"agility":
			baseAgility += amount
		"force":
			baseForce += amount
		"all":
			maxHealth += amount * 10
			maxEnergy += amount * 10
			baseStrength += amount
			baseDefense += amount
			baseAgility += amount
			baseForce += amount
	strength = baseStrength * formMulti
	defense = baseDefense * formMulti
	agility = baseAgility * formMulti
	force = baseForce * formMulti
	powerLevel = strength + defense + agility + force
	healthBar.value = (health * 100 / maxHealth)
	energyBar.value = (energy * 100 / maxEnergy)
	emit_signal("update_stats")

func _on_Level_Up_Manager_level_up():
	set_stats("all", 1)
	
func take_damage(damage, direction, knockback):
	var hitFor = 0.0
	if (damage >= defense):
		hitFor = damage * 2 - defense
		knock_back_vector = knockback * 2 - defense
	else :
		hitFor = damage * damage / defense
		knock_back_vector = knockback * knockback / defense
	health = health - hitFor
	$"Damage Indicator".start(.1)
	get_parent().get_node("Sprite").modulate = Color.red
	get_parent().combat_logged = true
	get_parent().get_node("Combat Log Timer").start(1)
	health = clamp(health, 0, maxHealth)
	healthBar.value = (health * 100 / maxHealth)
	knock_back_vector = direction.normalized() * knock_back_vector
	emit_signal("knocked_back",knock_back_vector)
	
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
		get_parent().combat_logged = true
		get_parent().get_node("Combat Log Timer").start(1)
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

func _on_Player_timer_tick():
#	change_health(maxHealth * 0.001)
#	change_energy(maxEnergy * 0.001)
	if (releasing):
		release = release + 0.05
		release = clamp(release,0,1.0)
		strength = baseStrength * formMulti * release
		defense = baseDefense * formMulti * release
		agility = baseAgility * formMulti * release
		force = baseForce * formMulti * release
		powerLevel = (strength + defense + agility + force)
		releaseLevel.text = str(release * 100)

func _on_Player_start_release():
	releasing = true

func _on_Player_end_release():
	releasing = false
