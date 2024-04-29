class_name PlayerMoveComponent
extends Node

@export var actor: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var coyote_jump_timer: Timer
@export var movement_data: PlayerMovementData

var air_jump: bool = false
var just_wall_jumped: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var input_axis = Input.get_axis("ui_left", "ui_right")
	apply_gravity(delta)
	handle_wall_jump()
	handle_jump()
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	animate_player(input_axis)
	var was_on_floor = actor.is_on_floor()
	actor.move_and_slide()
	var just_left_ledge = was_on_floor and not actor.is_on_floor() and actor.velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	just_wall_jumped = false

func apply_gravity(delta):
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta
		
func handle_wall_jump():
	if not actor.is_on_wall_only(): return
	var wall_normal = actor.get_wall_normal()
	if Input.is_action_just_pressed("ui_up"):
		actor.velocity.x = (wall_normal.x * movement_data.speed)
		actor.velocity.y = movement_data.jump_velocity
		just_wall_jumped = true
		
func handle_jump():
	if actor.is_on_floor(): air_jump = true
	
	if actor.is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
			actor.velocity.y = movement_data.jump_velocity
	if not actor.is_on_floor():
		if Input.is_action_just_released("ui_up") and actor.velocity.y < movement_data.jump_velocity / 2:
			actor.velocity.y = movement_data.jump_velocity / 2 

		if Input.is_action_just_pressed("ui_up") and air_jump and not just_wall_jumped:
			actor.velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false

func handle_acceleration(input_axis, delta):
	if not actor.is_on_floor(): return
	if input_axis != 0:
		actor.velocity.x = move_toward(actor.velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_air_acceleration(input_axis, delta):
	if actor.is_on_floor(): return
	if input_axis != 0:
		actor.velocity.x = move_toward(actor.velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and actor.is_on_floor():
		actor.velocity.x = move_toward(actor.velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis: int, delta):
	if input_axis == 0 and not actor.is_on_floor():
		actor.velocity.x = move_toward(actor.velocity.x, 0, movement_data.air_resistance * delta)

func animate_player(input_axis: int):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not actor.is_on_floor():
		animated_sprite_2d.play("jump")
