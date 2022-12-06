extends KinematicBody2D

onready var direction = get_tree().get_root().get_node("Dev Island").get_node("Player").facing.normalized()
onready var damage = get_tree().get_root().get_node("Dev Island").get_node("Player").get_node("Stats").force

func _physics_process(delta):
	var move = move_and_collide(direction * 25)
	if (move != null):
		if(move.collider.is_in_group("Enemy")):
			move.collider.take_damage(damage, direction, damage * 100)
		queue_free()