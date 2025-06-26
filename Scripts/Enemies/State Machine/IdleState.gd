extends Node

var AIController

#Initializing idle animation
func _ready():
	AIController = get_parent().get_parent()
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Idle")

#Stopping movement
func _process(_delta):
	if AIController:
		AIController.velocity.x = 0
		AIController.velocity.y = 0
