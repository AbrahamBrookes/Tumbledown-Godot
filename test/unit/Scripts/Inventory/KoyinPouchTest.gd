extends GutTest

## The KoyinPouch tracks our game currency - koyins. We just need to add and
## remove koyins, which increases and decreases koyin count

var pouch : KoyinPouch

func before_each():
	pouch = KoyinPouch.new()

func test_add_koyins():
	pouch.add_koyins(3)
	
	assert_eq(pouch.koyins, 3)
	
func test_remove_koyins():
	pouch.add_koyins(3)
	assert_eq(pouch.koyins, 3)
	
	pouch.remove_koyins(2)
	assert_eq(pouch.koyins, 1)
	
