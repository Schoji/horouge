class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var mouseScreenPosition: String = "down"

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	state_machine.Initialize(self)
	
	pass



func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	pass

func override_direction(direction: Vector2) -> void:
	cardinal_direction = direction 
	pass

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
	var new_dir: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
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
		
	
