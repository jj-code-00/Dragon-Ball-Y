extends Node2D

const movement_speed_cap = 2000

signal update_stats()
signal knocked_back(knockback_vector)

var release 
var maxRelease
var formMulti

var strength # Primary damage stat for Physical Damage. (used for math)
var defense # Primary defensive stat for Physical Damage and Ki Damage (used for math)
var agility # Decreases delay between actions &  Decreases your chance to be hit. Increased chance of deflection. (used for math)
var force # Primary damage stat for Ki Damage. (used for math)

onready var player_stats = get_parent().stats
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
	calc_current_stats()

func _process(delta):
	# change health low condition
	if (player_stats.health <= 0.0001):
		get_tree().reload_current_scene()
	if (player_stats.energy / player_stats.maxEnergy <= .5):
		max_release_set(player_stats.energy / player_stats.maxEnergy + .5) 
	else:
		max_release_set(1.0)

func set_stats(stat, amount):
	match stat:
		"vitality": 
			player_stats.vitality += amount
		"spirit":
			player_stats.spirit += amount
		"strength":
			player_stats.strength += amount
		"durability":
			player_stats.durability += amount
		"agility":
			player_stats.agility += amount
		"force":
			player_stats.force += amount
		"all":
			player_stats.vitality += amount
			player_stats.spirit += amount
			player_stats.strength += amount
			player_stats.durability += amount
			player_stats.agility += amount
			player_stats.force += amount
	strength = player_stats.strength * formMulti
	defense = player_stats.durability * formMulti
	agility = player_stats.agility * formMulti
	force = player_stats.force * formMulti
	player_stats.maxHealth = player_stats.vitality * 10
	player_stats.maxEnergy = player_stats.spirit * 10
	update_power_level()
	healthBar.value = (player_stats.health * 100 / player_stats.maxHealth)
	energyBar.value = (player_stats.energy * 100 / player_stats.maxEnergy)
	player_stats.movement_speed = clamp(agility + 250,250,movement_speed_cap)
	player_stats.knock_back = strength * 10
	emit_signal("update_stats")
	
func take_damage(damage, direction, knockback, agility_attacker):
	var dodge_chance = calc_dodge_chance(agility_attacker)
	var percent = randf()
	if (percent > dodge_chance):
		var hitFor = 0.0
		if (damage >= defense):
			hitFor = damage * 2 - defense
		else :
			hitFor = damage * damage / defense
		player_stats.health = player_stats.health - hitFor
		knock_back_vector = (hitFor / player_stats.maxHealth) * Globals.MAX_KNOCKBACK
		if(!get_parent().get_node("Sounds/player_hurt_male").is_playing()):
			get_parent().get_node("Sounds/player_hurt_male").play()
		$"Damage Indicator".start(.1)
		get_parent().get_node("Sprite").modulate = Color.red
		get_parent().combat_logged = true
		get_parent().get_node("Combat Log Timer").start(1)
		player_stats.health = clamp(player_stats.health, 0, player_stats.maxHealth)
		healthBar.value = (player_stats.health * 100 / player_stats.maxHealth)
		knock_back_vector = direction.normalized() * knock_back_vector
		emit_signal("knocked_back",knock_back_vector)
	else:
		get_tree().get_root().get_node("Dev Island").print_to_console("You dodged!")
	
func change_health(value):
	if (value < 0):
		value = value * -1
		var hitFor = 0.0
		if (value >= defense):
			hitFor = value * 2 - defense
		else :
			hitFor = value * value / defense
		player_stats.health = player_stats.health - hitFor
		$"Damage Indicator".start(.1)
		get_parent().get_node("Sprite").modulate = Color.red
		get_parent().combat_logged = true
		get_parent().get_node("Combat Log Timer").start(1)
	else:
		player_stats.health += value
	
	player_stats.health = clamp(player_stats.health, 0, player_stats.maxHealth)
	healthBar.value = (player_stats.health * 100 / player_stats.maxHealth)

func change_energy(value):
	player_stats.energy += value
	player_stats.energy = clamp(player_stats.energy, 0, player_stats.maxEnergy)
	energyBar.value = (player_stats.energy * 100 / player_stats.maxEnergy)

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
	strength = player_stats.strength * formMulti * release
	defense = player_stats.durability * formMulti * release
	agility = player_stats.agility * formMulti * release
	force = player_stats.force * formMulti * release
	update_power_level()
	player_stats.movement_speed = clamp(agility + 250,250,movement_speed_cap)
	player_stats.knock_back = strength * 10
	releaseLevel.text = str(round(release * 100))

func max_release_set(value):
	maxRelease = value
	release = clamp(release,0,maxRelease)
	strength = player_stats.strength * formMulti * release
	defense = player_stats.durability * formMulti * release
	agility = player_stats.agility * formMulti * release
	force = player_stats.force * formMulti * release
	update_power_level()
	player_stats.movement_speed = clamp(agility + 250,250,movement_speed_cap)
	player_stats.knock_back = strength * 10
	releaseLevel.text = str(round(release * 100))
	
func update_power_level():
	player_stats.powerLevel = (strength + defense + agility + player_stats.vitality) + (player_stats.spirit + force)
	
func calc_dodge_chance(attacker_agility):
	return clamp((agility / (attacker_agility + agility)) - .5,0,.5)
	
func calc_current_stats():
	strength = player_stats.strength * formMulti * release
	defense = player_stats.durability * formMulti * release
	agility = player_stats.agility * formMulti * release
	force = player_stats.force * formMulti * release
	update_power_level()
	player_stats.movement_speed = clamp(agility + 250,250,movement_speed_cap)
	
	player_stats.maxEnergy = player_stats.spirit * 10
	player_stats.energy = player_stats.maxEnergy
	player_stats.maxHealth = player_stats.vitality * 10
	player_stats.health = player_stats.maxHealth
	
	player_stats.knock_back = strength * 10
	
	energyBar.value = (player_stats.energy * 100 / player_stats.maxEnergy)
	healthBar.value = (player_stats.health * 100 / player_stats.maxHealth)
	releaseLevel.text = str(round(release * 100))
