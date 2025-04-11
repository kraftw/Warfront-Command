extends Node
class_name HealthComponent

var max_health: float = 100.0
var current_health: float = 100.0


func configure(new_max_health: float) -> void:
	max_health = new_max_health
	current_health = new_max_health

func take_damage(amount: float) -> void:
	current_health -= amount
	print("current_health:", current_health)
	if current_health <= 0:
		die()

func die():
	#get_parent().queue_free()
	print("dead")
