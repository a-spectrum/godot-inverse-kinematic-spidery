extends KinematicBody

#	----------------------
#	For character movement
#	----------------------
export var speed := 2.0
export var jump_strength := 30.0
export var gravity := 50

onready var pointFL: Spatial = get_node("pointFL")
onready var pointFR: Spatial = get_node("pointFR")

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: Spatial = $Armature

#	------------------------------
#	For inverse kinematic movement
#	------------------------------
onready var positionFL := $positions/positionLegFL
onready var positionFR := $positions/positionLegFR
onready var positionBL := $positions/positionLegBL
onready var positionBR := $positions/positionLegBR

onready var rayCastFL := $Armature/Skeleton/RaycastsLegs/RayCastLegFL
onready var rayCastFR := $Armature/Skeleton/RaycastsLegs/RayCastLegFR
onready var rayCastBL := $Armature/Skeleton/RaycastsLegs/RayCastLegBL
onready var rayCastBR := $Armature/Skeleton/RaycastsLegs/RayCastLegBR

onready var legFL_IK := $Armature/Skeleton/legFrontLeft
onready var legFR_IK := $Armature/Skeleton/legFrontRight
onready var legBL_IK := $Armature/Skeleton/legBackLeft
onready var legBR_IK := $Armature/Skeleton/legBackRight

func _ready():
	positionFL._register_raycast(rayCastFL, "FL")
	positionFR._register_raycast(rayCastFR, "FR")
	positionBL._register_raycast(rayCastBL, "BL")
	positionBR._register_raycast(rayCastBR, "BR")
	
	legFL_IK.start()	
	legFR_IK.start()	
	legBL_IK.start()	
	legBR_IK.start()	

func _physics_process(delta: float) -> void:
	move_character(delta)
	
	if rayCastFR.is_colliding():
		$Armature/Skeleton/RaycastsLegs/RayCastLegFR/MeshInstance.global_transform.origin = rayCastFR.get_collision_point()

func _process(_delta: float) -> void:
	_spring_arm.translation = translation	
	
func move_character(delta: float) -> void:
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_direction.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()

	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("ui_accept")
	
	# Set jumping / gravity
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.x, _velocity.z)
		_model.rotation.y = look_direction.angle()
