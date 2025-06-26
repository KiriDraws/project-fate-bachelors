extends CharacterBody2D

#Boss stats
@export var SPEED: float = 20.0
@export var HEALTH: int = 50
@export var DAMAGE: int = 3

var attackDir: float = deg_to_rad(0)

#Required nodes
@onready var item_object = preload("res://Scenes/Items/ItemObject.tscn")
@onready var state_controller = get_node("StateMachine")
@export var player: CharacterBody2D

@onready var timer = get_node("AttackTimer")
@onready var rotater = get_node("Rotater")

@onready var projectiles = get_node("Projectiles")
@onready var energy = load("res://Scenes/Enemies/Energy.tscn")

#Projectile pattern variables
const rotate_speed: float = 10
const timer_wait: float = 2
const spawn_point_count: int = 6
const radius: float = 12

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
	
	#Attack pattern spacing
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new() 
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle() + deg_to_rad(90)
		rotater.add_child(spawn_point)
	#Cooldown between attacks
	timer.wait_time = timer_wait
		
#Movement function
func _physics_process(delta):
	if player:
		direction = (player.global_transform.origin - self.global_transform.origin).normalized()
	move_and_slide()
	
	#Rotate attack for bullet pattern
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
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
			get_node("../../Player/WinScreen").win_game()
			state_controller.change_state("Death")

#Reset attack when player is still within detection
func _on_attack_timer_timeout():
	if (player in get_node("attack_detection").get_overlapping_bodies()) and !IsDying:		
		CanAttack = true
		state_controller.change_state("Attack")

#Attack function
func enemy_attack():
	if IsAttacking and CanAttack:
		shoot()
		
#Projectile spawn function based on rotater
func shoot():
	CanAttack = false
	timer.start()
	
	for s in rotater.get_children():
		
		var instance = energy.instantiate()
		instance.dir = s.global_rotation
		instance.spawnPos = s.global_position
		instance.spawnRot = s.global_rotation
		projectiles.add_child.call_deferred(instance)
	
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
