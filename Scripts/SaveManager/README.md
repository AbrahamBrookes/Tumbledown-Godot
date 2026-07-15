# res://Scripts/SaveManager
This folder handles saving and loading the game. Our game uses three save slots in classic Nintendo style. Each save file has a single master resource with many sub-resources for organisations sake.

The GameSave resource is the master file and it holds sub resources such as:
	- QuestSave
	- InventorySave
	- LocationSave

Using resources makes serialisation/deserilisation easier.
