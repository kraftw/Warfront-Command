extends UpgradeableStructure


@onready var attack_component: AttackComponent = $AttackComponent
@onready var health_component: HealthComponent = $HealthComponent

var stats = GameData.StructureStats["base_dt"]

func _init() -> void:
	structure_type = GameData.StructureType.DEFENSE
	type_abbreviation = "dt"
	configure_stats()

func configure_stats() -> void:
	attack_component.configure(stats.damage, stats.attack_speed)
	health_component.configure(stats.health)
