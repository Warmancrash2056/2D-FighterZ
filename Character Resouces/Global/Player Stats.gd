extends Node

@export var Max_Speed: int ## Default speed of all character effected by the speed rating
@export var Fast_Fall: int ## Default fast fall is affected by the speed rating
@export var Acceleration: int ## Default acceleration for all chaacters
@export var Health: float
@export var Decelleration: int
@export var Jump_Height: int
@export var Jump_Count:int = 3
@export_range(1, 10, 1) var Speed_Rating: int ## Multiplies the max speed of player and increses based on player is in air or fast running
@export_range(1, 10, 1)var Defense_Rating: int ## Reduces the amount of variable Knockback but not constant
@export_range(1, 10, 1) var Attack_Rating: int ## Increses the amount of knockack from attack.
@export_range(1, 10, 1) var Stamina_Rating: int ## Reduces the cooldown of attacks, and stun
