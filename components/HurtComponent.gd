class_name HurtComponent
extends Node

@export var hurtbox_component: HurtboxComponent
@export var stats_component: StatsComponent
@export var invencible: Timer

func _ready():
	invencible.timeout.connect(func():
		hurtbox_component.is_invencible = false
	)
	hurtbox_component.hurt.connect(func(hitbox_component: HitboxComponent):
		hurtbox_component.is_invencible = true
		stats_component.health -= hitbox_component.damage
		
		take_damage.emit()
		invencible.start()
	)

signal take_damage(Vector2)
