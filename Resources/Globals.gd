extends Node

const MAX_KNOCKBACK = 1600

var skill_master_list = {
	0: {
		"name": "flight",
		"description": "Using your ki you can fly, this allows you to fly over certain obstacles",
		"AP_cost": 10
		},
	1: {
		"name": "ki_sense",
		"description": "This skill allows you to sense other's energy",
		"AP_cost": 5
	}
}

var ki_attack_master_list = {
	0: {
		"name": "Ki Blast",
		"description": "A basic ki attack",
		"ki_cost": "Costs 2.5 ki",
		"AP_cost": 5
	}
}

var saiyan_transformation_master_list = {
	0: {
		"name": "Super Saiyan",
		"description": "A transformation thought to simply be legend",
		"ki_drain": "2 ki/s",
		"AP_cost": 25
	}
}
