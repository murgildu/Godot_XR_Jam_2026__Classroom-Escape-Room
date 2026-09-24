extends Node3D
var isDone: bool = false;
@onready var ModInvMachine = get_node("/root/MainStaging/Scene/TestScene/Node3D5")
@onready var  isDoneIndicator= get_node("/root/MainStaging/Scene/TestScene/StaticBody3D3")
@onready var room = get_node("../Room")
@onready var table_material: BaseMaterial3D = get_node("../ModularExponentiationStation/Table/StaticBody3D/MeshInstance3D").get_active_material(0)
func _ready() -> void:
	$SnapTree/SnapZone.has_picked_up.connect(_on_snap_tree_picked_up)
	$SnapTree/SnapZone.has_dropped.connect(_on_snap_tree_dropped)

func _on_snap_tree_picked_up(what_):
	if  ModInvMachine.isDone:
		if not isDone:
			room.set_lamp_color(table_material.albedo_color)
		isDone = true
		isDoneIndicator.visible=true
		$SnapTree/instruction_panel2/instruction_panel/instruction_faceOn.visible = true
		$SnapTree/instruction_panel2/instruction_panel/instruction_face.visible = false
	else:
		$SnapTree.play_wrong_order_sound()

func _on_snap_tree_dropped():
		$SnapTree/instruction_panel2/instruction_panel/instruction_faceOn.visible = false
		$SnapTree/instruction_panel2/instruction_panel/instruction_face.visible = true
	
