extends KinematicBody2D

var maxHealth = 0
var currentHealth = 0
var maxEnergy
var currentEnergy
var strength
var defense
var agility
var force
var baseSpeed
var currentSpeed
var powerLevel
var level
var is_dead = false
var is_flying
var over_collision

var combatLogged = false
var canMove = true
var knockedBack = false
var directionHit
var knockbackRecieved
var canAttack = false

onready var healthBar = $TextureProgress
onready var gameManager = get_tree().get_root().get_node("Dev Island")
onready var hitCooldown = $"Hit Cooldown"
var rng = RandomNumberGenerator.new()
var angle
onready var player_distance
onready var player_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	over_collision = false
	is_flying = false
	level = 1
	rng.randomize()
	set_level(level)
	angle = rng.randf_range(0.0, 360.0)
	player_distance = gameManager.get_player_position() - self.position
	player_direction = player_distance.normalized()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_distance = gameManager.get_player_position() - self.position
	player_direction = player_distance.normalized()
	if(canAttack && hitCooldown.is_stopped()):
		hitCooldown.start(1)
		gameManager.get_player().get_node("Stats").take_damage(strength, player_direction,strength * 10)
	if (gameManager.get_player().is_flying && !is_flying):
		z_index = 1
		position.y -= 8
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1,true)
		is_flying = true
		currentSpeed = baseSpeed * 1.5
	elif(is_flying && !gameManager.get_player().is_flying && !over_collision):
		position.y += 8
		z_index = 0
		set_collision_layer_bit(0, true)
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(1,false)
		is_flying = false
		currentSpeed = baseSpeed
func _physics_process(delta):
	if(knockedBack):
		move_and_slide(directionHit * knockbackRecieved)
	elif(canMove && !is_dead):
		player_distance = gameManager.get_player_position() - self.position
		if (player_distance.length() >= 32 && player_distance.length() <= 512 || combatLogged && player_distance.length() >= 32):
			player_direction = player_distance.normalized()
			move_and_slide(player_direction * currentSpeed)
		elif(player_distance.length() >= 512):
			move_and_slide((Vector2.RIGHT.rotated((angle * PI)/180)) * (currentSpeed /2)) 
		if($"Change Direction".is_stopped()):
			$"Change Direction".start(3)
	

func take_damage(strength, direction, knockback):
	if(!is_dead):
		var hitFor = 0.0
		if (strength >= defense):
			hitFor = strength * 2 - defense
			knockbackRecieved = knockback * 2 - (defense * 10)
		else :
			hitFor = strength * strength / defense
			knockbackRecieved = knockback * knockback / (defense * 10)
		currentHealth -= hitFor
		if (currentHealth <= 0):
			var death_timer = load("res://Scenes/one_off_timer.tscn").instance()
			add_child(death_timer)
			death_timer.connect("timeout",self,"kill_entity")
			death_timer.start(10)
			knockbackRecieved = knockback * 2
			is_dead = true
			get_parent().get_parent().actor_died(powerLevel)
			$Sprite.rotate(PI/2)
			$TextureProgress.visible = false
			$CollisionShape2D.queue_free()
			$Area2D.queue_free()
		$"Damage Indicator".start(.1)
		$Sprite.modulate = Color.red
		healthBar.value = (currentHealth * 100 / maxHealth)
		directionHit = direction.normalized()
		knockedBack = true
		$"Knockback Timer".start(.2)
		combatLogged = true
		$"Combat Log Timer".start(5)
	
	
	
func set_level(value):
	level = value
	maxHealth = level * 10
	maxEnergy = level * 10
	currentEnergy = maxEnergy
	strength = level
	agility = level
	defense = level
	force = level
	powerLevel = strength + agility + defense + force
	baseSpeed = agility + 250
	currentSpeed = baseSpeed
	currentHealth = maxHealth
	healthBar.value = currentHealth / maxHealth * 100

func _on_Damage_Indicator_timeout():
	$Sprite.modulate = Color.white

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player")):
		combatLogged = true
		$"Combat Log Timer".start(5)
		canAttack = true
	if(body.is_in_group("Collisions")):
		over_collision = true

func _on_Area2D_body_exited(body):
	if(body.is_in_group("Player")):
		canAttack = false
	if(body.is_in_group("Collisions")):
		over_collision = false

func _on_Combat_Log_Timer_timeout():
	combatLogged = false

func _on_Change_Direction_timeout():
	angle = rng.randf_range(0.0, 360.0)

func _on_Knockback_Timer_timeout():
	knockedBack = false
	# potentially increase this with stronger stats
	$"Knock Out Timer".start(.1)
	canMove = false

func _on_Knock_Out_Timer_timeout():
	canMove = true

func kill_entity():
	queue_free()
