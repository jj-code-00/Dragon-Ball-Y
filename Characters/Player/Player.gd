extends KinematicBody2D

signal enemyPowerLevel(powerLevel)
# Variables
var facing = Vector2.ZERO
var baseSpeed = 1
var currentSpeed
var velocity = Vector2.ZERO
var not_flying = true
var damage = 1
var knockback

# On start values
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var hitbox = $Area2D/Hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.disabled = true
	hitbox.position = Vector2(0,4)
	animation_state.travel("Idle")
	currentSpeed = baseSpeed
	knockback = damage * 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select_animation()

func _physics_process(delta):
	velocity.x = Input.get_axis("i_left","i_right") * currentSpeed
	velocity.y = Input.get_axis("i_up","i_down") * currentSpeed
	move_and_slide(velocity)
	if (velocity != Vector2.ZERO):
		facing = Vector2.ZERO
		if(velocity.x != 0):
			facing.x = velocity.x
			setBlendPos(facing)
		elif(velocity.y != 0):
			facing.y = velocity.y
			setBlendPos(facing)

func select_animation():
	if(velocity == Vector2.ZERO):
		animation_state.travel("Idle")
	elif(not_flying):
		animation_state.travel("Walk")
	elif(!not_flying):
		animation_state.travel("Fly")
		

# 
func setBlendPos(facing):
	animation_tree.set("parameters/Idle/blend_position", facing)
	animation_tree.set("parameters/Walk/blend_position", facing)
	animation_tree.set("parameters/Fly/blend_position", facing)
	animation_tree.set("parameters/Attack/blend_position", facing)

func _input(event):
	#print(event)
	if(event.is_action_pressed("i_fly")):
		not_flying = !not_flying
		if (not_flying):
			position.y += 8
			currentSpeed = baseSpeed
			z_index = 0
			set_collision_layer_bit(0, true)
			set_collision_layer_bit(1, false)
		else:
			position.y -= 8
			currentSpeed = baseSpeed * 2
			z_index = 1
			set_collision_layer_bit(0, false)
			set_collision_layer_bit(1, true)
	if(event.is_action_pressed("i_attack")):
		print("hit")
		animation_state.travel("Attack")
		$"Hitbox Cooldown".start(.2)

# Punch hitbox entering enemy
func _on_Area2D_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.take_damage(damage, facing, knockback)

# Timer to disable hitbox as animation gets 
# interrupted and causes issues change animation to only rely on this for speed stat
func _on_Timer_timeout():
	hitbox.disabled = true
	hitbox.position = Vector2(0,4)
	$"Hitbox Cooldown".stop()

func _on_Enemies_enemy_died(powerLevel):
	print("got: ", powerLevel, " xp")
	emit_signal("enemyPowerLevel",powerLevel)


func _on_Stats_update_stats():
	baseSpeed = (get_node("Stats").get_agility() * 10 + 240)
	currentSpeed = baseSpeed
	damage = (get_node("Stats").get_strength())
	knockback = damage * 10
	
