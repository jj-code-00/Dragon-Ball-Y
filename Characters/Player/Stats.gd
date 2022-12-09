extends Node2D

signal update_stats()
signal knocked_back(knockback_vector)

# dodge chance eq agility_defender / agilty_attacker + agilty_defender

var health # Lifeforce, when it runs out you die
var maxHealth
var energy # Decreases drain from majority of actions.
var maxEnergy
var release 
var maxRelease
var formMulti

var vitality
var baseStrength # Primary damage stat for Physical Damage.
var baseDefense # Primary defensive stat for Physical Damage and Ki Damage
var baseAgility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection.
var baseForce # Primary damage stat for Ki Damage.
var spirit

var strength # Primary damage stat for Physical Damage. (used for math)
var defense # Primary defensive stat for Physical Damage and Ki Damage (used for math)
var agility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection. (used for math)
var force # Primary damage stat for Ki Damage. (used for math)

var powerLevel = 0 # total Strength

var movement_speed
var knock_back_strength

onready var healthBar = get_parent().get_node("UI/Player HUD/Player GUI/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HealthBar")
onready var energyBar = get_parent().get_node("UI/Player HUD/Player GUI/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/EnergyBar")
onready var releaseLevel = get_parent().get_node("UI/Player HUD/Player GUI/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/EnergyBar/CenterContainer/Release")
onready var character_menu = get_parent().get_node("UI/Character Menu")
var releasing = false
var knock_back_vector

# Called when the node enters the scene tree for the first time.
func _ready():
	maxRelease = 1.0
	formMulti = 1.0
	release = maxRelease
	
	# Stats
	vitality = 1.0
	spirit = 1.0
	baseStrength = 1.0
	baseDefense = 1.0
	baseAgility = 1.0
	baseForce = 1.0
	strength = baseStrength * formMulti * release
	defense = baseDefense * formMulti * release
	agility = baseAgility * formMulti * release
	force = baseForce * formMulti * release
	# PL equation needs work
	update_power_level()
	movement_speed = agility + 250
	knock_back_strength = strength * 10
	emit_signal("update_stats")
	maxEnergy = spirit * 10
	energy = maxEnergy
	maxHealth = vitality * 10
	health = maxHealth
	energyBar.value = (energy * 100 / maxEnergy)
	healthBar.value = (health * 100 / maxHealth)
	releaseLevel.text = str(round(release * 100))

func _process(delta):
	# change health low condition
	if (health <= 0.0001):
		get_tree().reload_current_scene()
	if (energy / maxEnergy <= .5):
		max_release_set(energy / maxEnergy + .5) 
	else:
		max_release_set(1.0)

func set_stats(stat, amount):
	match stat:
		"vitality": 
			vitality += amount
		"spirit":
			spirit += amount
		"strength":
			baseStrength += amount
		"defense":
			baseDefense += amount
		"agility":
			baseAgility += amount
		"force":
			baseForce += amount
		"all":
			vitality += amount
			spirit += amount
			baseStrength += amount
			baseDefense += amount
			baseAgility += amount
			baseForce += amount
	strength = baseStrength * formMulti
	defense = baseDefense * formMulti
	agility = baseAgility * formMulti
	force = baseForce * formMulti
	maxHealth = vitality * 10
	maxEnergy = spirit * 10
	update_power_level()
	healthBar.value = (health * 100 / maxHealth)
	energyBar.value = (energy * 100 / maxEnergy)
	movement_speed = agility + 250
	knock_back_strength = strength * 10
	emit_signal("update_stats")
	
func take_damage(damage, direction, knockback, agility_attacker):
	var dodge_chance = calc_dodge_chance(agility_attacker)
	var percent = randf()
	if (percent > dodge_chance):
		var hitFor = 0.0
		if (damage >= defense):
			hitFor = damage * 2 - defense
			knock_back_vector = knockback * 2 - defense
		else :
			hitFor = damage * damage / defense
			knock_back_vector = knockback * knockback / defense
		health = health - hitFor
		
		if(!get_parent().get_node("Sounds/player_hurt_male").is_playing()):
			get_parent().get_node("Sounds/player_hurt_male").play()
		$"Damage Indicator".start(.1)
		get_parent().get_node("Sprite").modulate = Color.red
		get_parent().combat_logged = true
		get_parent().get_node("Combat Log Timer").start(1)
		health = clamp(health, 0, maxHealth)
		healthBar.value = (health * 100 / maxHealth)
		knock_back_vector = direction.normalized() * knock_back_vector
		emit_signal("knocked_back",knock_back_vector)
	else:
		print("dodged")
	
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
	if (releasing):
		release_change(0.05)

func _on_Player_start_release():
	releasing = true

func _on_Player_end_release():
	releasing = false
	
func release_change(value):
	release = release + value
	release = clamp(release,0,maxRelease)
	strength = baseStrength * formMulti * release
	defense = baseDefense * formMulti * release
	agility = baseAgility * formMulti * release
	force = baseForce * formMulti * release
	update_power_level()
	movement_speed = agility + 250
	knock_back_strength = strength * 10
	releaseLevel.text = str(round(release * 100))

func max_release_set(value):
	maxRelease = value
	release = clamp(release,0,maxRelease)
	strength = baseStrength * formMulti * release
	defense = baseDefense * formMulti * release
	agility = baseAgility * formMulti * release
	force = baseForce * formMulti * release
	update_power_level()
	movement_speed = agility + 250
	knock_back_strength = strength * 10
	releaseLevel.text = str(round(release * 100))
	
func update_power_level():
	powerLevel = (strength + defense + agility + force + vitality) * (spirit + force)
	
func calc_dodge_chance(attacker_agility):
	return agility / (attacker_agility + agility)
