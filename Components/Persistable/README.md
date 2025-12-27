# res://Components/Persistable

The Persistable component is an attempt at a reusable save game system. It works in tandem with the SaveManager global (loaded via project settings). It needs a little bit of implementation each time but largely handles the saving and loading of data from the relevant save slot.

## Overview
Persistable provides a method `load_from_disk` which kicks off the loading sequence. Once the data is loaded, it emits the `loaded_from_disk` signal with the loaded data, which you implement against locally. Check out the LootyChest scene and script for a simple example.

## SaveManager
The SaveManager global stores the current save slot number and provides a getter for the base directory of our save game ("user://saves/slot_n/"). Persistable uses that string alongside its locally settable "Save File" property so that we can break our save files out into logical groups and avoid having a horrendously bloated single save file.

## Idiosyncrasies
We are bumping up against some limitations of Godot here so there are some workarounds required (until I get a bit more savvy and can properly overcome them - there's likely a proper way).

### Setting a GUID
Each Persistable component needs its GUID property set. You can manually set this to any string if you want, but it needs to be unique within the save file or else you'll be loading up data from the wrong key. For this reason there is a helpful "Generate Guid" button on the Persistable component inspector pane.

### Editable Children
Due to this component being nested inside other components I had issues with auto-generating the GUID when you add its parent scene to some other scene. To explain:

 - We have the LootyChest which has a Persistable component
 - We want to drop the LootyChest into a scene and have it automatically generate a new GUID
 - If we save the GUID in the Persistable scene or the LootyChest scene, it will be pre-set when you drop the chest into any other scene, doubling up the key in the save file
 - When using _enter_tree, for some reason whenever I cleared the GUID field in the child scenes, it would re-set and re-save itself resulting in doubled up keys. So I abandoned using _enter_tree

The upshot of this is that whenever you are placing a scene that has a Persistable component, you'll need to set "Editable Children" so that you get access to the Persistable component and then set the GUID either manually or using the button.

### How to use
#### Setting up your object
 - In the scene that you want to persist, add a Persistable node
 - Set the "Save File" to a logical file (probs don't make a bajillion files, be sensible)
 - **PROBABLY LEAVE THE GUID BLANK** - if you plan to add more than one of these objects to the game elsewhere then you don't want to pre-set the GUID within the object or all instances of this object will load from the same data.
 - Connect the `loaded_from_disk` signal to some local logic that handles hydrating your state
 - Call down to the `save_to_disk` method in order to persist your data. These use Variant types but you'll need to make sure the type you are using is serializable.
#### Using your object in the world
 - Place your object in the world
 - Right click it and select "Editable Children"
 - Set the GUID (probs just click the "Generate Guid" button) - this makes the instance uniquely persistable
 - That's it! Nifty

