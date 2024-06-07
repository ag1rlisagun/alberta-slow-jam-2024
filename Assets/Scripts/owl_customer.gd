extends CharacterBody2D

# game todo list:
# choosing food, showing it
# receiving food (input) from player 
# [show a little sprite to show which customer is being detected] 
#• all the sprites showing: customer requesting coffee, sprite indicating
# the customer is waiting for a range of time, player carrying food and the customer taking food
#• customers coming in at a proper rate (not too little not too many - according to number of seats)
#• also need to remember: need start menu, show controls (use the one bit ones sprites?), 
# options maybe (music volume?), A TRAILER (could be gameplay but could be cute
# [can make a tiny animation if time allows, i can make a few frames on procreate! 
# and i already have good music)]
#• scoring...... saves? not necessary (but in the future with resource management?) 
# Maybe!!!! high score for money made but thats it
#• in the future or if possible: highscore (want), customer can order 
# just coffee or just food, customers coming as groups and not just individuals, 
# change in difficulty (irate customers, coming going faster, ordering more than once),
# player has to take away dishes and there will be a timer for that too

# NEED TO PUT A MENU WITH PRICES SOMEWHERE (MORE FOR PLAYER THAN CUSTOMER)
# ^ IN THE CONTROLS/GAME INFO/TUTORIAL AREA "How To Play"
# CAN ALSO INCLUDE UI IN THE GAME SHOWING THE MENU TO THE PLAYER (YES)

# SCORE: DEPENDS ON FOOD ITEM PRICE BUT COFFEE IS ALWAYS $4
# SUBTRACT THAT SCORE IF CUSTOMER GOT COFFEE BUT FOOD TOOK TOO LONG AND THEY LEFT OR FOOD WAS WRONG
# SUBTRACT ENTIRE FOOD BILL IF TOOK TOO LONG TO GET THE BILL TO THE CUSTOMER 
# ADD ENTIRE BILL TO SCORE IF CUSTOMER GETS THEIR BILL
# CAN ADD A RANGE OF TIPS AS WELL (WITH A HEART, AND TEXT SAYING HOW MUCH TIP WAS GIVEN)

# need polish:
# little greetings, hearts, idk 

# player also shouldnt be able to leave area



enum {
	ENTER,
	SEAT_WAITING,
	BEING_SEATED,
	SITTING,
	DRINK_WAITING,
	DRINK_CONSUMING,
	FOOD_WAITING,
	FOOD_CONSUMING,
	BILL_WAITING,
	DONE
	}
	
@export var player: CharacterBody2D
@export var exit: Area2D
@export var entrance: Area2D

@onready var rng = RandomNumberGenerator.new()
@onready var current_state = ENTER

@onready var score_updated = false

@onready var animate = $AnimatedSprite2D
@onready var wait_45 = $FourFiveWait
@onready var wait_60 = $SixtyWait
@onready var idle_20 = $TwentyIdle
@onready var idle_30 = $ThirtyIdle
@onready var test_text = $StateText
@onready var customer_text = $CustomerText
@onready var nav = $NavigationAgent2D
@onready var pie = $Pie
@onready var square = $Square
@onready var croissant = $Croissant
@onready var tiramisu = $Tiramisu
@onready var pastry = $Pastry
@onready var coffee = $Coffee
@onready var cash = $Cash
@onready var order_bg = $OrderBG
@onready var order_pie = $OrderBG/OrderPie
@onready var order_square = $OrderBG/OrderSquare
@onready var order_croissant = $OrderBG/OrderCroissant
@onready var order_tiramisu = $OrderBG/OrderTiramisu
@onready var order_pastry = $OrderBG/OrderPastry
@onready var order_coffee = $OrderBG/OrderCoffee
@onready var order_bill = $OrderBG/OrderBill

const SPEED = 75

var player_near = false
var sitting = false
@onready var food_list = [order_coffee, order_croissant, order_pie, order_pastry, order_square]
var food_string_list = ["coffee", "croissant", "pie", "pastry", "square"]
var state_list = ["ENTER", "SEAT_WAITING", "BEING_SEATED", "SITTING", "DRINK_WAITING", "DRINK_CONSUMING", "FOOD_WAITING", "FOOD_CONSUMING", "BILL_WAITING", "DONE"]
var chair = null
var getting_seated = false
var bill = 0
var bill_paid = false
var current_food = null
var current_food_string = null
var chosen_food = false
var received_wrong_order = false

