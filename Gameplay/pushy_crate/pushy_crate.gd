extends RigidBody3D
class_name pushy_crate




# when the push area body is entered by a duck that can push crates, inform it that it can push us
func _on_push_area_body_entered(body):
	# if the body's scene tree includes $StateMachine/LeaningCrate, then it can push us
	for child in body.get_children():
		if child.name == "StateMachine":
			if child.current_state.has_method("lean_crate"):
				child.current_state.lean_crate(self)
				return

