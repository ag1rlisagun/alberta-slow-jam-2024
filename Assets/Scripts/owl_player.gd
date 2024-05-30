extends CharacterBody2D


var SPEED = 200.0
@onready var animate = $AnimatedSprite2D
@onready var timer = $DozeTimer
@onready var stamina = $StaminaTimer
var has_idled = false
var stamina_full = false
var sprinting = false
var sitting = false

func owl_player():
	pass

func _physics_process(delta):
	
	if Input.is_action_pressed("sprint"):
		SPEED = 200
		sprinting = true
	else:
		SPEED = 100
		sprinting = false

	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	if velocity.x && velocity.y:
		velocity.x *= .71
		velocity.y *= .71
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/2)
		velocity.y = move_toward(velocity.y, 0, SPEED/2)

	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if direction_x > 0:
			animate.flip_h = false
	elif direction_x < 0:
		animate.flip_h = true

	# start timer for player to sit still until doze animation plays
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right") or Input.is_action_just_released("move_down") or Input.is_action_just_released("move_up"):
		has_idled = false
		timer.start()
	
	# Play Animations
	if direction_x == 0 and direction_y == 0:
		if sitting:
			animate.play("sit")
		else:
			if has_idled:
				animate.play("doze_off")
			elif !has_idled:
				animate.play("idle")
	else:
		if sprinting:
			animate.play("sprint")
		else:
			animate.play("walk")
			
	move_and_slide()

func _on_timer_timeout():
	has_idled = true

func _on_stamina_timer_timeout():
	stamina_full = false

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
