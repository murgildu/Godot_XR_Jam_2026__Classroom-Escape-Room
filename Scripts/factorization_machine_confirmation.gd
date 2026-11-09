extends Node3D
signal completed

enum Phase { Q1, Q2, DONE }
var isDone :=false
var phase: Phase = Phase.Q1
var inserted := false
var first_completion := true
@onready var numb = get_node("/root/MainStaging/Scene/TestScene/StaticBody3D").randNum
var can_press := true 

@onready var game_controller = get_node("../GameController")
@onready var is_done_indicator = get_node("/root/MainStaging/Scene/TestScene/StaticBody3D2")
@onready var room = get_node("../Room")
@onready var table_material: BaseMaterial3D = get_node("../Node3D2/StaticBody3D/MeshInstance3D").get_active_material(0)
@onready var face_on = $SnapTree/instruction_panel2/instruction_panel/instruction_faceOn
@onready var face_on2 = $SnapTree/instruction_panel2/instruction_panel/instruction_faceOn2
@onready var face = $SnapTree/instruction_panel2/instruction_panel/instruction_face

func _ready() -> void:
	$SnapTree/SnapZone.has_picked_up.connect(_on_snap_tree_picked_up)
	$SnapTree/SnapZone.has_dropped.connect(_on_snap_tree_dropped)

	for letter in ["A)", "B)", "C)"]:
		var button = get_node("/root/MainStaging/Scene/TestScene/%s/InteractableAreaButton" % letter)
		button.button_pressed.connect(_on_button_pressed)

func _on_button_pressed(button) -> void:
	if not inserted or not can_press:
		return
	can_press = false
	get_tree().create_timer(0.5).timeout.connect(func(): can_press = true)

	var button_letter = button.get_parent().name
	if first_completion:
		match numb:
			1:
				match phase:
					Phase.Q1:
						if button_letter == "A)":
							face_on.visible = false
							face_on2.visible = true
							phase = Phase.Q2
					Phase.Q2:
						if button_letter == "B)":
							face.visible = true
							face_on2.visible = false
							phase = Phase.DONE
							_complete()
						else:
							phase = Phase.Q1
							face_on.visible = true
							face_on2.visible = false
			2:
				match phase:
					Phase.Q1:
						if button_letter == "B)":
							face_on.visible = false
							face_on2.visible = true
							phase = Phase.Q2
					Phase.Q2:
						if button_letter == "B)":
							face.visible = true
							face_on2.visible = false
							phase = Phase.DONE
							_complete()
						else:
							phase = Phase.Q1
							face_on.visible = true
							face_on2.visible = false
			3:
				match phase:
					Phase.Q1:
						if button_letter == "C)":
							face_on.visible = false
							face_on2.visible = true
							phase = Phase.Q2
					Phase.Q2:
						if button_letter == "B)":
							face.visible = true
							face_on2.visible = false
							phase = Phase.DONE
							_complete()
						else:
							phase = Phase.Q1
							face_on.visible = true
							face_on2.visible = false

func _complete() -> void:
	if not first_completion:
		return
	first_completion = false
	room.set_lamp_color(table_material.albedo_color)
	is_done_indicator.visible = true
	isDone=true
	completed.emit()

func _on_snap_tree_picked_up(_what) -> void:
	inserted = true
	if first_completion:
		face_on.visible = true
		face.visible = false
	
	if not game_controller.is_playing():
		return


func _on_snap_tree_dropped() -> void:
	inserted = false
	face_on2.visible = false
	face_on.visible = false
	face.visible = true
