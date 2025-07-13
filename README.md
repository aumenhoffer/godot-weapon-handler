![properties](/screenshots/example.png)

## What is this?

This is not a full project or a Godot Asset, but rather a set of scripts I originally developed as part of my Computer Science final. It is an implementation of a very simple and flexible
`WeaponHandler` and `Weapon` class that manages ammunition, cooldowns, weapon-switching and firing for a large variety of potential in-game weapons. This addon contains NO weapons in itself but once set up it allows new ones to be created and integrated into the game under a matter of seconds.

## How to use

### Setup
1. Import both [weapon.gd](weapon.gd) and [weapon_handler.gd](weapon_handler.gd) into your Godot project to any location
2. Create a "WeaponHandler" node which will serve as the handler. Ideally you want this to be a child of your player node.
3. Direct your attention to the properties window. Fill in the fields according to the following criteria:

| Field name  | Purpose | Optional |
| ------------| --------|----------|
| Holder | A type Node3D node that serves as a parent for every weapon the player will hold. You want to position this wherever you want the weapons to be rendered | No
|Raycast| A type Raycast3D node ideally attached to the player's camera. This will determine how far weapons will be capable of reaching | No
|Name Label | A type Label. The text of the label will be set to the name of the weapon held in the moment|Yes
|Ammunition Label| A type Label. The text of the label will be set to the ammunition information of the weapon held|Yes

### Adding your weapons
Once [weapon.gd](weapon.gd) is imported a new type `Weapon` should be available when adding new nodes.
A weapon node should be a **child** of the holder node (the very same as the 'Holder' property of your WeaponHandler). The weapon node comes with useful properties you can change. Note when Ammunition is set to zero, there is no limit on ammunition.


The default weapon does not do much, but you should already see your label changing to the selected weapon's display name accordingly when you start your game, assuming you have a properly configured WeaponHandler in the scene.


To make use of the `Weapon` class, you need to inherit it using `extends Weapon` in a custom script you attach to this node. From this point adding features is easy as you can use the basic methods provided by the class such as
`push(force:float)`, `spawn(scene: PackedScene)`, or `spawn_to_collision(scene: PackedScene)`. You are welcome to extend this list as you please.


> [!NOTE]  
> `Weapon.raycast` is a static variable of `Weapon` set automatically by your WeaponHandler.

The most important methods are `fire_action()`, `fire_action_alt()`, `noammo()` and `noammo_alt()`. These are not meant to be called, but rather overridden in your custom weapon-specific scripts.

## Examples

Example implementation of a *gravity gun* style weapon:
```
extends Weapon

@export var force:float = 10

func fire_action():
	push(force)

func fire_action_alt():
	push(-force)
```

![properties](/screenshots/properties.png)

> [!TIP]
> Weapons that launch projectiles from a certain position (ex: end of the barrel) can be created in a few lines like this:
> ```
> extends Weapon
>
> @export var projectile_holder: Node3D
> @export var projectile: PackedScene
>
> func fire_action():
>	var bb = spawn(projectile)
>	bb.position = projectile_holder.global_position
>	bb.apply_central_force(self.global_transform.basis.z * -2000)
> ```
> This requires you to create a projectile holder node as a child of your weapon.
