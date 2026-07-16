class_name MoveData
extends Resource
## The hero's attack (Phase 1: the only move). Authored as data, never
## hard-coded — balancing is editing this .tres. Every number is a tuning target.

## Damage on a normal hit (untimed / failed Press).
@export var damage_base: int = 10

## The offensive Press window (Combat Design §3.1).
@export var press: ActionCommandTiming

## Damage multiplier when the Press lands in-window (§3.1 "+X% damage").
@export var press_bonus_mult: float = 1.5
