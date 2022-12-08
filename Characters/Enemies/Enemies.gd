extends Node2D

signal enemy_died(powerLevel)
	
func actor_died(powerLevel):
	emit_signal("enemy_died", powerLevel)
