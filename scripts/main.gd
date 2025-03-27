extends Node2D

@onready var build_menu = $HUD/BuildMenu
@onready var player_side = $Background/PlayerSide
@onready var opponent_side = $Background/OpponentSide

var structure_instance = null
var placement_position = null
var is_placing: bool = false
var is_placeable: bool = false
# var is_overlapping: bool = false # TODO

func _ready():
#region SIGNAL CONNECTIONS
	connect_signal(build_menu, "build_button_pressed")
	connect_signal(player_side, "mouse_entered_player_side")
	connect_signal(player_side, "mouse_exited_player_side")
#endregion

func _process(_delta) -> void:
	handle_placement(get_global_mouse_position())

#region BUILD FUNCTIONS
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
	if is_placeable:
		is_placing = false
		
		structure_instance.position = placement_position
		structure_instance.find_child("Preview").queue_free()
		structure_instance.find_child("Sprite2D").show()
		
		structure_instance = null
		placement_position = null
		
		build_menu._on_hide_button_toggled(false)
	else:
		cancel_placement()

func cancel_placement():
	is_placing = false
	structure_instance = null
	placement_position = null
	
	$Structures.get_child(-1).queue_free()
	build_menu._on_hide_button_toggled(false)
	opponent_side.hide()
#endregion

#region SIGNAL FUNCTIONS
func _on_build_button_pressed_received(structure_type: GameData.StructureType):
	if not structure_instance:
		start_placement(structure_type)
	else:
		cancel_placement()
		start_placement(structure_type)

func _on_mouse_entered_player_side_received():
	is_placeable = true
	if is_placing:
		opponent_side.hide()

func _on_mouse_exited_player_side_received():
	is_placeable = false
	if is_placing:
		opponent_side.show()
#endregion

# HELPER FUNCTIONS
func connect_signal(sender: Node, signal_name: String):
	if sender:
		sender.connect(signal_name, Callable(self, "_on_" + signal_name + "_received"))
	else:
		print("Main.connect_signal: sender is false")
