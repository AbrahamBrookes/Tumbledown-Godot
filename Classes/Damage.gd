extends Node3D

# The Damage type is passed around between things that do and take damage.
# It is up to the receiver to handle the damage in a way that makes sense.
class_name Damage

enum DamageType {
	SPIKY,
	EXPLOSION,
	FIRE,
	SHARP,
	BLUNT,
}

# The type of damage
var type: DamageType
# The amount of damage
var amount: int
# The thing that caused the damage
var source: Node3D

# depending on the damage type we can calculate the knockback force
func get_knockback_force() -> float:
	match type:
		DamageType.SPIKY:
			return 20.0
		DamageType.EXPLOSION:
			return 100.0
		DamageType.FIRE:
			return 10.0
		DamageType.SHARP:
			return 30.0
		DamageType.BLUNT:
			return 50.0
		_:
			return 0.0
