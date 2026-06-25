extends Node

## The EnemyBrain holds onto context about the world (and decays it) so that the enemies states can
## query the "world (the brain) and make decisions about what to do next.
class_name EnemyBrain

## PossibleThreats are just locations with a score. These are places the enemy wants to investigate
var PossibleThreats: Array[Node3D] = []

## A reference to the zone that we monitor to add possibleThreats
@export var agroZone: Area3D

## ActiveThreats are things that the enemy wants to attack. The enemy selects a target from this list
## and attempts to eliminate the threat. Before being added to this list a node will need to be sniffed
## to see if it has a receive_damage method because otherwise we can't damage it.
var ActiveThreats: Dictionary[Node3D, float]

## An enum for listing all the roles an enemy might be. This is so that we don't have all enemies
## doing the same thing, and allows enemies to switch up behaviours
enum Role {
	TANK, # generally tries to draw fire, taunts, makes self a nuisance
	ATTACK, # attacks incessantly, has to be dispatched quickly
	HEAL, # heals if available
	LURK, # hangs around just outside the fight waiting to attack
}

## Enemies prefer certain roles and will decide their actions based on their role. There are some roles
## they should never do, and some roles they greatly prefer. This is configured per inherited enemy
@export var RoleAffinity: Dictionary[EnemyBrain.Role, float]

## Enemies belong to a faction. Factions are mainly handled through resources. Each faction is a .res
## file that can be serialized, and contains things like how that faction feels about all other factions
## and flavour text. We have a FactionRegistry global which references a FactionDatabase resource that
## holds a list of all factions available in the game. To that end, we select the Faction for each enemy
## and that enemy then belongs to that faction. Other enemies can "telepathically" know which faction
## other enemies are in, as a stand in for real-world commnication
@export var BelongsToFaction: Faction

## A weighted list of factions defining how this enemy feels about that faction in general - used to
## score decisions but also to allow individual enemies to "defect" from a faction if they are ie
## attacked by some other faction, or maybe go beserk. > 0 means favourable, < 0 mean unfavourable.
## If a faction is not on the list then it's 0 (neutral). Overlays the BelongsToFaction.affinites
@export var FactionAffinity: Dictionary[String, float]


func _on_agrozone_body_entered(body: Node3D) -> void:
	PossibleThreats.append(body)


func _on_agrozone_body_exited(body: Node3D) -> void:
	PossibleThreats.erase(body)
