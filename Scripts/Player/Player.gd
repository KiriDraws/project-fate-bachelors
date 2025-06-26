extends CharacterBody2D

#Animation nodes
@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")

#Weapon nodes
@onready var sword_anim = get_node("Weapons/Sword/AnimationPlayer")
@onready var pickaxe_anim = get_node("Weapons/Pickaxe/AnimationPlayer")
@onready var bow_anim = get_node("Weapons/Bow/AnimationPlayer")
@onready var bow = get_node("Weapons/Bow")

#Bow attack cooldown
@onready var cooldown = get_node("Weapons/BowTimer")

#Projectile spawning nodes
@onready var projectiles = get_node("../Projectiles")
@onready var arrow = load("res://Scenes/Player/Weapons/Arrow.tscn")

#Animation node names
var idle_node_name: String = "Idle"
var move_node_name: String = "Move"
var hit_node_name: String = "Hit"
var death_node_name: String = "Death"

#Movement speed
const SPEED: float = 60.0

#State machine conditions
var JustHit: bool = false
var IsDying: bool = false
var IsMoving: bool = false
var IsAttacking: bool = false

#Movement input variable
var input: Vector2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Movement input function
func get_input():	
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()
	
func _physics_process(_delta):
	# Movement Script
	if !IsDying:
		var playerInput = get_input()
		#Animation direction based on input
		animation_tree.set("parameters/Move/blend_position", playerInput.x)
		animation_tree.set("parameters/Idle/blend_position", playerInput.x)
		animation_tree.set("parameters/Hit/blend_position", playerInput.x)
		
		velocity = playerInput * SPEED
		if velocity == Vector2.ZERO:
			IsMoving = false
		else:
			IsMoving = true	
		move_and_slide()
		
		# Attack with current weapon
		if Game.weapon_equipped.item_name == "Pickaxe":
			attack(pickaxe_anim)
		elif Game.weapon_equipped.item_name == "Bow":
			ranged_attack(bow_anim)
		else:
			attack(sword_anim)
		
	#Setting animation tree parameters
	animation_tree["parameters/conditions/IsDying"] = IsDying
	animation_tree["parameters/conditions/IsMoving"] = IsMoving
	animation_tree["parameters/conditions/IsNotMoving"] = !IsMoving
	animation_tree["parameters/conditions/JustHit"] = JustHit

# Hit Function
func hit(damage: int):
	if !JustHit:
		JustHit = true
		playback.travel(hit_node_name)
		Game.damage_player(damage)
		if Game.player_health <= 0:
			IsDying = true
			playback.travel(death_node_name)


#Weapon attack animation function
func attack(weapon: Node):
		if Input.is_action_just_pressed("attack_up"):
			weapon.play("attack_up")
		if Input.is_action_just_pressed("attack_down"):
			weapon.play("attack_down")
		if Input.is_action_just_pressed("attack_left"):
			weapon.play("attack_left")
		if Input.is_action_just_pressed("attack_right"):
			weapon.play("attack_right")
			
#Ranged weapon attack function
func ranged_attack(weapon: Node):
	if !IsAttacking:
		if Input.is_action_just_pressed("attack_up"):
			weapon.play("attack_up")
			shoot(deg_to_rad(0))
		if Input.is_action_just_pressed("attack_down"):
			weapon.play("attack_down")
			shoot(deg_to_rad(180))
		if Input.is_action_just_pressed("attack_left"):
			weapon.play("attack_left")
			shoot(deg_to_rad(270))
		if Input.is_action_just_pressed("attack_right"):
			weapon.play("attack_right")
			shoot(deg_to_rad(90))
			
#Projectile spawn function
func shoot(rot: float):
	IsAttacking = true
	cooldown.start()
	
	var instance = arrow.instantiate()
	instance.dir = rot
	instance.spawnPos = global_position
	instance.spawnRot = rot
	projectiles.add_child.call_deferred(instance)

#Hit timer and death state based on animations
func _on_animation_tree_animation_finished(anim_name):
	if ("hit_left" in anim_name) or ("hit_right" in anim_name):
		JustHit = false
	elif "death" in anim_name:
		await get_tree().create_timer(0.5).timeout
		get_node("GameOver").game_over()

#Bow cooldown reset
func _on_bow_timer_timeout():
	IsAttacking = false
