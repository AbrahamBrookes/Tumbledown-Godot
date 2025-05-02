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
