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





@onready var rng = RandomNumberGenerator.new()

@onready var player_boundary = $Node2D/Areas/PlayerBoundary
@onready var player_bound_collision = $Node2D/Areas/PlayerBoundary/StaticBody2D/CollisionShape2D2

@onready var trash = $Node2D/Areas/Trash

@onready var fir_coffee_mac = $Node2D/Areas/FirCoffeeMac
@onready var coffee_box = $Node2D/Areas/FirCoffeeMac/CoffeeBox
@onready var order_coffee = $Node2D/Areas/FirCoffeeMac/CoffeeBox/OrderCoffee

@onready var sec_coffee_mac = $Node2D/Areas/SecCoffeeMac
@onready var coffee_box_2 = $Node2D/Areas/SecCoffeeMac/CoffeeBox2
@onready var order_coffee_2 = $Node2D/Areas/SecCoffeeMac/CoffeeBox2/OrderCoffee2

@onready var oven = $Node2D/Areas/Oven
@onready var pastry_box = $Node2D/Areas/Oven/PastryBox
@onready var order_pastry = $Node2D/Areas/Oven/PastryBox/OrderPastry
@onready var square_box = $Node2D/Areas/Oven/SquareBox
@onready var order_square = $Node2D/Areas/Oven/SquareBox/OrderSquare
@onready var croissant_box = $Node2D/Areas/Oven/CroissantBox
@onready var order_croissant = $Node2D/Areas/Oven/CroissantBox/OrderCroissant
@onready var pie_box = $Node2D/Areas/Oven/PieBox
@onready var order_pie = $Node2D/Areas/Oven/PieBox/OrderPie
@onready var tiramisu_box = $Node2D/Areas/Oven/TiramisuBox
@onready var order_tiramisu = $Node2D/Areas/Oven/TiramisuBox/OrderTiramisu
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

var escaping = false


func spawn():
	var cust_scene = preload("res://Scenes/Characters/owl_customer.tscn")
	var customer = cust_scene.instantiate()
	add_child(customer)
	customer.position = spawn_area.position
	print(str(customer) + "@ " + str(customer.position))
	customer.entrance = $Node2D/Areas/Entrance
	customer.player = $Node2D/Player
	customer.exit = $Node2D/Areas/Exit
	spawn_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.set_wait_time(5.0)
	spawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if escaping:
			get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")
		else:
			handle_escape()
		

func _on_exit_body_entered(body):
	if body.has_method("owl_customer"):
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
