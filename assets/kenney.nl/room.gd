extends Node3D

const COLOR_FADE_SECONDS := 0.7

var color_tween: Tween
var bulb_materials: Array[BaseMaterial3D] = []

@onready var lamps: Array[OmniLight3D] = [
	$Ceiling/OmniLight01,
	$Ceiling/OmniLight02,
	$Ceiling/OmniLight03,
]


func _ready() -> void:
	$Ceiling.visible = true
	for lamp in lamps:
		var bulb: MeshInstance3D = lamp.get_node("LampMesh")
		# Keep runtime bulb colors local to this room, including after a restart.
		var material: BaseMaterial3D = bulb.get_active_material(0).duplicate()
		bulb.material_override = material
		bulb_materials.append(material)


func set_lamp_color(color: Color) -> void:
	# A new completion can arrive before the previous fade has finished.
	if color_tween:
		color_tween.kill()
	color_tween = create_tween().set_parallel(true)
	color_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for lamp in lamps:
		color_tween.tween_property(lamp, "light_color", color, COLOR_FADE_SECONDS)
	for material in bulb_materials:
		color_tween.tween_property(material, "albedo_color", color, COLOR_FADE_SECONDS)
