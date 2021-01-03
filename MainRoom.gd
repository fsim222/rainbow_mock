extends Node

export var goal_points = []

func _ready():
	_yorishiro_setup()

func _yorishiro_setup():
	randomize() # Yorishiroの待機時間設定用
	
	# 複数形なのか？？？？
	var yorishiros = get_tree().get_nodes_in_group("yorishiro")
	for yorishiro in yorishiros:
		yorishiro.setup(goal_points[0])

func get_random_path(yorishiro : Control):
	var start_point = yorishiro.rect_position
	var goal_point = goal_points[randi() % goal_points.size()]
	
	# positionの基準位置は左上だけど、経路探索のpositionは足元なので変換が必要
	var convert_vector = Vector2(yorishiro.rect_size.x * 0.5, yorishiro.rect_size.y)
	var path = $Navigation2D.get_simple_path(start_point + convert_vector, goal_point + convert_vector)
	
	# 左上座標に戻す
	var converted_path = []
	for i in range(path.size()):
		converted_path.append(path[i] - convert_vector)
	
	return converted_path
