class_name EnemyMovement extends CharacterBody2D

@export var move_speed: float = 30

var cardinal_direction: Vector2 = Vector2.ZERO
var move_direction: Vector2 = Vector2.ZERO
var state: String = "walk"
var states: Array[String] = ["walk", "idle"]

@onready var player: Player = $"../Player"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D2
@onready var timer: Timer = $Timer

func _ready() -> void:
	$Hitbox.Damaged.connect(TakeDamage)

func TakeDamage(_damage: int) -> void:
	queue_free()
	pass
	#timer.timeout.connect(_on_timeout)
	#timer.start()
#
#func _on_timeout() -> void:
	#state = states[randi_range(0, states.size() - 1)]
	#selectNewDirection()

func selectNewDirection() -> void:
	if state != "walk":
		move_direction = Vector2.ZERO
		UpdateAnimation("idle")
		return
	
	var direction = player.position - position
	
	if direction.length() < 1:
		move_direction = Vector2.ZERO
		UpdateAnimation("idle")
		return
	
	move_direction = direction.normalized()
	cardinal_direction = move_direction
	
	if abs(move_direction.x) > abs(move_direction.y):
		sprite.scale.x = -1 if move_direction.x < 0 else 1
	
	UpdateAnimation("walk")

func _physics_process(_delta: float) -> void:
	selectNewDirection()
	if state == "walk":
		velocity = move_direction * move_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if abs(cardinal_direction.x) > abs(cardinal_direction.y):
		return "side"
	elif cardinal_direction.y > 0:
		return "down"
	else:
		return "up"
