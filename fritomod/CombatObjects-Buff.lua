if nil ~= require then
	require "fritomod/OOP-Class";
	require "fritomod/CombatObjects";
	require "fritomod/CombatObjects-Spell";
end;

CombatObjects=CombatObjects or {};

local BuffEvent = OOP.Class(CombatObjects.Spell);
CombatObjects.Buff = BuffEvent;

function BuffEvent:Constructor(...)
	self:Set(...);
end;

function BuffEvent:Set(id, name, school, auraType)
	self.super.Set(self, id, name, school);
	self.auraType = auraType;
end;

function BuffEvent:Clone()
	return BuffEvent:New(
		self:Id(),
		self:Name(),
		self:School(),
		self:AuraType());
end;

function BuffEvent:AuraType()
	return self.auraType;
end;

function BuffEvent:IsBuff()
	return self.auraType == "BUFF";
end;

function BuffEvent:IsDebuff()
	return self.auraType == "DEBUFF";
end;

CombatObjects.AddSharedEvent("Buff");

local dispelObjects = {
	"DISPEL",
	"DISPEL_FAILED",
	"STOLEN",
	"AURA_BROKEN_SPELL"
};

CombatObjects.SimpleSuffixHandler(dispelObjects, "Buff");

Callbacks.DispelObjects = Curry(
	Callbacks.SuffixedCombatObjects,
	dispelObjects);

local buffObjects = {
	"AURA_APPLIED",
	"AURA_REMOVED",
	"AURA_REFRESH",
	"AURA_BROKEN"
};

CombatObjects.SpellTypesHandler(buffObjects, "Buff");

Callbacks.BuffObjects = Curry(
	Callbacks.SuffixedCombatObjects,
	buffObjects);
Callbacks.AuraObjects=Callbacks.BuffObjects;

local buffDoseObjects = {
	"AURA_APPLIED_DOSE",
	"AURA_REMOVED_DOSE"
};

CombatObjects.SpellTypesHandler(
	buffDoseObjects,
	function(...)
		return CombatObjects.SetSharedEvent("Buff", ...),
			select(5, ...);
	end);

Callbacks.BuffDoseObjects = Curry(
	Callbacks.SuffixedCombatObjects,
	buffDoseObjects);
Callbacks.AuraDoseObjects=Callbacks.BuffDoseObjects;

