extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var direction = get_tree().get_root().get_node("Dev Island").get_node("Player").facing.normalized()
onready var damage = get_tree().get_root().get_node("Dev Island").get_node("Player").get_node("Stats").force
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	var move = move_and_collide(direction * 25)
	if (move != null):
		if(move.collider.is_in_group("Enemy")):
			move.collider.take_damage(damage, direction, damage * 100)
		queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
