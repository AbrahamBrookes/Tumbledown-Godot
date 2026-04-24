# res://Gameplay/Enemies
In our game all enemies extend from BaseEnemy.tscn. That scene sets up the basics for all enemies including their brain, state machine and blackboards. Creating a new enemy is mainly a case of right click > new inherited scene and then reassigning meshes and animations into the anim tree

## The system works thus
Each enemy has the following components:
	- StateMachine. This uses a general state machine pattern where each state has logic to run on enter and exit, as well as each physics_process. The state machine only has a single state active at a time so only one state ever ticks.
	- Brain. This is a memory bank, effectively a type safe enum that all enemies will use, and states will check the data in the brain when deciding what state to transition to next.
	- Strategies. In order to provide different behaviours under the same state (ie a zigzagging flying enemy vs a fast direct running enemy) states defer some logic to "Strategies" so the "MoveTo" state calls a strategy, and we can swap out the strategy in our inherited enemy to provide different behaviour when in the same state.

### The Brain
The brain holds the knowledge the enemy has of the world around it, and itself.
	- RoleAffinity - each enemy prefers different roles. A healer prefers to heal allies, but if there are no allies it can still attack. RoleAffinity is just a dictionary with weights keyed by the Role enum.
	- PossibleThreats - an enemy may hear something (when something enters it's agrozone) but hasn't yet confirmed the threat (can't see it via raycast). This is a list of locations to inspect
	- ActiveThreats - this is a list of actual entities that the enemy needs to attack, with weights for each so that a heavier threat will be prioritized. Threats are made heavier ie if they are closer or if they are attacking us or our allies.
	- Faction - for the sake of simplicity, enemies belong to a single faction. This is a public property so other enemies can "telepathically" know what faction each other are on. This is a stand in for actual out-of-play communication.
	- FactionAffinity - while enemies generally "belong to" a faction, realistically they can have their own opinion about each faction. For instance if they cop collateral damage from a neutral faction they might decide that they want to attack that faction, but their teammates might not. The faction affinity is used when weighing up attacks and supports.
The brain also exposes helpful methods for making decisions but does not directly force state transitions - the states themselves (or their strategies) query the brain and decide wether to change state or not.

Note that this system does not use a director. By using the RoleAffinity and FactionAffinity weights we don't really need a director as each enemy will be able to select a role and decide who to attack without being dictated to.
