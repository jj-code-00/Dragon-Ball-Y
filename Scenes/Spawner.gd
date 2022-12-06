extends Node2D

var spawnAgain = true
onready var spawn1 = $Spawn1.position
onready var spawn2 = $Spawn2.position
onready var spawn3 = $Spawn3.position
onready var spawn4 = $Spawn4.position
var num
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	num = 0
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	num = num % 4
	if(spawnAgain):
		spawn()
		$Timer.start(5)
		spawnAgain = false

func spawn():
	var scene = load("res://Characters/Enemies/Cell/Cell.tscn")
	var cell = scene.instance()
	
	match num:
		0:
			cell.position = spawn1
		1:
			cell.position = spawn2
		2:
			cell.position = spawn3
		3:
			cell.position = spawn4
	
	add_child(cell)
	num = num + 1
	
func _on_Timer_timeout():
	spawnAgain = true
