extends Camera2D

var root

func _ready():
	root = get_tree().get_root()

func _process(_delta):
	root.canvas_transform.origin = Vector2(round(root.canvas_transform.origin.x), round(root.canvas_transform.origin.y))
