extends Control

@export var nothingscene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_nothing_pressed():
	get_tree().change_scene_to_packed(nothingscene)


func _on_exitbutton_pressed():
	get_tree().quit()
