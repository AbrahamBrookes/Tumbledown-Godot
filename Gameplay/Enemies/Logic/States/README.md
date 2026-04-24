# res://Gameplay/Enemies/Logic/States
The states in here are meant to be shared across enemies.

Since enemies need to make their own decisions (as opposed to players who react to input) these states include logic for transitioning out of the state.

For instance, all enemies are going to have an idle state and an agro collider. So they will all react to a player entering the agro collider by targeting them and moving towards them.

I did have a full on behaviour tree setup but it was way overengineered and BT's are mainly useful when non-programmers need to create enemy behaviours based on pre-build blocks. That's too complex and hard to maintain and since this is a small project atm it's easier to just write states that make decisions with parameters to make it look like they are different.
