extends CharacterBody2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

var hitbox_position: int

func _ready():
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		hitbox_position = hitbox.global_position.x
	)
	hurt_component.take_damage.connect(func():
		knockback(13.0, hitbox_position)
	)

func knockback(force: float, x_pos: float = 0.0, up_force: float = 15.0):
		velocity = Vector2(force * 2, -force * up_force)
	#if knockback_force != Vector2.ZERO:
		#knockback_vector = knockback_force
		#
		#var knockback_tween = get_tree().create_tween()
		#knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
