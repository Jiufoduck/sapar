extends Bullets

signal attract(pos,strength)

var strength

func initialize(attack,vel,strength):
	time = 2
	self.strength = strength
	vel = vel
	main_velocity = vel



func explode():
	attract.emit(position,strength)
	super()
