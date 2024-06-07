extends Node2D

# OBJECTIVE: Survive the shift and make monay

# need to be able to go back to start menu mid game

# START SCREEN IS A ZOOMIN OF THE OWL SLEEPING AT THE COUNTER!!!!!!
# WITH PLAY AND "HOW TO PLAY" YAYYYYY SO CUTE AND DON'T HAVE TO DRAW!!
# CLICK PLAY AND IT FADES/TRANSITIONS TO BLACK THEN TO SCENE


# need game loop (timer or condition)
# need to make score system first....
# it would be more fun to start with an amount of money 
# and if you loose all of it then the game ends but if ur able
# to keep going, then the shift just ends
# yeah bc then if ur bad u will lose and if ur good u can get highscore
# but not forever so yeah

# let's make a menu so i can decide what a good starting amount is..
# coffee = $4
# pastries = $5
# if customers are coming every ~35 seconds
# w 23 seats thats ~13 minutes to fill the cafe
# i dont wanna get to that point so lets do 5 or 7 mins
# also 15 x 4.5 = 67.5 lets start w $60
# if a customer orders coffee for $4 and walks out bc u took too long on food
# thats -$4
# if customer orders coffee and food and u take too long to bring bill
# thats -$9 
# if you reach 0 or less, game over
# if 5mins are up then u win
# and the money u made on top of the $50 is ur score!


# IF NO CASH IN HAND THEN CASH REGISTER GIVES CHECK 
# (AND IF THERE ARE CUSTOMERS IN THE SCENE)




@onready var rng = RandomNumberGenerator.new()

@onready var player_boundary = $Node2D/Areas/PlayerBoundary
@onready var player_bound_collision = $Node2D/Areas/PlayerBoundary/StaticBody2D/CollisionShape2D2

@onready var trash = $Node2D/Areas/Trash
@onready var discard_prompt = $Node2D/Areas/Trash/DiscardPrompt

@onready var fir_coffee_mac = $Node2D/Areas/FirCoffeeMac
@onready var coff_1_interface = $Node2D/Areas/FirCoffeeMac/Coff1Interface
@onready var coff_2_interface = $Node2D/Areas/SecCoffeeMac/Coff2Interface

@onready var sec_coffee_mac = $Node2D/Areas/SecCoffeeMac

@onready var oven = $Node2D/Areas/Oven

@onready var order_pastry = $Node2D/Areas/Oven/OvenInterface/PastryBox/OrderPastry
@onready var order_square = $Node2D/Areas/Oven/OvenInterface/SquareBox/OrderSquare
@onready var order_croissant = $Node2D/Areas/Oven/OvenInterface/CroissantBox/OrderCroissant
@onready var order_pie = $Node2D/Areas/Oven/OvenInterface/PieBox/OrderPie
@onready var order_tiramisu = $Node2D/Areas/Oven/OvenInterface/TiramisuBox/OrderTiramisu

@onready var done_button = $Node2D/Areas/Oven/DoneBox/DoneButton
@onready var done_box = $Node2D/Areas/Oven/DoneBox
@onready var done_tiramisu = $Node2D/Areas/Oven/DoneBox/DoneTiramisu
@onready var done_square = $Node2D/Areas/Oven/DoneBox/DoneSquare
@onready var done_croissant = $Node2D/Areas/Oven/DoneBox/DoneCroissant
@onready var done_pie = $Node2D/Areas/Oven/DoneBox/DonePie
@onready var done_pastry = $Node2D/Areas/Oven/DoneBox/DonePastry

@onready var cash_register = $Node2D/Areas/CashRegister
@onready var cash_prompt = $Node2D/Areas/CashRegister/CashPrompt

@onready var spawn_area = $Node2D/CustomerSpawn
@onready var spawn_timer = $Node2D/CustomerSpawn/SpawnTimer

@onready var escape_text = $EscapeText
@onready var esc_timer = $EscTimer

@onready var score_label = $Score

@onready var game_timer = $GameTimer

@onready var game_over_text = $GameOverText
@onready var start_menu_timer = $StartMenuCountdown/StartMenuTimer
@onready var start_menu_countdown = $StartMenuCountdown

