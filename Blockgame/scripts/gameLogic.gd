extends Node2D

@export var instanceScene: Resource = null
@export var speed: float = 10

var playing = false
var time = 0.0
var instance = null
var instances = []

var input = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if (Input.is_action_just_pressed("placeInstance")):
		_releaseInstance()
	
	if (instance == null and time > 1.0):
		_placeInstance()
		
	input = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"))
	
	_movement(delta)

func _placeInstance():
	if(playing == false or instance != null):
		return
	instance = instanceScene.instantiate()
	add_child(instance)
	instance.position.y = - 450
	
func _movement(delta):
	if(instance == null):
		return
	#var posX = instance.position.x
	#var targetX = posX + input
	#spdX = lerp(spdX,(targetX - posX) * 0.5, delta * 25)
	#print (spdX)
	instance.position.x += input * delta * speed

func _releaseInstance():
	if(instance == null):
		return
	#turn off kinematic state
	instance.freeze = false 
	#enable the collision detection
	instance.get_child(0).disabled = false 
	#add instance to instances array
	instances.append(instance) 
	#remove instance from active
	instance = null	
	time = 0.0
