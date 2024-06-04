extends Node2D

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
	customer.player = $Node2D/Player
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
	spawn_timer.set_wait_time(rng.randf_range(10.0, 40.0))
	spawn()
	
