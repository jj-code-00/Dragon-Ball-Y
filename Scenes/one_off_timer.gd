extends Timer

func _process(delta):
	if(self.is_stopped()):
		queue_free()
