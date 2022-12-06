extends Node2D

signal enemy_died(powerLevel)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func testingParent():
	print("success")
	
func actor_died(powerLevel):
	emit_signal("enemy_died", powerLevel)
