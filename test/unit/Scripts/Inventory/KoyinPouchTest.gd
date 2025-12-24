extends GutTest

## The KoyinPouch tracks our game currency - koyins. We just need to add and
## remove koyins, which increases and decreases koyin count

# the pouch itself
var pouch : KoyinPouch

# a label to show koyin count
var koyin_label : Label

func before_each():
	pouch = KoyinPouch.new()
	koyin_label = Label.new()
	pouch.label = koyin_label

func test_add_koyins():
	pouch.add_koyins(3)
	
	assert_eq(pouch.koyins, 3)
	
func test_remove_koyins():
	pouch.add_koyins(3)
	assert_eq(pouch.koyins, 3)
	
	pouch.remove_koyins(2)
	assert_eq(pouch.koyins, 1)

## The label should be updated whenever we add or remove koyins
func test_label_updates_on_add_koyins():
	pouch.add_koyins(5)
	assert_eq(koyin_label.text, "5")

func test_label_updates_on_remove_koyins():
	pouch.add_koyins(5)
	assert_eq(koyin_label.text, "5")

	pouch.remove_koyins(3)
	assert_eq(koyin_label.text, "2")

	
