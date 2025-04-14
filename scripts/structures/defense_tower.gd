extends UpgradeableStructure


@onready var attack_component: AttackComponent = $AttackComponent
@onready var health_component: HealthComponent = $HealthComponent

var stats = GameData.StructureStats["base_dt"]

func _ready() -> void:
	structure_type = GameData.StructureType.DEFENSE
	super._ready()
	type_abbreviation = "dt"
	await get_tree().process_frame
	configure_stats()

func configure_stats() -> void:
	attack_component.configure(stats.damage, stats.attack_speed)
	health_component.configure(stats.health)
