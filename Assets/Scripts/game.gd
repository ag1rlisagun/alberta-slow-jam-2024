extends Node2D

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






@onready var spawn_area = $Node2D/CustomerSpawn
@onready var spawn_timer = $Node2D/CustomerSpawn/SpawnTimer
@onready var rng = RandomNumberGenerator.new()

func spawn():
	var cust_scene = preload("res://Scenes/Characters/owl_customer.tscn")
	var customer = cust_scene.instantiate()
	add_child(customer)
	customer.position = spawn_area.position
	print(str(customer) + "@ " + str(customer.position))
	customer.entrance = $Node2D/Areas/Entrance
	customer.player = $Player
	customer.exit = $Node2D/Areas/Exit
	spawn_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.set_wait_time(5.0)
	spawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_body_entered(body):
	if body.has_method("owl_customer"):
		body.queue_free()

func _on_exit_body_exited(body):
	pass # Replace with function body.

func _on_spawn_timer_timeout():
	spawn_timer.set_wait_time(rng.randf_range(20.0, 50.0))
	spawn()
	
