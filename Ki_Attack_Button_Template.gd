extends Button

var ap_cost

onready var player_stats = get_tree().get_root().get_node("Dev Island").get_node("Player").stats

func _on_Ki_Attack_Button_Template_pressed():
	match self.text:
		"Ki Blast": 
			if(player_stats.AP >= ap_cost && !player_stats.has_ki_blast):
				player_stats.AP -= ap_cost
				player_stats.has_ki_blast = true
				get_tree().get_root().get_node("Dev Island").print_to_console(self.text + " Unlocked!")
				self.text = self.text + " [Owned]"
