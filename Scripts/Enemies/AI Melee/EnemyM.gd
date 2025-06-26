extends CharacterBody2D

#Enemy stats
@export var SPEED: float = 30.0
@export var HEALTH: int = 2
@export var DAMAGE: int = 1

#Required nodes
@onready var item_object = preload("res://Scenes/Items/ItemObject.tscn")
@onready var state_controller = get_node("StateMachine")
@export var player: CharacterBody2D

#Movement direction variable
var direction: Vector2

#State machine conditions
var IsMoving: bool = false
var IsDying: bool = false
var JustHit: bool = false
var IsAttacking: bool = false

func _ready():
	state_controller.change_state("Idle")
	
#Movement function based on player position
func _physics_process(_delta):
	if player:
		direction = (player.global_transform.origin - self.global_transform.origin).normalized()
	move_and_slide()

#Chase detection
func _on_chase_detection_body_entered(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Move")


func _on_chase_detection_body_exited(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Idle")

#Attack detection
func _on_attack_detection_body_entered(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Attack")


func _on_attack_detection_body_exited(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Move")

#Hit and attack timer and death state based on animations
func _on_animation_tree_animation_finished(anim_name):
	if ("attack_left" in anim_name) or ("attack_right" in anim_name):
		if (player in get_node("attack_detection").get_overlapping_bodies()) and !IsDying:
			state_controller.change_state("Attack")
	elif ("hit_left" in anim_name) or ("hit_right" in anim_name):
		JustHit = false
		if IsAttacking:
			state_controller.change_state("Attack")
		else:
			state_controller.change_state("Move")
	elif "death" in anim_name:
		death()

#Death state function	
func death():
	var item_object_temp = item_object.instantiate()
	item_object_temp.global_position = self.global_position
	get_node("../../Items").add_child(item_object_temp)
	self.queue_free()

#Hit function
func hit(damage: int):
	if !JustHit:
		state_controller.change_state("Hit")
		HEALTH -= damage
		if HEALTH <= 0:
			state_controller.change_state("Death")

#Attack function
func _on_damage_detector_body_entered(body):
	if body.is_in_group("player"):
		body.hit(DAMAGE)
