if Metatables == nil then
    Metatables = {};
end;

-- Adds the specified observer to self. Used with Metatables.Multicast
local function Add(self, observer)
    if not observer then
        error("observer is falsy");
    end;
    assert(type(observer) == "table", "observer is not a table. Type: ".. type(observer));
    table.insert(self, observer);
    return Curry(Lists.Remove, self, observer);
end;

-- Creates a "composite" table. The returned table forwards all method calls
-- to all of its registered observers. This allows for very clean event dispatching,
-- and for adaptability in the future, since one, regular table acts almost identical 
-- to the composite table created here. 
--
-- For example, assume we want to receive Bar events from an object "foo". To accomplish
-- this, we write:
--
-- foo:Add(listener);
-- 
-- Now, in foo, when we wish to dispatch Bar events, we simply call "Bar":
--
-- function foo:Dispatch()
--     self:Bar();
-- end;
--
-- When this is done, listener:Bar() is invoked.
--
-- table
--     the table that is the target of this operation. If nil, a new table is created.
-- returns
--     table
Metatables.Multicast = MetatableAttacher({
    __index = function(self, key)
        if key == "Add" then
            return Add;
        end;
        return function(self, ...)
            for i=1, #self do
                local observer = self[i];
                observer[key](observer, ...);
            end;
        end;
    end
});

function Metatables.OrderedMap(target)
    target = AssertTable(target);

    local insertionOrder = {};
    local values = {};

    setmetatable(target, {
        __newindex = function(self, key, value)
            if values[key] ~= nil then
                if value == nil then
                    Lists.Remove(insertionOrder, key);
                end;
            else
                Lists.Insert(insertionOrder, key);
            end;
            values[key] = value;
        end,

        __index = values
    });

    function target:Iterator()
        local iterator = Iterators.IterateList(insertionOrder);
        return function()
            local index, key = iterator();
            if not index then
                return;
            end;
            return key, values[key];
        end;
    end;

    return target;
end;
