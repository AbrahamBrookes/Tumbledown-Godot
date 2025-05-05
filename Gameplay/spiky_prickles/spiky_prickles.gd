extends Node3D

class_name SpikyPrickles

# The SpikyPricles is an environment prop that hurts the player when they touch it.
# it has an Area3D node with a CollisionShape3D that detects when the player enters its area.
# We need to react to the signal when the player enters the area and apply damage to them.

# The leaves mesh, to animate "closed"
@onready var leaves: MeshInstance3D = $leaves
# a tween for that animation
var tween: Tween = null
# the timer for waiting until the leaves go back up
@onready var leaves_back_up_timer: Timer = $leaves_back_up_timer

func _ready():
	# Create a Tween node and add it as a child
	tween = create_tween()

# when the close box is entered, rotate the leaves down
func _on_close_box_body_entered(body):
	# Check if the body has a receive damage function
	if body.has_method("receive_damage"):
		# tween rotate the leaves down
		var tween = create_tween()
		tween.tween_property(leaves, "rotation_degrees", Vector3(-30, 0, 0), 1.0)
		# start the timer to go back up
		leaves_back_up_timer.start()

# when the hurt box is entered, hurt!
func _on_hurt_box_body_entered(body):
	# Check if the body has a receive damage function
	if body.has_method("receive_damage"):
		# our damage is a special type with a type and amount
		var damage = Damage.new()
		damage.type = Damage.DamageType.SPIKY
		damage.amount = 1
		damage.source = self
		# Call the receive damage function on the body
		body.receive_damage(damage)

# when the timer is up, rotate the leaves back up
func _on_leaves_back_up_timer_timeout():
	# tween rotate the leaves back up
	var tween = create_tween()
	tween.tween_property(leaves, "rotation_degrees", Vector3(82.5, 0, 0), 1.0)
	# stop the timer
	leaves_back_up_timer.stop()
