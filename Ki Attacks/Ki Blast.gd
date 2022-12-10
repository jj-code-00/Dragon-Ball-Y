extends KinematicBody2D

onready var direction = (get_tree().get_root().get_node("Dev Island").get_node("Player").get_node("Area2D/Hitbox").global_position - self.position).normalized()
onready var damage = get_tree().get_root().get_node("Dev Island").get_node("Player").stats.force
onready var agility = get_tree().get_root().get_node("Dev Island").get_node("Player").stats.agility

func _physics_process(delta):
	var move = move_and_collide(-direction * 25)
	if (move != null):
		if(move.collider.is_in_group("Enemy")):
			get_tree().get_root().get_node("Dev Island").get_node("Player").combat_logged = true
			get_tree().get_root().get_node("Dev Island").get_node("Player").get_node("Combat Log Timer").start(1)
			move.collider.take_damage(damage, -direction, damage * 10,agility)
		queue_free()
