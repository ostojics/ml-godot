extends Node2D

var value: int = 1
var error: int = 3

func _ready():
	pass

func _process(delta):
	queue_redraw()

func _draw():
	if error == 3:
		draw_circle(Vector2(), 8, Color.DARK_GOLDENROD)
	elif error == 0:
		draw_circle(Vector2(), 8, Color.AQUAMARINE)
	else:
		draw_circle(Vector2(), 8, Color.BROWN)

	if value == 1:
		draw_circle(Vector2(), 6, Color.CORNSILK)
	else: 
		draw_circle(Vector2(), 6, Color.BLACK)
		
