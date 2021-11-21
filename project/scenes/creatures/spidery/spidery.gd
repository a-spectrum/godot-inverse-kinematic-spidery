extends KinematicBody

onready var positionFL := $positions/positionLegFL
onready var positionFR := $positions/positionLegFR
onready var positionBL := $positions/positionLegBL
onready var positionBR := $positions/positionLegBR

onready var rayCastFL := $RaycastsLegs/RayCastLegFL
onready var rayCastFR := $RaycastsLegs/RayCastLegFR
onready var rayCastBL := $RaycastsLegs/RayCastLegBL
onready var rayCastBR := $RaycastsLegs/RayCastLegBR

func _ready():
	positionFL._register_raycast(rayCastFL)
	positionFR._register_raycast(rayCastFR)
	positionBL._register_raycast(rayCastBL)
	positionBR._register_raycast(rayCastBR)

