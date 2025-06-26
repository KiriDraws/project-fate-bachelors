extends Node

var AIController

#Initializing attack animation and state
func _ready():
	AIController = get_parent().get_parent()
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	AIController.IsAttacking = true

#Pausing movement for attack
func _process(_delta):
	if AIController:
		AIController.velocity.x = 0
		AIController.velocity.y = 0