@onready var oven_timer = $Node2D/Areas/Oven/OvenTimer
@onready var first_coffee_timer = $Node2D/Areas/FirCoffeeMac/FirstCoffeeTimer
@onready var second_coffee_timer = $Node2D/Areas/SecCoffeeMac/SecondCoffeeTimer

var escaping = false
var score = 45
var game_over = false
var game_won = false
var game_updated = false
var player_near_trash = false
var player_near_oven = false
var player_near_cof1 = false
var player_near_cof2 = false
var oven_baking = false
var coffee_going_1 = false
var coffee_going_2 = false
var coffee1_made = false
var coffee2_made = false
var food_baking = null

func empty_oven():
	if food_baking == order_pastry:
		food_baking = "pastry"
	elif food_baking == order_square:
		food_baking = "square"
	elif food_baking == order_pie:
		food_baking = "pie"
	elif food_baking == order_croissant:
		food_baking = "croissant"
	elif food_baking == order_tiramisu:
		food_baking = "tiramisu"
	$Node2D/Player.take_item(food_baking)
	print("Giving player " + str(food_baking))
	food_baking = null
	print("Food baking = " + str(food_baking))

func spawn():
	var cust_scene = preload("res://Scenes/Characters/owl_customer.tscn")
	var customer = cust_scene.instantiate()
	add_child(customer)
	customer.position = spawn_area.position
	# print(str(customer) + " @ " + str(customer.position))
	customer.entrance = $Node2D/Areas/Entrance
	customer.player = $Node2D/Player
	customer.exit = $Node2D/Areas/Exit
	spawn_timer.start()
	
func update_score(customer_score):
	score = score + customer_score
	print("Score: " + str(score))

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.set_wait_time(5.0)
	spawn_timer.start()
	score_label.text = "Money: $" + str(score)
	game_timer.start()
	print("Score: " + str(score))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player_near_trash and $Node2D/Player.holding_item() != null:
		discard_prompt.visible = true
		if Input.is_action_just_pressed("action"):
			$Node2D/Player.clear_item()
	else:
		discard_prompt.visible = false
		
		
	if coffee1_made:
		coff_1_interface.visible = true
	else:
		if player_near_cof1:
			if !coffee_going_1:
				coff_1_interface.visible = true
			else:
				coff_1_interface.visible = false
		else:
			coff_1_interface.visible = false
			
	if coffee2_made:
		coff_2_interface.visible = true
	else:
		if player_near_cof2:
			if !coffee_going_2:
				coff_2_interface.visible = true
			else:
				coff_2_interface.visible = false
		else:
			coff_2_interface.visible = false
		
	if player_near_oven:
		if !oven_baking:
			if food_baking == null:
				$Node2D/Areas/Oven/OvenInterface.visible = true
				# showing the menu if nothing is happening
			else:
				$Node2D/Areas/Oven/OvenInterface.visible = false
		else:
			$Node2D/Areas/Oven/OvenInterface.visible = false
	else:
		$Node2D/Areas/Oven/OvenInterface.visible = false
	
	
	score_label.text = "Money: $" + str(score)
	
	if Input.is_action_just_pressed("esc"):
		if escaping:
			get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")
		else:
			handle_escape()
			
	if score <= 0:
		game_over = true
		game_timer.stop()
		
	if game_over and !game_updated: 
	# stop processes and show something different (plus save score if won)
		game_over_text.visible = true
		if game_won: 
			# print("You survived the shift!")
			game_over_text.text = "You survived the shift and made a profit of $" + str(score-45) + "!"
			start_menu_timer.start()
		else:
			# print("You lost...")
			game_over_text.text = "You lost..."
			start_menu_timer.start()
		game_updated = true
	
	if game_over and !start_menu_timer.is_stopped():
		start_menu_countdown.visible = true
		start_menu_countdown.text = "Back to the main menu in " + str(int(start_menu_timer.get_time_left()))
		
func _on_exit_body_entered(body):
	if body.has_method("owl_customer"):
		var cust_bill = body.return_bill()
		update_score(cust_bill)
		body.queue_free()

func _on_exit_body_exited(body):
	pass # Replace with function body.

func _on_spawn_timer_timeout():
	spawn_timer.set_wait_time(rng.randf_range(20.0, 50.0))
	spawn()
	
func handle_escape():
	escaping = true
	escape_text.visible = true
	esc_timer.start()

