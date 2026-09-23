extends StaticBody3D

@onready var snap_zone: XRToolsSnapZone = $SnapZone
@onready var screen: MeshInstance3D = $Screen

func _ready() -> void:
	snap_zone.has_picked_up.connect(_on_picked_up)
	snap_zone.has_dropped.connect(_on_dropped)

func _on_picked_up(_what):
	screen.visible = true

func _on_dropped():
	screen.visible = false
