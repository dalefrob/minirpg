extends Node
class_name BattleScreen

@onready var camera : Camera2D = $Camera2D
@onready var bg : Sprite2D = $Background

@export var monsters : Array[Actor] = []
@export var party : Array[Actor] = []
