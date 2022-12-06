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

onready var healthBar = $TextureProgress
onready var gameManager = get_tree().get_root().get_node("Dev Island")
onready var hitCooldown = $"Hit Cooldown"

# Called when the node enters the scene tree for the first time.
func _ready():
	currentSpeed = baseSpeed
	healthBar.value = 100
	currentHealth = maxHealth
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(canAttack && hitCooldown.is_stopped()):
		hitCooldown.start(.6)
		gameManager.get_player().get_node("Stats").change_health(-1 * damage)
	if(currentHealth <= 0):
		get_parent().get_parent().actor_died(powerLevel)
		queue_free()

func _physics_process(delta):
	var player_distance = gameManager.get_player_position() - self.position
	if (sqrt(player_distance.x * player_distance.x + player_distance.y * player_distance.y)  >= 32):
		var player_direction = player_distance.normalized()
		move_and_slide(player_direction * currentSpeed)
	if(knockedBack):
		move_and_slide(directionHit * knockbackRecieved * delta)

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
	directionHit = direction
	knockbackRecieved = knockback
	knockedBack = true

func _on_Damage_Indicator_timeout():
	$Sprite.modulate = Color.white
	knockedBack = false

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player")):
		print("in")
		canAttack = true

func _on_Area2D_body_exited(body):
	if(body.is_in_group("Player")):
		canAttack = false
