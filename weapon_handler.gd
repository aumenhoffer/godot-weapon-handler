extends Node3D
class_name WeaponHandler

@export var holder: Node3D
@export var raycast: RayCast3D
static var selected: Weapon
static var selectedIndex:int = 0
@export var default_weapon_index:int = 0

@export_group("Labels")
@export var name_label: Label 
@export var ammo_label: Label

var is_lowered = true
var is_raised = true

func _process(delta: float) -> void:
	if(selected):
		name_label.text = selected.display_name
		ammo_label.text = str(selected.ammo)+"/"+str(selected.max_ammo) + " ALT: " + str(selected.ammo_alt) + "/" + str(selected.max_ammo_alt)

func select_weapon(index:int):
	var weapons = holder.get_children()
	if(index >= weapons.size()): index = 0
	if(index < 0): index = weapons.size()-1
	var i:int = 0
	while (i < weapons.size()):
		if (i == index): 
			selectedIndex = index
			selected = weapons[i]
			weapons[i].visible = true
		else: weapons[i].visible = false
		i+=1

func _ready():
	if(raycast): Weapon.raycast = raycast
	var weapons = holder.get_children()
	if(weapons.size() == 0): return
	else: select_weapon(default_weapon_index)

func _input(event):
	if(Input.mouse_mode != Input.MOUSE_MODE_CAPTURED): return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			select_weapon(selectedIndex+1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			select_weapon(selectedIndex-1)			
	if event is InputEventKey:
		if event.keycode == KEY_R:
			selected.reload()
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)): selected.fire()
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)): selected.fire_alt()	
