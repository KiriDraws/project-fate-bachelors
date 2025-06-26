extends Node

var AIController

#Initializing hit animation and state
func _ready():
	AIController = get_parent().get_parent()
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Hit")
	AIController.JustHit = true

#Pausing movement for hit animation
func _process(_delta):
	if AIController:
		AIController.velocity.x = 0
		AIController.velocity.y = 0
