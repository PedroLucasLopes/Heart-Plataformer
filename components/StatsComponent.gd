class_name StatsComponent
extends Node

@export var health: int = 5 :
	set(value):
		health = value
		take_damage.emit()
		if health == 0: no_health.emit()

signal take_damage()
signal no_health()
