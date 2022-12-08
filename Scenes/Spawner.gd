extends Node2D

var spawnAgain = true

# change this abomination
onready var spawn1 = $Spawn1.position
onready var spawn2 = $Spawn2.position
onready var spawn3 = $Spawn3.position
onready var spawn4 = $Spawn4.position
onready var spawn5 = $Spawn5.position
onready var spawn6 = $Spawn6.position
onready var spawn7 = $Spawn7.position
onready var spawn8 = $Spawn8.position
onready var spawn9 = $Spawn9.position
onready var spawn10 = $Spawn10.position
signal spawned

var num

# Called when the node enters the scene tree for the first time.
func _ready():
	num = 0
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	num = num % 10
	if(spawnAgain && !get_tree().get_root().get_node("Dev Island").enemyLimitReached):
		spawn()
		$Timer.start(3)
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
		4:
			cell.position = spawn5
		5:
			cell.position = spawn6
		6:
			cell.position = spawn7
		7:
			cell.position = spawn8
		8:
			cell.position = spawn9
		9:
			cell.position = spawn10
	
	add_child(cell)
	emit_signal("spawned")
	num = num + 1
	
func _on_Timer_timeout():
	spawnAgain = true
