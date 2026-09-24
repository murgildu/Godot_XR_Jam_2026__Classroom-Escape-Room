extends Node

signal game_ended

enum State { PLAYING, WON, LOST }

const RESTART_BUTTON := "ax_button"

var state: State = State.PLAYING
var restart_requested := false
var restart_button_down := false

@onready var gameplay_scene: XRToolsSceneBase = get_parent()
@onready var countdown = get_node("../countdown_housing2/Label3D")
@onready var right_controller: XRController3D = get_node("../XROrigin3D/RightHand")
@onready var win_screen: MeshInstance3D = get_node("../XROrigin3D/XRCamera3D/YouWinScreen")
@onready var lose_screen: MeshInstance3D = get_node("../XROrigin3D/XRCamera3D/GameOverScreen")
@onready var machines: Array[Node3D] = [
	get_node("../Node3D3"),
	get_node("../Node3D4"),
	get_node("../Node3D5"),
	get_node("../ModularExponentiationMachine"),
]


func _ready() -> void:
	countdown.timer_finished.connect(_on_timer_finished)
	for machine in machines:
		machine.completed.connect(_on_machine_completed)
	right_controller.button_pressed.connect(_on_right_button_pressed)
	right_controller.button_released.connect(_on_right_button_released)
	restart_button_down = right_controller.is_button_pressed(RESTART_BUTTON)
	win_screen.visible = false
	lose_screen.visible = false


func is_playing() -> bool:
	return state == State.PLAYING


func _on_machine_completed() -> void:
	if not is_playing():
		return
	for machine in machines:
		if not machine.isDone:
			return
	_finish_game(State.WON)


func _on_timer_finished() -> void:
	_finish_game(State.LOST)


func _finish_game(result: State) -> void:
	if not is_playing():
		return
	state = result
	countdown.stop()
	win_screen.visible = state == State.WON
	lose_screen.visible = state == State.LOST

	# End interactions without pausing head tracking, movement, or visible hands.
	for area in gameplay_scene.find_children("*", "Area3D", true, false):
		if area is XRToolsSnapZone:
			area.enabled = false
	for machine in machines:
		var introduction: Area3D = machine.get_node("IntroductionArea")
		introduction.set_deferred("monitoring", false)
		introduction.get_node("AudioStreamPlayer3D").stop()
	game_ended.emit()


func _on_right_button_pressed(button: String) -> void:
	if button != RESTART_BUTTON or restart_button_down:
		return
	restart_button_down = true
	if is_playing() or restart_requested:
		return
	restart_requested = true
	_restart_game.call_deferred()


func _on_right_button_released(button: String) -> void:
	if button == RESTART_BUTTON:
		restart_button_down = false


func _restart_game() -> void:
	# The ending panel already confirmed the restart; skip a second button prompt.
	var staging = get_node("/root/MainStaging")
	if staging is XRToolsStaging:
		staging.prompt_for_continue = false
	gameplay_scene.reset_scene()
