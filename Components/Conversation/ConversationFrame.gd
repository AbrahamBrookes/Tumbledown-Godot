extends Node

## A ConversationFrame is a single event in a conversation. Since we want to do
## things like move the camera and play character animations during conversations,
## calling it a "sentence" or "line" is too restrictive. Conversations in our
## game are fairly linear, perhaps with a yes/no selection or a topic selection
## here and there. A ConversationFrame therefore has a dictionary of other frames
## that might be traversed to. This dictionary is keyed by strings, so we show
## the strings in the selectable labels for the player to select. If there is
## only a single entry in the dictionary then we don't show any selection options
## and assume that pressing A will go to that one. If the dictionary is empty then
## we close out of the conversation. This node will have ConversationEvents as
## children and those nodes are the ones that actually do stuff like show some
## text in the conversation window, move the camera and play animations. This way
## we can compose our conversations as we go.
class_name ConversationFrame

## the dictionary containing the next nodes to move to
@export var next: Dictionary[String, ConversationFrame] = {}

## when the frame is entered, run execute on the first child node - it will decide
## what to do next when it is done
#func enter()
