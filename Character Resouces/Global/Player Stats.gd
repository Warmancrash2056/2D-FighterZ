extends Node

@export var Speed_Rating: float
@export var Max_Speed: int
@export var Acceleration: int
@export var Decelleration: int
@export var Jump_Height: int
@export var Jump_Count:int = 3
@export var Gravity: int
@export var Defense_Rating: float # Decreases the amount of damage taken per incoming attack
@export var Health: float
@export var Attack_Rating: int # Increases base damage of an outgoing attack
@export var Stamina_Rating: float
# Decreases the amount of recovery frames you are in before you can attack or move
# Also effects the your stun time from an incoming attack
