extends Resource

## This is a resource that is used to define new factions. Factions are registered into the FactionDatabase
## which is used as a lookup for other logic
class_name Faction

## The unique ID that will be used to refernce this faction
@export var id: String

## Shown in game to reference this faction
@export var display_name: String

## How does this faction feel about other factions? If this value is > 0 then we like that faction.
## If it is < 0 then we don't like that faction. If a faction is not on this list it's neutral (0)
@export var affinities: Dictionary[String, float]
