extends CharacterBody2D

#Projectile speed
@export var SPEED: int = 40

@onready var enemy_node = get_node("../../")

#Physics variables
var dir: float
var spawnPos: Vector2
var spawnRot: float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
#Projectile physics simulation
func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()

#Hit detection
func _on_damage_detector_body_entered(body):
	if body.is_in_group("player"):
		body.hit(enemy_node.DAMAGE)
		queue_free()

#Projectile timeout
func _on_life_timeout():
	queue_free()
