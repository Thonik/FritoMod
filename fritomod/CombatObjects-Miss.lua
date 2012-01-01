-- Combat log objects for miss events, such as immunities, dodges, and parries.
--[[

Callbacks.MissObjects(function(when, event, source, target, spell, amount)
	printf("%s avoided %d damage from %s's %s. (Reason: %s)",
		target:Name(),
		amount:Amount(),
		source:Name(),
		spell:Name(),
		amount:Reason()
	);
end);

--]]
if nil ~= require then
	require "fritomod/OOP-Class";
	require "fritomod/CombatObjects";
	require "fritomod/CombatObjects-Amount";
	require "fritomod/Callbacks-CombatObjects";
end;

CombatObjects=CombatObjects or {};

local MissEvent = OOP.Class(CombatObjects.Amount);
CombatObjects.Miss = MissEvent;

function MissEvent:Constructor(...)
	self:Set(...);
end;

function MissEvent:Set(missType, isOffHand, amount)
	self.super.Set(self, missType, amount, 0);
	self.isOffHand = isOffHand;
	return self;
end;

function MissEvent:Clone()
	return MissEvent:New(
		self:Type(),
		self:IsOffHand(),
		self:Amount());
end;

function MissEvent:IsOffHand()
	return Bool(self.isOffHand);
end;

MissEvent.Reason = Headless("Type");

CombatObjects.AddSharedEvent("Miss");

CombatObjects.SimpleTypesHandler("MISSED", "Miss");

Callbacks.MissObjects = Curry(Callbacks.SuffixedCombatObjects, "_MISSED");
