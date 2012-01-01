-- Utility methods for CombatObjects
--
-- See Also:
-- Callbacks-CombatObjects.lua
if nil ~= require then
	require "fritomod/currying";
	require "fritomod/Functions";
	require "fritomod/CombatEvents";
end;

CombatObjects = CombatObjects or {};

do
	local eventTypes = {};
	local events = {};

	function CombatObjects.AddSharedEvent(name, eventType)
		eventType = eventType or name;
		eventTypes[name] = eventType;
	end;

	function CombatObjects.SetSharedEvent(name, ...)
		local event = events[name];
		if event then
			return event:Set(...);
		end;
		local eventType = eventTypes[name];
		assert(eventType, "No registered type for event name: "..name);
		event = CombatObjects[eventType]:New(...);
		events[name] = event;
		return event;
	end;
end;

do
	local handlers={};

	function CombatObjects.MagicTypesHandler(suffix, func, ...)
		func=Curry(func, ...);
		CombatObjects.Handler("RANGE_"..suffix, func);
		CombatObjects.Handler("SPELL_"..suffix, func);
		CombatObjects.Handler("SPELL_PERIODIC_"..suffix, func);
		CombatObjects.Handler("SPELL_BUILDING_"..suffix, func);
		CombatObjects.Handler("ENVIRONMENTAL"..suffix, func);
	end;

	function CombatObjects.AllTypesHandler(suffix, func, ...)
		func=Curry(func, ...);
		CombatObjects.Handler("SWING_"..suffix, func);
		CombatObjects.MagicTypesHandler(suffix, func);
	end;

	function CombatObjects.SimpleTypesHandler(suffix, eventName)
		CombatObjects.AllTypesHandler(suffix, function(...)
			return CombatObjects.SetSharedEvent("Spell", ...),
				CombatObjects.SetSharedEvent(eventName, select(4, ...));
		end);

		CombatObjects.Handler("SWING_"..suffix, function(...)
			-- XXX This uses WoW-specific functionality, but I don't know where
			-- the underlying code should belong.
			return CombatObjects.SetSharedEvent("Spell", nil, "SWING", SCHOOL_MASK_PHYSICAL),
				CombatObjects.SetSharedEvent(eventName, ...);
		end);

		CombatObjects.Handler("ENVIRONMENTAL_"..suffix, function(envType, ...)
			return CombatObjects.SetSharedEvent("Spell", nil, envType, SCHOOL_MASK_PHYSICAL),
				CombatObjects.SetSharedEvent(eventName, ...);
		end);
	end;

	function CombatObjects.Handler(name, func, ...)
		func=Curry(func, ...);
		handlers[name] = func;
	end;

	function CombatObjects.Handle(event, ...)
		local handler = handlers[event];
		if handler then
			return handler(...);
		else
			trace("Unhandled event: %s", event);
			return ...
		end;
	end;
end;

