extends Button

var ap_cost

onready var player_stats = get_tree().get_root().get_node("Dev Island").get_node("Player").stats

func _on_Skill_Button_Template_pressed():
	match self.text:
		"flight": 
			if(player_stats.AP >= ap_cost && !player_stats.has_flight):
				player_stats.AP - ap_cost
				player_stats.has_flight = true
				get_tree().get_root().get_node("Dev Island").print_to_console("Flight Unlocked!")
				self.text = "flight [Owned]"
		"ki sense":
			if(player_stats.AP >= ap_cost):
				pass
