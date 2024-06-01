extends CharacterBody2D

#todays game todo list:
#• customers AI, choosing food, showing it, waiting, changing states, 
# receiving food (input) from player (need to create logic for when 2 customers 
# areas are both in player’s areas, to give the right food to the right person 
# and not punish the player)
#• customer pathfinding during states (following player while being seated, leaving when done)
#• all the sprites showing: customer requesting coffee, sprite indicating
# the customer is waiting for a range of time, player carrying food and the customer taking food
#• customers coming in at a proper rate (not too little not too many - according to number of seats)
#• all the timers
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





# rn:
# customer state changed to being seated 
# -> customer follows player around
# if timer runs out before being seated, customer state changesd to done
# and customer walks out of the restaurant and despawns
# -> player interacts with seat (empty otherwise impossible)
# -> specific customer following player gets sent location of seat
# -> customer moves towards seat, sits down, once seated state changes to drink waiting

enum {
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

@onready var animate = $AnimatedSprite2D
@onready var wait_45 = $FourFiveWait
@onready var wait_60 = $SixtyWait
@onready var idle_20 = $TwentyIdle
@onready var idle_30 = $ThirtyIdle
@onready var test_text = $StateText
@onready var customer_text = $CustomerText
@onready var player = $"../Player"

const SPEED = 200

var player_near = false
var sitting = false
var current_state = SEAT_WAITING
var coffee = "coffee"
var food_list = ["croissant", "pie", "pastry", "square"]
var state_list = ["SEAT_WAITING", "BEING_SEATED", "SITTING", "DRINK_WAITING", "DRINK_CONSUMING", "FOOD_WAITING", "FOOD_CONSUMING", "BILL_WAITING", "DONE"]

func owl_customer():
# return state? so that player can check if in initial waiting state
# and if true, then seat customer
# and in general other states too
	pass

func return_state():
	return current_state
	
func follow_player(leader):
	# method to follow player
	current_state = BEING_SEATED
	
func get_seated():
	sitting = true
	wait_45.stop()
	current_state = DRINK_WAITING
	
func choose_food(): # need to make a function to show the right food sprite
	food_list.shuffle()
	return food_list.front()
	
func order(food_string): 
# function to order any food, all the processes to show the food sprite, and the timer
# need to make separate the food/coffee sprites in the sheet
	pass

func move(delta):
# temporary until i think about movement
# position += dir * SPEED * delta
	pass
	
func _ready():
	pass

func _physics_process(delta): # add animations for when customer is moving etc.
	match current_state:
	# straight to done if customer receives wrong order or player takes too long
		SEAT_WAITING:
		# waiting at most for ~45 secs
		# customer has to be tagged to start following player
			if wait_45.is_stopped():
				wait_45.start()
				print("seat waiting, 45 sec timer START")
			# pass
		BEING_SEATED:
		# following player for at most 45 secs
		# follow player until player interacts with a seat node, 
		# then customer sits at the seat (if empty)
		# once seated, thinking b/n 10-30 secs
			if wait_45.is_stopped():
				wait_45.start()
				print("being seated, 45 sec timer START")
#			pass
		SITTING:
			# call function to go to location of chair and sit (existing function)
			pass
		DRINK_WAITING:
		# (coffee) displays desired drink and waits at most 45 secs
		# need a function for a new timer, and to trigger DONE state if finished 
			order(coffee)
			if wait_45.is_stopped():
				wait_45.start()
				print("drink waiting, 45 sec timer START")
		DRINK_CONSUMING:
		# 10-20 secs drinking
			if idle_20.is_stopped():
				idle_20.start()
				print("drink consuming, 0 sec timer START")
#			pass
		FOOD_WAITING:
		# drink finished 
		# displays desired food and waits 1min at most
		# need a function for a new timer, and to trigger DONE state if finished 
		# also to take away points for unpaid coffee
			order(choose_food())
			if wait_60.is_stopped():
				wait_60.start()
				print("6food waiting, 0 sec timer START")
		FOOD_CONSUMING:
		# 30secs eating
			# wait_60.is_stopped()
			if idle_30.is_stopped():
				idle_30.start()
				print("food consuming, 30 sec timer START")
#			pass
		BILL_WAITING:
		# food disappears and customer will wait 45 secs at most
			if wait_45.is_stopped():
				wait_45.start()
				print("bill waiting, 45 sec timer START")
#			pass
		DONE:
		# as soon as bill is brought, customer pays and walks out of cafe
		# player gets points for the bill and tips
			sitting = false

	if player_near and current_state != DONE:
		if current_state == SEAT_WAITING:
			customer_text.visible = true
			customer_text.text = "Interact"
			if Input.is_action_just_pressed("action"):
				follow_player(player)
				wait_45.stop()
				current_state = BEING_SEATED
				print("45 sec timer STOPPED")
	else:
		customer_text.visible = false
	
	test_text.text = state_list[current_state]
	
	if sitting:
		animate.play("sit")
	else:
		animate.play("idle")
	
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
			if current_state == BEING_SEATED:
				sitting = true
				print("Sitting = " + str(sitting))
				self.position.x = area.position.x
				self.position.y = area.position.y
				wait_45.stop()
				current_state = DRINK_WAITING

func _on_area_2d_area_exited(area):
	if area.has_method("seat"):
		sitting = false
		print("Sitting = " + str(sitting))

func _on_detect_area_body_entered(body):
	if body.has_method("owl_player"):
		player = body
		player_near = true
		
func _on_detect_area_body_exited(body):
	if body.has_method("owl_player"):
		player_near = false

func _on_four_five_wait_timeout():
	wait_45.stop()
	current_state = DONE
	print("45 sec timer STOPPED")

func _on_sixty_wait_timeout():
	wait_60.stop()
	current_state = DONE
	print("60 sec timer STOPPED")

func _on_twenty_idle_timeout():
	if current_state == DRINK_CONSUMING:
		idle_20.stop()
		current_state = FOOD_WAITING
	print("20 sec timer STOPPED")

func _on_thirty_idle_timeout():
	if current_state == FOOD_CONSUMING:
		idle_30.stop()
		current_state = BILL_WAITING
	print("30 sec timer STOPPED")
