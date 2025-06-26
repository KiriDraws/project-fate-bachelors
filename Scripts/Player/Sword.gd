extends Node2D

#Show attack animation and hide on end
func _ready():
	visible = false

#Hit detection
func _on_damage_detector_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit(Game.player_damage)

func _on_animation_player_animation_started(anim_name):
	visible = true

func _on_animation_player_animation_finished(anim_name):
	visible = false
