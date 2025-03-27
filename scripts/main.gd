extends Node2D

@onready var build_menu = $HUD/BuildMenu

var structure_instance = null
var placement_position = null
var is_placing: bool = false

func _ready():
	connect_signal(build_menu, "build_button_pressed")

func _process(_delta) -> void:
	handle_placement(get_global_mouse_position())

# BUILD FUNCTIONS
func start_placement(structure_type: GameData.StructureType):
	if GameData.get_structure_scene(structure_type):
		structure_instance = GameData.get_structure_scene(structure_type).instantiate()
		$Structures.add_child(structure_instance)
		is_placing = true
		build_menu._on_hide_button_toggled(true)
	else:
		print("Main.start_placement: structure scene is not found")

func handle_placement(mouse_position):
	if is_placing:
		if Input.is_action_pressed("cancel_placement"):
			cancel_placement()
	
		if Input.is_action_pressed("confirm_placement"):
			placement_position = get_global_mouse_position()
			confirm_placement()
		
		if structure_instance:
			structure_instance.global_position = mouse_position

func confirm_placement():
	is_placing = false
	
	structure_instance.position = placement_position
	structure_instance.find_child("Preview").queue_free()
	structure_instance.find_child("Sprite2D").show()
	
	structure_instance = null
	placement_position = null
	
	build_menu._on_hide_button_toggled(false)

func cancel_placement():
	is_placing = false
	structure_instance = null
	placement_position = null
	
	$Structures.get_child(-1).queue_free()
	build_menu._on_hide_button_toggled(false)

# SIGNAL FUNCTIONS
func _on_build_button_pressed_received(structure_type: GameData.StructureType):
	if not structure_instance:
		start_placement(structure_type)
	else:
		cancel_placement()
		start_placement(structure_type)

# HELPER FUNCTIONS
func connect_signal(sender: Node, signal_name: String):
	if sender:
		sender.connect(signal_name, Callable(self, "_on_" + signal_name + "_received"))
	else:
		print("Main.connect_signal: sender is false")
