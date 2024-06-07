extends Control

@onready var escape_text = $EscapeText
@onready var esc_timer = $EscTimer

var escaping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if escaping:
			get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")
		else:
			handle_escape()
	
func handle_escape():
	escaping = true
	escape_text.visible = true
	esc_timer.start()
	
func _on_esc_timer_timeout():
	escaping = false
	escape_text.visible = false
