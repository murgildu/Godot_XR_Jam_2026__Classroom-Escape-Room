extends Node3D

enum Phase { IDLE, WAITING, WARNING, RESULT, STOPPED }

const MAX_INSPECTIONS := 2
const WARNING_SECONDS := 12.0
const PENALTY_SECONDS := 180.0
const RESULT_SECONDS := 10.0

var phase: Phase = Phase.IDLE
var inspections_done := 0
var displayed_seconds := -1
var saved_audio_volumes: Dictionary = {}

@onready var game_controller = get_node("../GameController")
@onready var countdown = get_node("../countdown_housing2/Label3D")
@onready var usb: XRToolsPickable = get_node("../USB")
@onready var belt_zone: XRToolsSnapZone = get_node("../XROrigin3D/PlayerBody/MeshInstance3D/SnapZone")
@onready var message_panel: MeshInstance3D = get_node("../XROrigin3D/XRCamera3D/InspectionMessage")
@onready var message_label: Label3D = message_panel.get_node("Label3D")
@onready var delay_timer: Timer = $DelayTimer
@onready var warning_timer: Timer = $WarningTimer
@onready var result_timer: Timer = $ResultTimer
@onready var alarm_audio: AudioStreamPlayer = $AlarmAudio
@onready var knock_audio: AudioStreamPlayer3D = $DoorKnockAudio


func _ready() -> void:
	usb.grabbed.connect(_on_usb_grabbed)
	game_controller.game_ended.connect(cancel)
	delay_timer.timeout.connect(_on_delay_timeout)
	warning_timer.timeout.connect(_on_warning_timeout)
	result_timer.timeout.connect(_on_result_timeout)
	knock_audio.global_position = get_node("../Room/DoorBody/Door").global_position + Vector3(0, 1.4, 0)
	message_panel.visible = false
	set_process(false)


func _on_usb_grabbed(_pickable: XRToolsPickable, by: Node3D) -> void:
	# Only the first hand pickup starts the schedule; docking never restarts it.
	if phase != Phase.IDLE or not game_controller.is_playing():
		return
	if by is XRToolsFunctionPickup:
		_schedule_inspection(20.0, 40.0)


func _schedule_inspection(minimum_delay: float, maximum_delay: float) -> void:
	if not game_controller.is_playing() or inspections_done >= MAX_INSPECTIONS:
		cancel()
		return
	phase = Phase.WAITING
	delay_timer.start(randf_range(minimum_delay, maximum_delay))


func _on_delay_timeout() -> void:
	if phase != Phase.WAITING or not game_controller.is_playing():
		return
	inspections_done += 1
	phase = Phase.WARNING
	displayed_seconds = -1
	message_label.modulate = Color(1.0, 0.85, 0.35)
	message_panel.visible = true
	_lower_machine_audio()
	warning_timer.start(WARNING_SECONDS)
	_update_warning_text()
	alarm_audio.play()
	set_process(true)


func _process(_delta: float) -> void:
	if phase == Phase.WARNING:
		_update_warning_text()


func _update_warning_text() -> void:
	var seconds_left := ceili(warning_timer.time_left)
	if seconds_left != displayed_seconds:
		displayed_seconds = seconds_left
		message_label.text = "PROFESSOR APPROACHING - %d\nHide the USB in your belt!\nLook academically innocent.\nCaught = -3:00" % seconds_left


func _on_warning_timeout() -> void:
	if phase != Phase.WARNING or not game_controller.is_playing():
		return
	# Set the phase before applying a penalty: reaching zero can end the game here.
	phase = Phase.RESULT
	set_process(false)
	alarm_audio.stop()
	var usb_is_hidden := belt_zone.picked_up_object == usb
	if not usb_is_hidden:
		countdown.apply_penalty(PENALTY_SECONDS)
	if not game_controller.is_playing():
		return
	knock_audio.play()
	if usb_is_hidden:
		message_label.modulate = Color(0.65, 1.0, 0.75)
		message_label.text = "INSPECTION PASSED\nSuspiciously studious.\nYou may resume your research."
	else:
		message_label.modulate = Color(1.0, 0.65, 0.5)
		message_label.text = "CAUGHT BORROWING!\n-3:00\nThe professor is keeping an eye on you."
	result_timer.start(RESULT_SECONDS)


func _on_result_timeout() -> void:
	if phase != Phase.RESULT or not game_controller.is_playing():
		return
	message_panel.visible = false
	_restore_machine_audio()
	_schedule_inspection(45.0, 75.0)


func _lower_machine_audio() -> void:
	for machine in game_controller.machines:
		for path in ["IntroductionArea/AudioStreamPlayer3D", "SnapTree/SnapZone/AudioStreamPlayer3D"]:
			var player: AudioStreamPlayer3D = machine.get_node(path)
			saved_audio_volumes[player] = player.volume_db
			player.volume_db -= 12.0


func _restore_machine_audio() -> void:
	for player in saved_audio_volumes:
		if is_instance_valid(player):
			player.volume_db = saved_audio_volumes[player]
	saved_audio_volumes.clear()


func cancel() -> void:
	phase = Phase.STOPPED
	set_process(false)
	delay_timer.stop()
	warning_timer.stop()
	result_timer.stop()
	alarm_audio.stop()
	knock_audio.stop()
	message_panel.visible = false
	_restore_machine_audio()
