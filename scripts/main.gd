extends Node2D

var point_scene = preload("res://scenes/point.tscn")
var perceptron: Perceptron
@onready var screen_size = get_viewport().get_visible_rect().size

const POINTS_NUM = 200
const BIAS = 1.0
const LEARNING_RATE = 0.001

func _ready():
	randomize()
	perceptron = Perceptron.new(3, LEARNING_RATE)
	
	for i in range(POINTS_NUM):
		create_point()
			
func _process(delta: float):
	var points = $points.get_children()
	var point = points[randi() % points.size()]
	var coordinates = coordinates_to_cartesian(point.position)
	point.error = perceptron.train([coordinates.x, coordinates.y, BIAS], point.value)
	
	queue_redraw()
	
func _draw():
	var line_start = cartesian_to_coordinates(Vector2(-1, line(-1)))	
	var line_end = cartesian_to_coordinates(Vector2(1, line(1)))
	draw_line(line_start, line_end, Color(0, 0, 255), 5)
	
	var guess_start = cartesian_to_coordinates(Vector2(-1, guess_y(-1)))
	var guess_end = cartesian_to_coordinates(Vector2(1, guess_y(1)))
	draw_line(guess_start, guess_end, Color(255, 0, 0), 5)
	
func coordinates_to_cartesian(coordinates: Vector2):
	var cartesian = Vector2()
	
	cartesian.x = remap(coordinates.x, 0, screen_size.x, -1, 1)
	cartesian.y = remap(coordinates.y, 0, screen_size.y, -1, 1)
	
	return cartesian

func cartesian_to_coordinates(cartesian: Vector2) -> Vector2:
	var coordinates = Vector2()
	
	coordinates.x = remap(cartesian.x, -1, 1, 0, screen_size.x)
	coordinates.y = remap(cartesian.y, -1, 1, 0, screen_size.y)
	
	return coordinates

func guess_y(x: float) -> float:
	return -(perceptron.weights[2] / perceptron.weights[1]) - (perceptron.weights[0] / perceptron.weights[1]) * x

func line(x: float):
	return -x + 0.3
	
func create_point(): 
	var point = point_scene.instantiate()
	
	point.position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
	)
	
	var coordinates = coordinates_to_cartesian(point.position)
	point.value = 1 if coordinates.y >= line(coordinates.x) else -1
	
	$points.add_child(point)
