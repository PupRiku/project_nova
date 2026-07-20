class_name EncounterData
extends Resource
## The combatants in one battle, authored as data. **Active party size = party.size()**
## — change 3 ↔ 4 here in the Inspector to tune parry load by feel (Phase 2A), no
## code changes. Encounters are swappable data, which sets up Phase 3.

# Untyped Arrays so the .tres authors cleanly; every element is a CombatantData.
@export var party: Array = []
@export var enemies: Array = []
