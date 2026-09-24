extends Node3D
var isDone: bool = false;
@onready var CalMachine = get_node("/root/MainStaging/Scene/TestScene/Node3D4")
@onready var  isDoneIndicator= get_node("/root/MainStaging/Scene/TestScene/StaticBody3D5")
func _ready() -> void:
	$SnapTree/SnapZone.has_picked_up.connect(_on_snap_tree_picked_up)
	$SnapTree/SnapZone.has_dropped.connect(_on_snap_tree_dropped)

func _on_snap_tree_picked_up(what_):
	if  CalMachine.isDone:
		isDone = true
		isDoneIndicator.visible=true
		$SnapTree/instruction_panel2/instruction_panel/instruction_faceOn.visible = true
		$SnapTree/instruction_panel2/instruction_panel/instruction_face.visible = false

func _on_snap_tree_dropped():
		$SnapTree/instruction_panel2/instruction_panel/instruction_faceOn.visible = false
		$SnapTree/instruction_panel2/instruction_panel/instruction_face.visible = true
	
