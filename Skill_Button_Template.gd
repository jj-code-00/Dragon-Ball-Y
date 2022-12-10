extends Button

signal skill_name(name,ap_cost)
var ap_cost


func _on_Skill_Button_Template_pressed():
	emit_signal("skill_name",self.text,ap_cost)
