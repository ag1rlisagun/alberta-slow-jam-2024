extends CharacterBody2D

@onready var player_body = $"."
@onready var animate = $AnimatedSprite2D
@onready var timer = $DozeTimer
@onready var stamina = $StaminaTimer
@onready var action_prompt = $ActionPrompt2
@onready var pie = $Pie
@onready var square = $Square
@onready var croissant = $Croissant
@onready var tiramisu = $Tiramisu
@onready var pastry = $Pastry
@onready var coffee = $Coffee
@onready var cash = $Cash
@onready var bill = $Bill

var SPEED = 200
var has_idled = false
var stamina_full = false
var sprinting = false
var sitting = false
var seating_customer: CharacterBody2D = null 
var chair = null
var near_chair = false
var item_holding = null

func owl_player():
	pass
	
func has_customer():
	return seating_customer
	
func seat_customer(customer): 
	seating_customer = customer
	# print(customer)
	
func clear_customer():
	seating_customer = null

func _ready():
	has_idled = false
	timer.start()

func _physics_process(delta):
	
	if Input.is_action_pressed("sprint"):
		SPEED = 160
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
			
	if near_chair and chair != null:
		if chair.return_empty():
			if seating_customer != null:
				action_prompt.visible = true
				action_prompt.text = "Seat"
				if Input.is_action_just_pressed("action"):
					if seating_customer.return_state() == 2:
						seating_customer.get_seated(chair)
						chair = null
	else:
		action_prompt.visible = false
	
	move_and_slide()

func _on_timer_timeout():
	has_idled = true

func _on_area_2d_area_entered(area): # for seating customers
	if area.has_method("seat"):
		chair = area
		near_chair = true

func _on_area_2d_area_exited(area): 
	if area.has_method("seat"):
		chair = null
		near_chair = false

func _on_area_2d_body_entered(body):
	pass

func _on_area_2d_body_exited(body):
	pass
