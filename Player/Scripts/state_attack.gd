class_name State_Attack extends State

var isAttacking: bool = false
@export var attack_sound : AudioStream
@export_range(1, 20, .5) var decelerate_speed: float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"

func Enter() -> void:
	player.UpdateAnimation("attack")
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	attack_anim.play("attack_" + player.AnimDirection())
	animation_player.animation_finished.connect(EndAttack)
	isAttacking = true
	pass

func Exit() -> void: 	
	animation_player.animation_finished.disconnect(EndAttack)
	isAttacking = false
	
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if isAttacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func EndAttack(_newAnimName: String) -> void:
	isAttacking = false
