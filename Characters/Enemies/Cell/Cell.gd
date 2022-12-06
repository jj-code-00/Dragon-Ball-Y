extends KinematicBody2D

var maxHealth = 20
var currentHealth
var knockedBack = false
var directionHit
var knockbackRecieved
var powerLevel = 100

onready var healthBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	healthBar.value = 100
	currentHealth = maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(currentHealth <= 0):
		get_parent().actor_died(powerLevel)
		queue_free()

func _physics_process(delta):
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

