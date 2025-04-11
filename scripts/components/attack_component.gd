extends Node
class_name AttackComponent


var damage: float = 0.0
var attack_speed: float = 1.0
var target: Node = null
var target_health: HealthComponent = null
var time_elapsed_since_attack: float = 0.0


func configure(new_damage: float, new_attack_speed: float) -> void:
	damage = new_damage
	attack_speed = new_attack_speed

func _process(delta: float) -> void:
	handle_attack(delta)

func handle_attack(delta: float) -> void:
	if not target or not is_instance_valid(target):
		return
	
	time_elapsed_since_attack += delta
	if time_elapsed_since_attack >= 1.0 / attack_speed:
		print("perform attack")
		perform_attack()
		time_elapsed_since_attack = 0.0

func perform_attack():
	if target_health:
		target_health.take_damage(damage)

func set_target(enemy: Node) -> void:
	print(enemy)
	var health_component = enemy.get_node_or_null("HealthComponent")
	if health_component:
		target = enemy
		target_health = health_component

func clear_target() -> void:
	target_health = null
