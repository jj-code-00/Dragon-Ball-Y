extends KinematicBody2D

var maxHealth = 20
var currentHealth
var knockedBack = false
var directionHit
var knockbackRecieved
var powerLevel = 100
var canAttack = false
var damage = 1

onready var healthBar = $ProgressBar
onready var gameManager = get_tree().get_root().get_node("Dev Island")
onready var hitCooldown = $"Hit Cooldown"

# Called when the node enters the scene tree for the first time.
func _ready():
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
		move_and_slide(player_direction * 200)
	if(knockedBack):
		move_and_slide(directionHit * knockbackRecieved * delta)

func take_damage(damage, direction, knockback):
	currentHealth -= damage
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
		canAttack = true


func _on_Area2D_body_exited(body):
	if(body.is_in_group("Player")):
		canAttack = false
