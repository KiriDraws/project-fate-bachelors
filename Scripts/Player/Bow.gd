extends Node2D

#Show attack animation and hide on end
func _ready():
	visible = false

func _on_animation_player_animation_started(anim_name):
	visible = true

func _on_animation_player_animation_finished(anim_name):
	visible = false
