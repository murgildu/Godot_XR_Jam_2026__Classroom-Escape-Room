extends StaticBody3D

@onready var FacMachine = get_node("/root/MainStaging/Scene/TestScene/Node3D3")
@onready var CalMachine = get_node("/root/MainStaging/Scene/TestScene/Node3D4")
@onready var ModInvMachine = get_node("/root/MainStaging/Scene/TestScene/Node3D5")
@onready var ModExpMachine = get_node("/root/MainStaging/Scene/TestScene/ModularExponentiationMachine")
@onready var YouWinScreen = get_node("/root/MainStaging/Scene/TestScene/XROrigin3D/XRCamera3D/YouWinScreen")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if FacMachine.isDone and CalMachine.isDone and ModInvMachine.isDone and ModExpMachine.isDone:
		YouWinScreen.visible=true
