extends Node2D

#Get enemy damage
@onready var enemy_node = get_node("../")

#Show attack animation and hide on end
func _ready():
	visible = false

#Hit detection
func _on_damage_detector_body_entered(body):
	if body.is_in_group("player"):
		body.hit(enemy_node.DAMAGE)

func _on_animation_player_animation_started(anim_name):
	visible = true

func _on_animation_player_animation_finished(anim_name):
	visible = false
