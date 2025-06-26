extends CharacterBody2D

#Enemy stats
@export var SPEED: float = 20.0
@export var HEALTH: int = 5
@export var DAMAGE: int = 2

var attackDir: float = deg_to_rad(0)

#Required nodes
@onready var item_object = preload("res://Scenes/Items/ItemObject.tscn")
@onready var state_controller = get_node("StateMachine")
@export var player: CharacterBody2D

@onready var timer = get_node("AttackTimer")

@onready var projectiles = get_node("Projectiles")
@onready var bone = load("res://Scenes/Enemies/Bone.tscn")

#Movement direction variable
var direction: Vector2

#State machine conditions
var IsMoving: bool = false
var IsDying: bool = false
var JustHit: bool = false
var IsAttacking: bool = false
var CanAttack: bool = true

func _ready():
	state_controller.change_state("Idle")

#Movement function based on player position
func _physics_process(_delta):
	if player:
		direction = (player.global_transform.origin - self.global_transform.origin).normalized()
	move_and_slide()
	
	enemy_attack()

#Hit and attack timer and death state based on animations
func _on_animation_tree_animation_finished(anim_name):
	if ("hit_left" in anim_name) or ("hit_right" in anim_name):
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

#Reset attack when player is still within detection
func _on_attack_timer_timeout():
	if (player in get_node("attack_detection_up").get_overlapping_bodies() or 
	player in get_node("attack_detection_right").get_overlapping_bodies() or
	player in get_node("attack_detection_down").get_overlapping_bodies() or
	player in get_node("attack_detection_left").get_overlapping_bodies()) and !IsDying:		
		CanAttack = true
		state_controller.change_state("Attack")

#Attack function
func enemy_attack():
	if IsAttacking and CanAttack:
		shoot(attackDir)

#Projectile spawn function
func shoot(rot: float):
	CanAttack = false
	timer.start()
	
	var instance = bone.instantiate()
	instance.dir = rot
	instance.spawnPos = global_position
	instance.spawnRot = rot
	projectiles.add_child.call_deferred(instance)
	
#Chase detection
func _on_chase_detection_body_entered(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Move")


func _on_chase_detection_body_exited(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Idle")

#Attack detection based on direction
func _on_attack_detection_up_body_entered(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Attack")
		attackDir = deg_to_rad(0)


func _on_attack_detection_up_body_exited(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Move")


func _on_attack_detection_right_body_entered(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Attack")
		attackDir = deg_to_rad(90)


func _on_attack_detection_right_body_exited(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Move")


func _on_attack_detection_down_body_entered(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Attack")
		attackDir = deg_to_rad(180)


func _on_attack_detection_down_body_exited(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Move")


func _on_attack_detection_left_body_entered(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Attack")
		attackDir = deg_to_rad(270)


func _on_attack_detection_left_body_exited(body):
	if body.is_in_group("player") and !IsDying:
		state_controller.change_state("Move")
