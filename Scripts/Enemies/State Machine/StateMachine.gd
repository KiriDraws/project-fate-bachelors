extends Node

#Initializing individual states
var state = {
	"Idle": preload("res://Scripts/Enemies/State Machine/IdleState.gd"), 
	"Move": preload("res://Scripts/Enemies/State Machine/MoveState.gd"), 
	"Attack": preload("res://Scripts/Enemies/State Machine/AttackState.gd"), 
	"Death": preload("res://Scripts/Enemies/State Machine/DeathState.gd"),
	"Hit": preload("res://Scripts/Enemies/State Machine/HitState.gd")
}

#Changing states utilizing the main node
func change_state(new_state: String):
	if get_child_count() != 0:
		if !("Death" in get_child(0).name):
			get_child(0).queue_free()
	if state.has(new_state):
		var temp_state = state[new_state].new()
		temp_state.name = new_state
		add_child(temp_state)
