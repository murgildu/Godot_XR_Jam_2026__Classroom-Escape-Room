extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var numb = get_node("/root/MainStaging/Scene/TestScene/StaticBody3D").randNum
	match numb:
		1:
			$Label3D.visible=true
			$Label3D2.visible=false
			$Label3D3.visible=false
		2:
			$Label3D.visible=false
			$Label3D2.visible=true
			$Label3D3.visible=false
		3:
			$Label3D.visible=false
			$Label3D2.visible=false
			$Label3D3.visible=true
