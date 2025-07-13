# WEAPON CLASS. EVERY IN-GAME WEAPON INHERIT
# WHEN THE WEAPON CAN BE FIRED, fire_action() and fire_action_alt() WILL BE CALLED. OVERWRITE THESE METHODS TO GET RESULTS

extends Node3D
class_name Weapon

@export var display_name = "Weapon"
static var raycast: RayCast3D

@export_group("Ammunition")
@export var ammo = 60
@export var ammo_alt = 1
#When max ammo is set to zero, there is infinite
@export var max_ammo = 120
@export var max_ammo_alt = 3

@export_group("Firing")
@export_subgroup("Cooldowns")
@export var cooldown: float = 0.1
@export var cooldown_alt: float = 0.5

var cooldown_timer = 0
var cooldown_timer_alt = 0

# To be overriden
func fire_action(): pass # When fired with primary
func fire_action_alt(): pass # When fired with secondary
func noammo(): pass # When no ammo left on primary
func noammo_alt(): pass # Whem ammo left on secondary

func _process(delta: float) -> void:
	if cooldown_timer > 0: cooldown_timer -= delta
	if cooldown_timer_alt > 0: cooldown_timer_alt -= delta

# Method that calls fire_action() only under proper circumstances
func fire():
	if cooldown_timer > 0: return
	cooldown_timer = cooldown
	if(max_ammo):
		if(!ammo): return noammo()
		ammo-=1
	fire_action()
	
func fire_alt():
	if cooldown_timer_alt > 0: return
	cooldown_timer_alt = cooldown_alt
	if(max_ammo_alt):
		if(!ammo_alt): return noammo_alt()
		ammo_alt-=1
	fire_action_alt()

func reload():
	ammo = max_ammo
	ammo_alt = max_ammo_alt
	
# Useful methods

#Pushes object in the collision of the player's raycast
func push(force:float):
	var target = raycast.get_collider()
	if(target is not RigidBody3D): return
	target.apply_central_force(self.global_transform.basis.z * -force)
	
#Instantiates a node from a packed scene and returns it
func spawn(scene: PackedScene):
	if(!scene.can_instantiate()):
		print("Scene cannot be instantiated")
		return null
	var obj = scene.instantiate()
	get_tree().get_root().add_child(obj)
	return obj

#Instantiates node from scene and positions it where the player is looking at
func spawn_to_collision(scene: PackedScene):
	if(!raycast.is_colliding()): return
	var obj = spawn(scene)
	if(obj == null): return null
	obj.position = raycast.get_collision_point()
	return obj
