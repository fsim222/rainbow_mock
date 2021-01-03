extends TextureRect

export var speed := 300.0

var walking_path := []

onready var wait_frame := 5.0
onready var state := 'wait'

func setup(start_position : Vector2):
	self.rect_position = start_position

func _process(delta):
	match state:
		'wait':
			wait_frame -= delta
			if (wait_frame <= 0):
				_begin_move()
		'walking':
			_move(delta * speed)

func _begin_move():
	walking_path = $"../../MainRoom".get_random_path(self)
	state = 'walking'

func _move(distance):
	var last_point := self.rect_position
	while walking_path.size():
		var next_point = walking_path[0]
		var distance_between_points = last_point.distance_to(next_point)
		if distance <= distance_between_points:
			self.rect_position = last_point.linear_interpolate(next_point, distance / distance_between_points)
			self.flip_h = (last_point.x - next_point.x) <= 0
			return
		# 次のpointに到達していたら
		distance -= distance_between_points
		last_point = next_point
		walking_path.remove(0)
	# ゴールにたどり着いたら
	_end_move(last_point)

func _end_move(goal_point : Vector2):
	self.rect_position = goal_point
	state = 'wait'
	wait_frame = rand_range(2,5)
