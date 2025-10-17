# res://Scripts

This folder contains the code-only stuff that we use to generally configure our gameplay.

## The BehaviourTree StateMachine Blackboard trifecta
Enemy behaviours are managed using three main configurable nodes: 
	- The BehaviourTree which manages decision making based on blackboard data
	- The StateMachine which handles discrete states and updates blackboard data
	- The BehaviourTreeBlackboard which acts as a datastore for an actor's brain
See the individual readmes and comments in the base files for more details, but here are the broad strokes

### Setting up an Actor
You'll need to add a StateMachine to the actor and add States as child nodes. States are things like "Idle", "Pursue", "Jumping" etc, and represent the single state that an actor can be in at any one time. States are built for reuse in that things like which animation to run are @exposed so you can set them in the editor instead of writing a new class for every enemy's state. Other states are very specific to a single enemy and so are bespoke.

You'll also need a BehaviourTree and its associated nodes. Behaviour Trees are more sophisticated than state machines. You set up sequences and selectors with actions and the BehaviourTree traverses the tree each frame and decides which action to fire (or none if an action is still running)

The Blackboard ties them together - states write to the blackboard and the BehaviourTree child nodes read from the blackboard and that switches the path through the tree that the agent's brain takes.

#### Example:
An enemy starts off idle, with full health. The state machine is set to the idle state and the idle animation plays. The blackboard stores health as 100% and target is null. Each frame the behaviour tree checks:
	- What am I doing? Idle
	- How's my health? Fine
	- Can I see an enemy? No
	- What should I do? Idle
	
The player enters the NPC's field of view:
	- What am I doing? Idle
	- How's my health? Fine
	- Can I see an enemy? Yes
	- What should I do? Pursue

The "Pursue" BehaviourTreeAction fires a signal which is hooked up to the StateMachines "TravelTo" method, and transitions to the "Pursue" state, changing the animations etc.

The "Pursue" state also handles the move_and_slide() of the NPC - not the action. Think of states as the ongoing "what we're doing" code, and actions as one off "changed my mind" code.

The BehaviourTree then goes:
	- What am I doing? Pursue
	- Can I see an enemy? Yes
	- Can I reach them to attack? No
	- What should I do? Pursue
The action would likely return a RUNNING state here as the NPC hasn't reached it's goal yet and doesn't want to change it's mind

Finally:
	- What am I doing? Pursue
	- Can I see an enemy? Yes
	- Can I reach them to attack? Yes
	- What should I do? Attack
Transition to Attack state > StateMachine handles damage etc

Bonus round, the player hits the enemy:
	- What am I doing? Attacking
	- How's my health? low
	- What should I do? Retreat!

The idea being you should be able to hook up some cool behaviours simply by configuring nodes instead of writing heaps of code, and all this can be unit and integration tested.
