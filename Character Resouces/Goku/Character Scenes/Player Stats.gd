extends Node

@export var Speed_Rating: float
@export var Max_Speed: int
@export var Acceleration: int
@export var Decelleration: int
@export var Jump_Height: int
@export var Gravity: int
@export var Defense_Rating: float # Decreases the amount of damage taken per incoming attack
@export var Health: float
@export var Attack_Rating: int # Increases base damage of an outgoing attack
@export var Stamina_Rating: float
# Decreases the amount of recovery frames you are in before you can attack or move
# Also effects the your stun time from an incoming attack

@export var Nlight: Vector2
@export var NHeavy: Vector2
@export var SLight: Vector2
@export var SHeavy: Vector2
@export var DLight: Vector2
@export var DHeavy: Vector2
@export var NRecovery: Vector2
@export var Drecovey: Vector2
@export var Air_Projectile: Vector2
@export var Ground_Projectile: Vector2
