extends Node

@export var Speed_Rating: int ## Multiplies the max speed of player and increses based on player is in air or fast running
@export var Weight_Scale: int ## Weight scale of the character efects the gravity
@export var Max_Speed: int
@export var Fast_Fall: int
@export var Acceleration: int
@export var Decelleration: int
@export var Jump_Height: int
@export var Jump_Count:int = 3
@export var Gravity: int
@export var Defense_Rating: int ## Reduces the amount of Constant Knockback
@export var Health: int
@export var Attack_Rating: int ## Increses the amount of damage from attack
@export var Stamina_Rating: int
# Decreases the amount of recovery frames you are in before you can attack or move
# Also effects the your stun time from an incoming attack
