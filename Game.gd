extends Node2D

var Double_Fire_Rate = preload("res://x2_fire_rate.tscn")
var double_fire_rate = Double_Fire_Rate.instance()

func _ready():
	add_child(double_fire_rate)
	double_fire_rate