func owl_customer():
	pass

func return_state():
	return current_state
	
func follow_player(leader):
	# method to follow player
	current_state = BEING_SEATED
	
func receive_order(item): 
	# player calls this with an item in their hand 
	# responds depending on the item
	if current_state == DRINK_WAITING:
		if item != "coffee":
			wait_45.stop()
			
			bill = -bill
			current_state = DONE
			received_wrong_order = true
		else:
			wait_45.stop()
			current_state = DRINK_CONSUMING
	if current_state == FOOD_WAITING:
		if item != current_food_string:
			wait_60.stop()
			bill = -bill
			current_state = DONE
			received_wrong_order = true
		else:
			wait_60.stop()
			current_state = FOOD_CONSUMING
	if current_state == BILL_WAITING:
		if item != "bill":
			bill = -bill
			received_wrong_order = true
		else:
			bill_paid = true
		wait_45.stop()
		current_state = DONE
			
func get_seated(seat):
	chair = seat
	# print(chair)
	getting_seated = true
	
func choose_food(): # need to make a function to show the right food sprite
	if !chosen_food:
		rng.randomize()
		food_list.shuffle()
		current_food = food_list.front()
		current_food_string  = food_string_list[food_list.bsearch(current_food)]
		chosen_food = true
		
func order(food_item): 
# function to order any food, all the processes to show the food sprite, and the timer
# need to make separate the food/coffee sprites in the sheet
	order_bg.visible = true
	food_item.visible = true
	
func hide_order(food_item):
	order_bg.visible = false
	order_coffee.visible = false
	food_item.visible = false
	
func hold_item(item):
	if item == order_croissant:
		croissant.visible = true
	if item == order_tiramisu:
		tiramisu.visible = true
	if item == order_square:
		square.visible = true
	if item == order_pastry:
		pastry.visible = true
	if item == order_pie:
		pie.visible = true
	else:
		item.visible = true
	
func hide_item(item):
	if item == order_croissant:
		croissant.visible = false
	if item == order_tiramisu:
		tiramisu.visible = false
	if item == order_square:
		square.visible = false
	if item == order_pastry:
		pastry.visible = false
	if item == order_pie:
		pie.visible = false
	else:
		item.visible = false
		
func return_bill():
	return bill
	
func _ready():
	animate.set_modulate(Color(rng.randf_range(0.3, 1.0), rng.randf_range(0.3, 1.0), rng.randf_range(0.3, 1.0), 1))
	# print("Score Updated: " + str(score_updated))
	
func _process(delta):
	match current_state:
	# straight to done if customer receives wrong order or player takes too long
		ENTER:
			nav.set_target_position(entrance.position)
			var move_direction = position.direction_to(nav.get_next_path_position())
			velocity = move_direction * SPEED
			nav.set_velocity_forced(velocity)
			move_and_slide()
			if nav.is_target_reached():
				current_state = SEAT_WAITING
		SEAT_WAITING:
		# waiting at most for ~45 secs
		# customer has to be tagged to start following player
			if wait_45.is_stopped():
				wait_45.start()
				print("seat waiting, 45 sec timer START")
		BEING_SEATED:
		# following player for at most 45 secs
		# follow player until player interacts with a seat node, 
		# then customer sits at the seat (if empty)
		# once seated, thinking b/n 10-30 secs
			if wait_45.is_stopped():
				wait_45.start()
				print("being seated, 45 sec timer START")
		SITTING:
			# call function to go to location of chair and sit (existing function)
			if idle_20.is_stopped():
				idle_20.start()
		DRINK_WAITING:
		# (coffee) displays desired drink and waits at most 45 secs
		# need a function for a new timer, and to trigger DONE state if finished 
			order(order_coffee)
			if wait_45.is_stopped():
				wait_45.start()
				print("drink waiting, 45 sec timer START")
		DRINK_CONSUMING:
		# 10-20 secs drinking
			hide_order(order_coffee)
			hold_item(coffee)
			bill = 4
			if idle_20.is_stopped():
				idle_20.start()
				print("drink consuming, 0 sec timer START")
		FOOD_WAITING:
		# drink finished 
		# displays desired food and waits 1min at most
		# need a function for a new timer, and to trigger DONE state if finished 
		# also to take away points for unpaid coffee
			hide_item(coffee)
			choose_food()
			print("order: " + str(current_food))
			order(current_food)
			if wait_60.is_stopped():
				wait_60.start()
				print("food waiting, 45 sec timer START")
		FOOD_CONSUMING:
		# 30secs eating
			bill = 9
			hide_order(current_food)
			hold_item(current_food)
			if idle_30.is_stopped():
				idle_30.start()
				print("food consuming, 30 sec timer START")
		BILL_WAITING:
		# food disappears and customer will wait 45 secs at most
			hide_item(current_food)
			order(order_bill)
			hold_item(cash)
			if wait_45.is_stopped():
				wait_45.start()
				print("bill waiting, 45 sec timer START")
		DONE:
		# as soon as bill is brought, customer pays and walks out of cafe
		# player gets points for the bill and tips
			if current_food != null:
				hide_order(current_food)
			hide_order(order_coffee)
			hide_order(order_bill)
			hide_item(cash)
			if bill_paid:
				bill += rng.randi_range(0, 10)
			else:
				if !received_wrong_order:
					bill = -bill
