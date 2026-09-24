extends Area3D

@export var narration: AudioStream

var has_played := false

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	# XRToolsPlayerBody uses 3D physics layer 20.
	set_collision_mask_value(20, true)
	audio_player.stream = narration
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if has_played or not body.is_in_group("player_body"):
		return

	has_played = true
	audio_player.play()
