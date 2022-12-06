extends KinematicBody2D

signal enemyPowerLevel(powerLevel)
signal regen()
# Variables
var facing = Vector2.ZERO
var baseSpeed = 1
var currentSpeed
var velocity = Vector2.ZERO
var not_flying = true
var damage = 1
var knockback
var canMove = true

# On start 
onready var animation_player = $AnimationPlayer
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
	if(not_flying):
		currentSpeed = get_node("Stats").agility * 10 + 240
	else:
		currentSpeed = (get_node("Stats").agility * 10 + 240) * 2
	

func _physics_process(delta):
	if(canMove):
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
	if(canMove):
		if(velocity == Vector2.ZERO):
			animation_state.travel("Idle")
		elif(not_flying):
			animation_state.travel("Walk")
		elif(!not_flying):
			animation_state.travel("Fly")

func setBlendPos(facing):
	animation_tree.set("parameters/Idle/blend_position", facing)
	animation_tree.set("parameters/Walk/blend_position", facing)
	animation_tree.set("parameters/Fly/blend_position", facing)

func _input(event):
	#print(event)
	if(event.is_action_pressed("i_fly") && canMove):
		not_flying = !not_flying
		if (not_flying):
			position.y += 8
			#currentSpeed = (get_node("Stats").agility * 10 + 240)
			z_index = 0
			set_collision_layer_bit(0, true)
			set_collision_layer_bit(1, false)
			set_collision_mask_bit(1,false)
			#set_collision_mask_bit(0,true)
		else:
			position.y -= 8
			#currentSpeed = (get_node("Stats").agility * 10 + 240) * 2
			z_index = 1
			set_collision_layer_bit(0, false)
			set_collision_layer_bit(1, true)
			set_collision_mask_bit(1,true)
			#set_collision_mask_bit(0,false)
	if(event.is_action_pressed("i_attack") && canMove):
		match facing.normalized():
			Vector2.RIGHT: 
				animation_state.travel("player_attack_right")
			Vector2.LEFT: 
				animation_state.travel("player_attack_left")
			Vector2.DOWN: 
				animation_state.travel("player_attack_down")
			Vector2.UP: 
				animation_state.travel("player_attack_up")
	if(event.is_action_pressed("i_meditate")):
		canMove = !canMove
		animation_state.travel("player_meditation")
		emit_signal("regen")

# Punch hitbox entering enemy
func _on_Area2D_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.take_damage(damage, facing, knockback)

func _on_Enemies_enemy_died(powerLevel):
	print("got: ", powerLevel, " xp")
	emit_signal("enemyPowerLevel",powerLevel)

func _on_Stats_update_stats():
	baseSpeed = (get_node("Stats").agility * 10 + 240)
	if(not_flying):
		currentSpeed = baseSpeed
	else:
		currentSpeed = baseSpeed * 2
	damage = (get_node("Stats").strength)
	knockback = damage * 100
