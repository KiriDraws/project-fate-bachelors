extends Node

var AIController

#Initializing attack state
func _ready():
	AIController = get_parent().get_parent()
	AIController.IsAttacking = true

#Pausing movement for attack
func _process(_delta):
	if AIController:
		AIController.velocity.x = 0
		AIController.velocity.y = 0
