extends GutTest

var inventory: PlayerInventory
var item: ItemData

func before_each():
	inventory = autoqfree(PlayerInventory.new())

	# spoof up an item to add
	item = ItemData.new()
	item.id = "test_item"
	item.stackable = true
	item.stack_count = 1

# we should be able to call add_item on an empty inventory with an ItemData
func test_can_add_item_to_empty_inventory():
	# check that the item is not in the inventory
	assert_eq(inventory.inventory.get(item.id), null)

	# add the item
	inventory.add_item(item)

	# check that the item was added - this assumes the default stack count is 1
	assert_eq(inventory.inventory.get(item.id), 1)

# adding a stackable item to an existing stack should increase the stack count
func test_can_add_to_existing_stack():
	# add the item
	inventory.add_item(item)
	
	# add the item again
	inventory.add_item(item)

	# stack should be 2
	assert_eq(inventory.inventory.get(item.id), 2)

# when we add an item to the inventory the add_item func returns true
func test_adding_item_to_inventory_returns_true():
	# add the item
	var result = inventory.add_item(item)

	# that should have returned true
	assert_eq(result, true)

	# add the item again
	result = inventory.add_item(item)

	# that should have returned true as well
	assert_eq(result, true)
