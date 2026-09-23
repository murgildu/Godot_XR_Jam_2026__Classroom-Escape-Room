extends Label3D

signal timer_finished
var time_left := 600
var is_running := true

func _process(delta: float) -> void:
	if not is_running:
		return

	time_left -= delta

	if time_left <= 0:
		time_left = 0
		is_running = false
		get_node("/root/MainStaging/Scene/TestScene/XROrigin3D/XRCamera3D/GameOverScreen").visible = true
		get_node("/root/MainStaging/Scene/TestScene/DirectionalLight3D").visible = false
		get_node("/root/MainStaging/Scene/TestScene/XROrigin3D/LeftHand/XRToolsCollisionHand/LeftHand").visible = false
		get_node("/root/MainStaging/Scene/TestScene/XROrigin3D/RightHand/XRToolsCollisionHand/RightHand").visible = false

	update_text()

func update_text() -> void:
	var minutes := int(time_left) / 60
	var seconds := int(time_left) % 60
	text = "%02d:%02d" % [minutes, seconds]
