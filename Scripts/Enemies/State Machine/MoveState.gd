extends Node

var AIController

#Waiting for animations to stop before starting movement
func _ready():
	AIController = get_parent().get_parent()
	if AIController.IsAttacking:
		await AIController.get_node("AnimationTree").animation_finished
		AIController.IsAttacking = false
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Move")

#Handling movement speed and direction
func _process(_delta):
	if AIController and !AIController.IsAttacking:
		AIController.velocity.x = AIController.direction.x * AIController.SPEED
		AIController.velocity.y = AIController.direction.y * AIController.SPEED
