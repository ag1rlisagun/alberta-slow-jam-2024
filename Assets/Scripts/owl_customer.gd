extends CharacterBody2D

@onready var animate = $AnimatedSprite2D

const SPEED = 200
var sitting = false

func owl_customer():
	# return state? so that player can check if in initial waiting state
	# and if true, then seat customer
	pass

func _physics_process(delta):
	if sitting:
		animate.play("sit")
	else:
		animate.play("idle")
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
	# move_and_slide()


func _on_area_2d_area_entered(area):
	if area.has_method("seat"):
		if area.seat() == true:
			sitting = true
			print("Sitting = " + str(sitting))
			# needs a method to move the character to the seat
			self.position.x = area.position.x
			self.position.y = area.position.y

func _on_area_2d_area_exited(area):
	if area.has_method("seat"):
		sitting = false
		print("Sitting = " + str(sitting))
