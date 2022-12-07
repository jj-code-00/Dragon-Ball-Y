extends KinematicBody2D

onready var direction = (get_global_mouse_position() - self.position).normalized()
onready var damage = get_tree().get_root().get_node("Dev Island").get_node("Player").get_node("Stats").force

func _physics_process(delta):
	var move = move_and_collide(direction * 25)
	if (move != null):
		if(move.collider.is_in_group("Enemy")):
			get_tree().get_root().get_node("Dev Island").get_node("Player").combat_logged = true
			move.collider.take_damage(damage, direction, damage * 1000)
		queue_free()
