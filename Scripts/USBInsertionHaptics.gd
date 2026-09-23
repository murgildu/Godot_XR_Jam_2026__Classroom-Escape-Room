extends XRToolsRumbler


func _ready() -> void:
	var usb := get_parent() as XRToolsPickable
	usb.grabbed.connect(_on_usb_grabbed)


func _on_usb_grabbed(_usb: XRToolsPickable, by: Node3D) -> void:
	if by is XRToolsFunctionPickup:
		# Keep the inserting hand after release: snap zones grab on drop.
		target = by.get_controller()
	elif by is XRToolsSnapZone:
		rumble()
		# A later automatic snap must not reuse an earlier insertion's hand.
		target = null


func _exit_tree() -> void:
	cancel()