#			if !bill_paid:
#				bill = -bdill
				
			print("customer's bill: " + str(bill))
				
			nav.set_target_position(exit.position)
			var move_direction = position.direction_to(nav.get_next_path_position())
			velocity = move_direction * SPEED
			nav.set_velocity_forced(velocity)
			move_and_slide()

	if player_near:
		if player.has_customer() == null: 
			if current_state == SEAT_WAITING:
				customer_text.visible = true
				customer_text.text = "Interact"
				if Input.is_action_just_pressed("action"):
					follow_player(player)
					wait_45.stop()
					current_state = BEING_SEATED
					print("45 sec timer STOPPED")
					player.seat_customer(self)
	else:
		customer_text.visible = false
	
	# test_text.text = state_list[current_state]
	
	if self.velocity == Vector2(0,0) or sitting or current_state == SEAT_WAITING:
		if sitting:
			animate.play("sit")
		else:
			animate.play("idle")
	else: 
		animate.play("walk")
		if velocity.x < 0:
			animate.flip_h = true
		if velocity.x > 0:
			animate.flip_h = false
		
	if current_state == BEING_SEATED and !getting_seated and !sitting and chair == null:
		# print("nav.set_target_position(player.position)")
		nav.set_target_position(player.position)
		if nav.distance_to_target() > 45:
			var move_direction = position.direction_to(nav.get_next_path_position())
			velocity = move_direction * SPEED
			nav.set_velocity_forced(velocity)
			move_and_slide()
		
	if getting_seated and !sitting and chair != null:
		# print("nav.set_target_position(chair.position)")
		nav.set_target_position(chair.position)
		var move_direction = position.direction_to(nav.get_next_path_position())
		velocity = move_direction * SPEED
		nav.set_velocity_forced(velocity)
		move_and_slide()

func _on_area_2d_area_entered(area):
	if current_state == BEING_SEATED and area == chair:
		if area.has_method("seat"):
			if area.return_empty():
				if current_state == BEING_SEATED:
					position.x = area.position.x
					position.y = area.position.y
					sitting = true
					getting_seated = false
					# print("Sitting = " + str(sitting))
					player.clear_customer()
					wait_45.stop()
					current_state = SITTING

func _on_area_2d_area_exited(area):
	if current_state == DONE:
		if area.has_method("seat"):
			sitting = false
			# print("Sitting = " + str(sitting))

func _on_detect_area_body_entered(body):
	if body.has_method("owl_player"):
		player = body
		player_near = true
		
func _on_detect_area_body_exited(body):
	if body.has_method("owl_player"):
		player_near = false

func _on_four_five_wait_timeout(): # will change names later LOL
	wait_45.stop()
	current_state = DONE
	print("30 sec timer STOPPED")

func _on_sixty_wait_timeout():
	wait_60.stop()
	current_state = DONE
	print("45 sec timer STOPPED")

func _on_twenty_idle_timeout(): 
	if current_state == DRINK_CONSUMING:
		idle_20.stop()
		current_state = FOOD_WAITING
		print("8 sec timer STOPPED")
	if current_state == SITTING:
		idle_20.stop()
		current_state = DRINK_WAITING

func _on_thirty_idle_timeout():
	if current_state == FOOD_CONSUMING:
		idle_30.stop()
		current_state = BILL_WAITING
		print("15 sec timer STOPPED")
