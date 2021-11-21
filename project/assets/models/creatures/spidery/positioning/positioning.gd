extends Position3D

onready var follow_raycast : RayCast = null

var position_on_curve := 0.0
var position_start := Vector3.ZERO
onready var position_current := global_transform.origin
var position_raycast := Vector3.ZERO
var position_end := Vector3.ZERO
var name_raycast := "no name given"

var move_position := false

func _ready():
	set_as_toplevel(true)
	position_current.y = 0

func _physics_process(_delta: float) -> void:
	
	#print(name_raycast +" - "+ str(global_transform.origin.distance_to(follow_raycast.global_transform.origin)))
	_update_raycast_position()
	if _check_distance_larger_than(3) && !move_position:
		_move_position(position_current, position_raycast)
		
	position_on_curve += 0.03
	
	if position_on_curve >= 1:
		move_position = false
		position_on_curve = 0.0
		position_current = position_end
	
	if move_position:
		transform.origin = _calculate_bezier_curve(position_start, position_end)
	
func _move_position(start: Vector3, end: Vector3) -> void:
	position_start = start
	position_end = end
	move_position = true

func _register_raycast(ray: RayCast, name_rc: String) -> void:
	follow_raycast = ray
	name_raycast = name_rc

func _calculate_bezier_curve(start: Vector3, end: Vector3):	
	var generate_third_point := Vector3.ZERO;
	generate_third_point.y += start.y + 2.6
	generate_third_point.x += (end.x - start.x) / 3
	generate_third_point.z += (end.x - start.x) / 3
	
	var calc_point_0 = start.linear_interpolate(generate_third_point, position_on_curve)
	var calc_point_1 = generate_third_point.linear_interpolate(end, position_on_curve)
	var current_position = calc_point_0.linear_interpolate(calc_point_1, position_on_curve)
	return current_position

func _check_distance_larger_than(distance: float) -> bool:
	return position_current.distance_to(position_raycast) > distance

func _update_raycast_position() -> void:
	if follow_raycast.is_colliding():
		position_raycast = follow_raycast.get_collision_point()
