extends Node3D
signal completed

var isDone: bool = false
@onready var game_controller = get_node("../GameController")
@onready var  isDoneIndicator= get_node("/root/MainStaging/Scene/TestScene/StaticBody3D2")
@onready var room = get_node("../Room")
@onready var table_material: BaseMaterial3D = get_node("../Node3D2/StaticBody3D/MeshInstance3D").get_active_material(0)

func _ready() -> void:
	$SnapTree/SnapZone.has_picked_up.connect(_on_snap_tree_picked_up)
	$SnapTree/SnapZone.has_dropped.connect(_on_snap_tree_dropped)
	
func _on_snap_tree_picked_up(_what):
	if not game_controller.is_playing():
		return
	var first_completion := not isDone
	if first_completion:
		room.set_lamp_color(table_material.albedo_color)
	isDone = true
	isDoneIndicator.visible=true
	$SnapTree/instruction_panel2/instruction_panel/instruction_faceOn.visible = true
	$SnapTree/instruction_panel2/instruction_panel/instruction_face.visible = false
	if first_completion:
		completed.emit()

func _on_snap_tree_dropped():
		$SnapTree/instruction_panel2/instruction_panel/instruction_faceOn.visible = false
		$SnapTree/instruction_panel2/instruction_panel/instruction_face.visible = true
	
