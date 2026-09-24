extends Label3D

signal timer_finished
var time_left := 600.0
var is_running := true

func _ready() -> void:
	update_text()

func _process(delta: float) -> void:
	if not is_running:
		return

	time_left -= delta

	if time_left <= 0:
		time_left = 0
		is_running = false
		update_text()
		timer_finished.emit()
		return

	update_text()

func stop() -> void:
	is_running = false

func apply_penalty(seconds: float) -> void:
	if not is_running or seconds <= 0.0:
		return
	time_left = maxf(0.0, time_left - seconds)
	update_text()
	if time_left <= 0.0:
		is_running = false
		timer_finished.emit()

func update_text() -> void:
	var minutes := int(time_left) / 60
	var seconds := int(time_left) % 60
	text = "%02d:%02d" % [minutes, seconds]
