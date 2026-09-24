extends StaticBody3D

const WRONG_ORDER_SOUND: AudioStream = preload("res://Audio/usb_wrong_order.wav")


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


func play_wrong_order_sound() -> void:
	# XR Tools starts the normal docking sound before emitting has_picked_up.
	# Reuse its spatial player so an invalid insertion only plays the error cue.
	var audio_player: AudioStreamPlayer3D = $SnapZone/AudioStreamPlayer3D
	audio_player.stop()
	audio_player.stream = WRONG_ORDER_SOUND
	audio_player.play()
