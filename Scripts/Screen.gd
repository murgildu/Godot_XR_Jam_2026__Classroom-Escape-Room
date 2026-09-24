extends StaticBody3D



@onready var snap_zone: XRToolsSnapZone = $SnapZone
@onready var screenOn: MeshInstance3D = $instruction_panel2/instruction_panel/instruction_faceOn
@onready var screenOff: MeshInstance3D = $instruction_panel2/instruction_panel/instruction_face

func _ready() -> void:
	snap_zone.has_picked_up.connect(_on_picked_up)
	snap_zone.has_dropped.connect(_on_dropped)


func _on_picked_up(_what):
	pass

func _on_dropped():
	pass
