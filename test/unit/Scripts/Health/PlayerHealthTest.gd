extends GutTest

## The PlayerHealth script manages player health. We have max health which defines
## how many total hearts are shown in the UI, and current health which defines how
## many hearts are full. Each heart represents 4 health points and can be in one
## of five states: full, 3/4, 1/2, 1/4, empty. When health is depleted we emit a
## signal that can be listened to by the player script for ie death.

# the PlayerHealth script we are testing
var health: PlayerHealth

# the UI has a GridContainer containing 22 texture rects representing each heart
var grid: GridContainer

func before_each():
	# instantiate the grid container and give it 22 texture rects
	grid = autoqfree(GridContainer.new())
	for i in range(22):
		var heart = autoqfree(TextureRect.new())
		grid.add_child(heart)

	health = autoqfree(PlayerHealth.new())
	health.hearts_container = grid

# test that setting max_health will show the correct number of texture rects
func test_max_health_updates_ui():
	health.max_health = 40  # 10 hearts
	health.update_max_health_ui()

	# 22 rects _exist_
	assert_eq(grid.get_child_count(), 22)

	# but only 10 are visible
	var visible_count = 0
	for i in range(grid.get_child_count()):
		var heart = grid.get_child(i) as TextureRect
		if heart.visible:
			visible_count += 1

	assert_eq(visible_count, 10)

	# and just to double check, set max health to 88 (22 hearts)
	health.max_health = 88
	health.update_max_health_ui()
	
	# 22 rects still exist
	assert_eq(grid.get_child_count(), 22)

	# and all 22 are visible
	visible_count = 0
	for i in range(grid.get_child_count()):
		var heart = grid.get_child(i) as TextureRect
		if heart.visible:
			visible_count += 1
	
	assert_eq(visible_count, 22)

# test that removing health updates the UI correctly
func test_remove_health_updates_ui():
	health.max_health = 88  # 22 hearts
	health.current_health = 88
	health.update_max_health_ui()
	health.update_hearts_ui()

	# remove 1 health point
	health.remove_health(1)
	assert_eq(health.current_health, 87)

	# check that the last heart is now 3/4 full
	var last_heart = grid.get_child(21) as TextureRect
	assert_eq(last_heart.texture, health.heart_textures[3])

	# remove 3 more health points (total 4)
	health.remove_health(3)
	assert_eq(health.current_health, 84)
	# check that the last heart is now empty
	last_heart = grid.get_child(21) as TextureRect
	assert_eq(last_heart.texture, health.heart_textures[0])

# test that adding health updates the UI correctly
func test_add_health_updates_ui():
	health.max_health = 88  # 22 hearts
	health.current_health = 80
	health.update_max_health_ui()
	health.update_hearts_ui()

	# add 2 health points
	health.add_health(2)
	assert_eq(health.current_health, 82)

	# check that the last heart is now 1/2 full
	var last_heart = grid.get_child(20) as TextureRect
	assert_eq(last_heart.texture, health.heart_textures[2])

# test that depleting health to zero emits the health_depleted signal
func test_health_depletion_emits_signal():
	watch_signals(health)

	# remove all health
	health.remove_health(health.current_health)
	assert_eq(health.current_health, 0)

	assert_signal_emitted(health, "health_depleted")

# test that adding health does not exceed max health
func test_add_health_does_not_exceed_max():
	health.max_health = 88  # 22 hearts
	health.current_health = 85
	health.update_max_health_ui()
	health.update_hearts_ui()

	# add 10 health points
	health.add_health(10)
	# current health should not exceed max health
	assert_eq(health.current_health, 88)
