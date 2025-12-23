extends GutTest

var inventory: PlayerInventory
var item: ItemData

func before_each():
	inventory = autoqfree(PlayerInventory.new())

	# spoof up an item to add
	item = ItemData.new()
	item.id = "test_item"
	item.stackable = false
	item.stack_count = 1

# adding a non stackable item to an empty inventory should add the item
func test_can_add_non_stackable_item_to_empty_inventory():
	# add the item
	inventory.add_item(item)

	# stack should be 1
	assert_eq(inventory.inventory.get(item.id), 1)

# adding a non stackable item to an existing stack won't work
func test_can_not_double_add_non_stackable_item_to_empty_inventory():
	# add the item
	inventory.add_item(item)
	
	# add the item again
	inventory.add_item(item)

	# stack should still be 1
	assert_eq(inventory.inventory.get(item.id), 1)

# adding a non stackable item will return true if it is added, false if it is not
func test_adding_non_stackable_item_returns_bool():
	# add the item
	var result = inventory.add_item(item)

	# that should have returned true
	assert_eq(result, true)

	# add the item again
	result = inventory.add_item(item)

	# that should have returned false
	assert_eq(result, false)
