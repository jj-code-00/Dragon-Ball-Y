extends KinematicBody2D

var maxHealth = 20.0
var currentHealth
var knockedBack = false
var directionHit
var knockbackRecieved
var powerLevel = 5
var canAttack = false
var damage = 1
var baseSpeed = 200
var currentSpeed
var defense = 1
var combatLogged = false
var canMove = true

onready var healthBar = $TextureProgress
onready var gameManager = get_tree().get_root().get_node("Dev Island")
onready var hitCooldown = $"Hit Cooldown"
var rng = RandomNumberGenerator.new()
var angle

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	currentSpeed = baseSpeed
	healthBar.value = 100
	currentHealth = maxHealth
	angle = rng.randf_range(0.0, 360.0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(canAttack && hitCooldown.is_stopped()):
		hitCooldown.start(.5)
		gameManager.get_player().get_node("Stats").change_health(-1 * damage)
	if(currentHealth <= 0.0001):
		get_parent().get_parent().actor_died(powerLevel)
		queue_free()

func _physics_process(delta):
	if(knockedBack):
		move_and_slide(directionHit * knockbackRecieved)
	elif(canMove):
		var player_distance = gameManager.get_player_position() - self.position
		if (player_distance.length() >= 32 && player_distance.length() <= 256 || combatLogged && player_distance.length() >= 32):
			var player_direction = player_distance.normalized()
			move_and_slide(player_direction * currentSpeed)
		elif(player_distance.length() >= 512):
			move_and_slide((Vector2.RIGHT.rotated((angle * PI)/180)) * (currentSpeed /2)) 
		if($"Change Direction".is_stopped()):
			$"Change Direction".start(3)
	

func take_damage(strength, direction, knockback):
	var hitFor = 0.0
	if (strength >= defense):
		hitFor = strength * 2 - defense
	else :
		hitFor = strength * strength / defense
	currentHealth -= hitFor
	healthBar.value = (currentHealth * 100 / maxHealth)
	$"Damage Indicator".start(.1)
	$Sprite.modulate = Color.red
	directionHit = direction.normalized()
	knockbackRecieved = knockback
	knockedBack = true
	$"Knockback Timer".start(.2)
	combatLogged = true
	$"Combat Log Timer".start(10)

func _on_Damage_Indicator_timeout():
	$Sprite.modulate = Color.white
	

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player")):
		combatLogged = true
		$"Combat Log Timer".start(10)
		canAttack = true

func _on_Area2D_body_exited(body):
	if(body.is_in_group("Player")):
		canAttack = false


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
