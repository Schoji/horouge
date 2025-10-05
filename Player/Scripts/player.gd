class_name Player extends CharacterBody2D

var isAttacked: bool = false
var cardinal_direction: Vector2 = Vector2.DOWN
@export var hp: int = 3
@export var max_hp: int = 3
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction: Vector2 = Vector2.ZERO
var mouseScreenPosition: String = "down"

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $Interactions/HitBox

signal DirectionChanged(new_direction: Vector2)
signal healthChanged()

func _ready() -> void:
	state_machine.Initialize(self)
	hit_box.Damaged.connect(TakeDamage)
	pass


func TakeDamage(_damage: int) -> void:
	if isAttacked:  # Zabezpieczenie przed wielokrotnym hitem
		return
	if (hp > 0):
		hp = hp - _damage
	
	healthChanged.emit(hp)
	isAttacked = true
	
	if hp <= 0:
		UpdateAnimation("destroy")
		await animation_player.animation_finished
		print("You are dead!")
	else:
		UpdateAnimation("stun")
		await animation_player.animation_finished
		isAttacked = false

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass

#func override_direction(direction: Vector2) -> void:
	#cardinal_direction = direction 
	#pass

func calculateMouseScreenPosition() -> void:
	var mousePosition = get_global_mouse_position()
	var mouseX = mousePosition[0]
	var mouseY = mousePosition[1]
	var screenSize: Vector2 = get_viewport().get_visible_rect().size
	var screenWidth = screenSize[0]
	var screenHeight = screenSize[1]
	var whereX: String
	var whereY: String
	if (mouseX <= screenWidth / 2):
		whereX = "left"
	else:
		whereX = "right"
	
	if (mouseY <= screenHeight / 2):
		whereY = "up"
	else:
		whereY = "down"
	
	
	if ( abs(screenWidth / 2 - mouseX) >= abs(screenHeight / 2 - mouseY)):
		mouseScreenPosition = whereX
	else:
		mouseScreenPosition = whereY

func _physics_process(_delta: float) -> void:
	#calculateMouseScreenPosition()
			
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
		
	
