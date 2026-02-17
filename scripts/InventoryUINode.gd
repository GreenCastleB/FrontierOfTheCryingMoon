extends Control

# The Inventory UI Node

const FULL_SIZE:int = 102;

## 0.0 is hidden, 1.0 is shown.
@export_range(0.0,1.0) var progress:float = 1.0:
	set(newVal):
		progress = newVal;
		var custMinSize:int = roundi(FULL_SIZE * progress);
		%Background.set_deferred("custom_minimum_size", Vector2(custMinSize, 0));
		self.set_deferred("custom_minimum_size", Vector2(custMinSize, 0));
