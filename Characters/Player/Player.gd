extends KinematicBody2D

signal enemyPowerLevel(powerLevel)
signal is_meditating(value)
signal ki_blast()
signal transform_one()
signal base_form()
signal timer_tick()
signal start_release()
signal end_release()
# Variables
var facing = Vector2.ZERO
var baseSpeed = 1
var currentSpeed
var velocity = Vector2.ZERO
var is_flying = false
var damage = 1
var knockback
var canMove = true
var zoomLevel
var auraToggle = false
var blockInput = false
var is_transformed = false
var combat_logged = false
var is_meditating = false
var can_attack = true
var aiming

# On start 
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var hitbox = $Area2D/Hitbox
onready var cam = $Camera2D
onready var direction_cursor = $"Direction Cursor"

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.disabled = true
	hitbox.position = Vector2(0,4)
	animation_state.travel("Idle")
	currentSpeed = baseSpeed
	knockback = damage * 10
	zoomLevel = cam.get_zoom()
	$Aura.modulate = Color(0.53,1.74,3.47)
	$Aura.modulate.a = 0.25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# make check so cursor doesnt invert
	aiming = (get_global_mouse_position() - self.position).normalized()
	hitbox.position = aiming * 16
	direction_cursor.position = aiming * 16
	hitbox.look_at(get_global_mouse_position())
	direction_cursor.look_at(get_global_mouse_position())
	select_animation()
	if(!is_flying):
		currentSpeed = baseSpeed
	else:
		currentSpeed = baseSpeed * 2
	if ($Stats.energy <= 0.1 && is_flying):
		land()
	if ($Stats.energy <= 0.1 && is_transformed):
		emit_signal("base_form")
		is_transformed = false
	if(Input.is_action_pressed("i_increase_release")):
		canMove = false
		animation_state.travel("Idle")
		$Aura.visible = true
		emit_signal("start_release")
	elif(Input.is_action_just_released("i_increase_release")) :
		emit_signal("end_release")
		canMove = true
		# mastering form may turn this off
		if(!is_transformed):
			$Aura.visible = false
	if (is_meditating && combat_logged):
		$"Stats/Level Up Manager".gameManager.print_to_console("You can't meditate in combat.")
		canMove = true
		is_meditating = false
		emit_signal("is_meditating", false)

func _physics_process(delta):
	if(canMove):
		velocity.x = Input.get_axis("i_left","i_right")
		velocity.y = Input.get_axis("i_up","i_down")
		velocity = velocity.normalized() * currentSpeed
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
		elif(!is_flying):
			animation_state.travel("Walk")
		elif(is_flying && $Stats.energy > 0):
			animation_state.travel("Fly")

func setBlendPos(facing):
	animation_tree.set("parameters/Idle/blend_position", facing)
	animation_tree.set("parameters/Walk/blend_position", facing)
	animation_tree.set("parameters/Fly/blend_position", facing)
	animation_tree.set("parameters/Attack/blend_position", aiming)

func _input(event):
	#print(event)
	if(event.is_action_pressed("i_fly") && canMove && $Stats.energy > 1 && $Stats/Skills.has_flight):
		if (is_flying):
			land()
			is_flying = false
		else:
			take_off()
			is_flying = true
	if(event.is_action_pressed("i_attack") && canMove && can_attack):
		can_attack = false
		hitbox.disabled = false
		animation_state.travel("Attack")
		$"Area2D/Attack Cooldown".start(.2)
	if(event.is_action_pressed("i_meditate")):
		if (is_flying):
			land()
		if(is_meditating):
			canMove = true 
			emit_signal("is_meditating", false)
			is_meditating = false
		else:
			is_meditating = true
			animation_state.travel("player_meditation")
			canMove = false
			emit_signal("is_meditating", true)
	if(event.is_action_pressed("i_ki_blast") && !blockInput):
		emit_signal("ki_blast")
	if(event.is_action_pressed("i_zoom_in")):
		zoomLevel.x -= .5
		zoomLevel.y -= .5
		zoomLevel.x = clamp(zoomLevel.x,0.5,1)
		zoomLevel.y = clamp(zoomLevel.y,0.5,1)
		cam.set_zoom(zoomLevel)
	elif(event.is_action_pressed("i_zoom_out")):
		zoomLevel.x += .5
		zoomLevel.y += .5
		zoomLevel.x = clamp(zoomLevel.x,0.5,1)
		zoomLevel.y = clamp(zoomLevel.y,0.5,1)
		cam.set_zoom(zoomLevel)
	if(event.is_action_pressed("i_transform_1") && $Stats.energy > 1 && $Stats/Skills.has_transformation_1):
		emit_signal("transform_one")
		is_transformed = true
	elif(event.is_action_pressed("i_return_to_base")):
		emit_signal("base_form")
		is_transformed = false

# Punch hitbox entering enemy
func _on_Area2D_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.take_damage(get_node("Stats").strength, aiming, knockback)
		$"Combat Log Timer".start(1)
		combat_logged = true

func _on_Enemies_enemy_died(powerLevel):
	emit_signal("enemyPowerLevel",powerLevel)

func _on_Stats_update_stats():
	baseSpeed = (get_node("Stats").agility + 250)
	if(!is_flying):
		currentSpeed = baseSpeed
	else:
		currentSpeed = baseSpeed * 2
	damage = (get_node("Stats").strength)
	knockback = damage * 10
	
func take_off():
	position.y -= 8
	#currentSpeed = (get_node("Stats").agility * 10 + 240) * 2
	z_index = 1
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(1,true)
	is_flying = true
	#set_collision_mask_bit(0,false)
func land():
	position.y += 8
	#currentSpeed = (get_node("Stats").agility * 10 + 240)
	z_index = 0
	set_collision_layer_bit(0, true)
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1,false)
	is_flying = false
	#set_collision_mask_bit(0,true)


func _on_Per_Second_Timer_timeout():
	emit_signal("timer_tick")
	if (is_flying):
		$Stats.change_energy(-1)
	if (is_transformed) :
		$Stats.change_energy(-2)

func _on_Combat_Log_Timer_timeout():
	combat_logged = false


func _on_Attack_Cooldown_timeout():
	can_attack = true
	hitbox.disabled = true
