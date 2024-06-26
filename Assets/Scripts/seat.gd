extends Area2D

# 1 if sitter should face right
# -1 if sitter should face left

@export var x_direction: int
var empty = true

func seat():
	pass

func return_empty():
	return empty

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.has_method("owl_customer"):
		if body.return_state() != 8:
			empty = false
			print("Empty = " + str(empty))

func _on_body_exited(body):
	if body.has_method("owl_customer"):
		empty = true
		print("Empty = " + str(empty))
