# Test Mocks

This directory contains mock classes used for testing the behavior tree system.

## Mock Classes

- **MockAction**: A simple mock implementation of `BehaviourTreeAction` that can be configured to return different results and tracks whether it was called
- **MockCondition**: A simple mock implementation of `BehaviourTreeCondition` that can be configured to return different results and tracks whether it was called  
- **BlackboardReaderAction**: A mock action that reads values from the blackboard for testing blackboard functionality

## Usage

These classes are automatically available in tests due to Godot's `class_name` system. Simply instantiate them in your test files:

```gdscript
var mock_action = MockAction.new()
mock_action.return_value = BehaviourTreeResult.Status.FAILURE
```

## Extending Mock Classes

When adding new mock classes:
1. Use the `class_name` declaration 
2. Extend the appropriate base class
3. Add tracking properties (e.g., `was_ticked`) for verification
4. Add configuration properties (e.g., `return_value`) for controlling behavior