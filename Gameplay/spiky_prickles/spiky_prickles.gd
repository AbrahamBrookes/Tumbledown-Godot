extends Node3D

class_name SpikyPrickles

# The SpikyPricles is an environment prop that hurts the player when they touch it.
# it has an Area3D node with a CollisionShape3D that detects when the player enters its area.
# We need to react to the signal when the player enters the area and apply damage to them.

# Called when the player enters the area.
func _on_Area3D_body_entered(body: Node) -> void:
	# Check if the body has a receive damage function
	if body.has_method("receive_damage"):
		# our damage is a special type with a type and amount
		var damage = Damage.new()
		damage.type = Damage.DamageType.SPIKY
		damage.amount = 1
		damage.source = self
		# Call the receive damage function on the body
		body.receive_damage(damage)