func _on_esc_timer_timeout():
	escaping = false
	escape_text.visible = false

func _on_player_boundary_body_entered(body):
	if body.has_method("owl_player"):
		player_bound_collision.set_deferred("disabled", false)
	else:
		player_bound_collision.set_deferred("disabled", true)

func _on_player_boundary_body_exited(body):
	if body.has_method("owl_player"):
		player_bound_collision.set_deferred("disabled", true)
	else:
		player_bound_collision.set_deferred("disabled", true)

func _on_game_timer_timeout():
	game_over = true
	game_won = true

func _on_start_menu_timer_timeout():
	start_menu_countdown.visible = false
	get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")

func _on_trash_body_entered(body):
	if body.has_method("owl_player"):
		if body.holding_item() != null:
			player_near_trash = true

func _on_trash_body_exited(body):
	if body.has_method("owl_player"):
		player_near_trash = false

func _on_oven_body_entered(body):
	if body.has_method("owl_player"):
			player_near_oven = true

func _on_oven_body_exited(body):
	if body.has_method("owl_player"):
			player_near_oven = false

func _on_pastry_button_pressed():
	food_baking = order_pastry
	oven_baking = true
	oven_timer.start()
	$Node2D/Areas/Oven/OvenInterface.visible = false
	print("Oven started, baking " + str(food_baking))

func _on_square_button_pressed():
	food_baking = order_square
	oven_baking = true
	oven_timer.start()
	$Node2D/Areas/Oven/OvenInterface.visible = false
	print("Oven started, baking " + str(food_baking))

func _on_croissant_button_pressed():
	food_baking = order_croissant
	oven_baking = true
	oven_timer.start()
	$Node2D/Areas/Oven/OvenInterface.visible = false
	print("Oven started, baking " + str(food_baking))

func _on_pie_button_pressed():
	food_baking = order_pie
	oven_baking = true
	oven_timer.start()
	$Node2D/Areas/Oven/OvenInterface.visible = false
	print("Oven started, baking " + str(food_baking))

func _on_tiramisu_button_pressed():
	food_baking = order_tiramisu
	oven_baking = true
	oven_timer.start()
	$Node2D/Areas/Oven/OvenInterface.visible = false
	print("Oven started, baking " + str(food_baking))

func _on_oven_timer_timeout():
	print("Finished baking " + str(food_baking))
	# $Node2D/Areas/Oven/OvenInterface.visible = false
	done_box.visible = true
	if food_baking == order_pastry:
		done_pastry.visible = true
	if food_baking == order_square:
		done_square.visible = true
	if food_baking == order_pie:
		done_pie.visible = true
	if food_baking == order_croissant:
		done_croissant.visible = true
	if food_baking == order_tiramisu:
		done_tiramisu.visible = true
	oven_baking = false
	oven_timer.stop()

func _on_done_button_pressed():
	empty_oven()
	done_box.visible = false


func _on_fir_coffee_mac_body_entered(body):
	if body.has_method("owl_player"):
		player_near_cof1 = true


func _on_fir_coffee_mac_body_exited(body):
	if body.has_method("owl_player"):
		player_near_cof1 = false


func _on_sec_coffee_mac_body_entered(body):
	if body.has_method("owl_player"):
		player_near_cof2 = true


func _on_sec_coffee_mac_body_exited(body):
	if body.has_method("owl_player"):
		player_near_cof2 = false


func _on_first_coffee_timer_timeout():
	coffee_going_1 = false
	coffee1_made = true
	first_coffee_timer.stop()


func _on_second_coffee_timer_timeout():
	coffee_going_2 = false
	coffee2_made = true
	second_coffee_timer.stop()


func _on_coffee_1_button_pressed():
	if player_near_cof1:
		if coffee1_made:
			if $Node2D/Player.holding_item() == null:
				$Node2D/Player.take_item("coffee")
				coffee1_made = false
				coff_1_interface.visible = false
		else:
			coffee_going_1 = true
			first_coffee_timer.start()

func _on_coffee_2_button_pressed():
	if player_near_cof2:
		if coffee2_made:
			if $Node2D/Player.holding_item() == null:
				$Node2D/Player.take_item("coffee")
				coffee2_made = false
				coff_2_interface.visible = false
		else:
			coffee_going_2 = true
			second_coffee_timer.start()
