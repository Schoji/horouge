class_name Player extends CharacterBody2D

var isAttacked: bool = false
@export var invincibility_duration: float = 0.5
var cardinal_direction: Vector2 = Vector2.DOWN
@export var hp: int = 5
@export var max_hp: int = 5
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction: Vector2 = Vector2.ZERO
var mouseScreenPosition: String = "down"

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $Interactions/HitBox
var is_invincible: bool = false

signal DirectionChanged(new_direction: Vector2)
signal healthChanged()

func _ready() -> void:
	state_machine.Initialize(self)
	hit_box.Damaged.connect(TakeDamage)
	pass


func TakeDamage(_damage: int) -> void:
	if is_invincible:  # Zabezpieczenie przed wielokrotnym hitem
		return
	if (hp > 0):
		hp = hp - _damage
	
	healthChanged.emit(hp)
	is_invincible = true  # Włącz nietykalność

	
	if hp <= 0:
		UpdateAnimation("destroy")
		#await animation_player.animation_finished
		print("You are dead!")
		get_node("../GameOver").game_over()
	else:
		UpdateAnimation("stun")
		await animation_player.animation_finished
		isAttacked = false
		
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
	
	if animation_player.is_playing():
		await animation_player.animation_finished
	isAttacked = false

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()


func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var new_dir: Vector2 = cardinal_direction
	
	var direction_id: int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4. size() ) )
	
	new_dir = DIR_4[direction_id]
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass
	

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
	
