extends Node

signal sapar_changed
signal combat_init

var player_pos = Vector2.ZERO
var MaxHP = 10
var HP = 10
var golds = 0


var sapar_radius = [80,100,120,160,200,240]
var target_enemy = []
var player_strength = 2

#loots
var sheild:bool = false
var sheild_value = 2.0

var basis_gold_amount = 0

#skills
var is_dash_able:bool = false

func set_sapar(arr: Array[int]):
	sapar_radius = arr
	sapar_changed.emit()


func initialize_combat_ui():
	combat_init.emit()
