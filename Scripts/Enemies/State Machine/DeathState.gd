extends Node

var AIController

#Initializing death animation and state
func _ready():
	AIController = get_parent().get_parent()
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Death")
	AIController.IsDying = true

#Stopping movement for death animation
func _process(_delta):
	if AIController:
		AIController.velocity.x = 0
		AIController.velocity.y = 0
