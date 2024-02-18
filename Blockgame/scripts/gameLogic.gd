extends Node2D

@export var instanceScene: Resource = null
@export var rotationSpeed: float = 10
@export var movementSpeed: float = 10

var playing = false
var time = 0.0
var instance = null
var instances = []

var input = 0
var positionX: float = 0
var speedX: float = 0
var speedRot : float = 0
var rot: float = 0

var floorLeft = null
var floorRight = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_initLevel()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_inputHandler()
	_gameLoop(delta)

func _initLevel():
	return

func _gameLoop(delta):
	if playing == true:
		time += delta
	
	if (instance == null and time > 1.0):
		_placeInstance()
	
	if(instance == null or playing == false):
		return
	_movement(delta)
	_rotation(delta)

func _inputHandler():
	if (Input.is_action_just_pressed("debugStartGame")):
		_startGame()
	if (Input.is_action_just_pressed("debugEndGame")):
		_endGame()
	#move instance left and right
	input = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"))
	#place instance when space key is predded
	if (Input.is_action_just_pressed("placeInstance")):
		_releaseInstance()	
	#rotate instance when alt key is pressed
	if (Input.is_action_just_pressed("rotateLeft")):
		rot += PI / 4
	if (Input.is_action_just_pressed("rotateRight")):
		rot -= PI / 4
	
func _placeInstance():
	if(playing == false or instance != null):
		return
	instance = instanceScene.instantiate()
	add_child(instance)
	instance.position.y = - 450
	
func _movement(delta):
	positionX += input * delta * movementSpeed
	var currentPositionX = instance.position.x
	speedX = lerp(speedX, (positionX - currentPositionX) * 0.05, delta * 2)
	instance.position.x += speedX

func _rotation(delta):
	var currentRotation = instance.rotation
	speedRot = lerp(speedRot, (rot - currentRotation) * 0.1, delta *10)
	instance.rotation += speedRot
	
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
	positionX = 0
	speedX = 0
	speedRot = 0
	rot = 0

func _startGame():
	playing = true
	time = 0.0
	for placedInstance in instances:
		remove_child(placedInstance)
	instances = []
	print (instances.size())
	remove_child(instance)

func _endGame():
	if playing == true:
		playing = false
		print(instances.size())

func _on_area_2d_body_entered(body):
	print(body)
	pass # Replace with function body.

