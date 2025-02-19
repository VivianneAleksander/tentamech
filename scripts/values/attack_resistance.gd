extends ResistanceComponent
class_name AttackResistance

@export var _type : DamageType.TYPE = DamageType.TYPE.NEUTRAL
@export var adjustment : float = 0.5;

func apply_resistance(value : float, type : int = 0) -> float:
	if type == _type: value *= adjustment
	return value
