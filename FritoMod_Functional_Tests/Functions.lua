if nil ~= require then
    require "FritoMod_Testing/ReflectiveTestSuite";
    require "FritoMod_Testing/Assert";
    require "FritoMod_Testing/Tests";

    require "FritoMod_Functional/Functions";
end;

local Suite = ReflectiveTestSuite:New("FritoMod_Functional.Functions");

function AGlobalFunctionNoOneShouldEverUse(stuff)
    Assert.Equals(4, stuff, "Internal global receives externally received value");
    return stuff;
end;

function Suite:TestHookGlobal()
    local counter = Tests.Counter();
    local remover = Functions.HookGlobal("AGlobalFunctionNoOneShouldEverUse", function(stuff)
        counter.Hit();
        Assert.Equals(2, stuff, "Wrapped function receives externally received value");
        return stuff * 2;
    end);
    local result = AGlobalFunctionNoOneShouldEverUse(2);
    Assert.Equals(4, result, "Wrapped global returns internally returned value");
    remover();
    result = AGlobalFunctionNoOneShouldEverUse(4);
    Assert.Equals(4, result, "Wrapped global returns original value when hook is removed");
    counter.Assert(1, "Hook function only fires once");
end;

function Suite:TestHookGlobalFailsWhenIntermediatelyModified()
    local remover = Functions.HookGlobal("AGlobalFunctionNoOneShouldEverUse", Noop);
    local original = AGlobalFunctionNoOneShouldEverUse;
    AGlobalFunctionNoOneShouldEverUse = nil;
    Assert.Exception("HookGlobal fails when global is modified between calls", remover);
    AGlobalFunctionNoOneShouldEverUse = original;
    remover();
end;

function Suite:TestSpyGlobal()
    local counter = Tests.Counter();
    local remover = Functions.SpyGlobal("AGlobalFunctionNoOneShouldEverUse", function(stuff)
        counter.Hit();
        Assert.Equals(4, stuff, "Spied global receives original value");
        return stuff * 2;
    end);
    local result = AGlobalFunctionNoOneShouldEverUse(4);
    Assert.Equals(4, result, "Spied global returns original value");
    remover();
    result = AGlobalFunctionNoOneShouldEverUse(4);
    Assert.Equals(4, result, "Spied global returns original value after removal");
    counter.Assert(1, "Spy function only fires once");
end;

function Suite:TestSpyGlobalFailsWhenIntermediatelyModified()
    local remover = Functions.SpyGlobal("AGlobalFunctionNoOneShouldEverUse", Noop);
    local original = AGlobalFunctionNoOneShouldEverUse;
    AGlobalFunctionNoOneShouldEverUse = nil;
    Assert.Exception("SpyGlobal fails when global is modified between calls", remover);
    AGlobalFunctionNoOneShouldEverUse = original;
    remover();
end;

function Suite:TestActivatorInitialState()
    local initializerFlag = Tests.Flag();
    local uninitializerFlag = Tests.Flag();
    local value = nil;
    local function Wrapped(element)
        assert(initializerFlag.IsSet(), "Initializer is set before wrapped is called");
        Assert.Equals(true, element, "Correct value was passed to wrapped function");
        value = element;
    end;
    local func = Functions.Activator(Wrapped, function()
        assert(not initializerFlag.IsSet(), "Initializer is never called redundantly");
        initializerFlag.Raise();
        return function()
            assert(initializerFlag.IsSet(), "Uninitializer is never called redundantly");
            initializerFlag.Clear();
            uninitializerFlag.Raise();
        end;
    end);
    local remover = func(true);
    assert(initializerFlag.IsSet(), "Initialization is performed on first invocation");
    Assert.Equals(true, value, "Wrapped function was called on first invocation");
    remover();
    assert(not initializerFlag.IsSet(), "Initialization is undone after remover is called");
    assert(uninitializerFlag.IsSet(), "Initialization is undone after remover is called");
end;

function Suite:TestActivatorWithNesting()
    local items = {};
    local counter = Tests.Counter();
    local uninitializerFlag = Tests.Flag();
    local func = Functions.Activator(Curry(Lists.Insert, items), function()
        counter.Hit();
        return uninitializerFlag.Raise;
    end);
    local remover = func("A");
    counter.Assert(1, "Initializer called after first insertion");
    local otherRemover = func("B");
    counter.Assert(1, "Initializer is only called once");
    remover();
    Assert.Equals({"B"}, items, "Items contains one call");
    assert(not uninitializerFlag.IsSet(), "Uninitializer is not been called during intermediate removals");
    otherRemover();
    assert(uninitializerFlag.IsSet(), "Uninitializer is called after all elements removed");
    Assert.Equals({}, items, "Items contains nothing");
end;

function Suite:TestActivatorRenews()
    local items = {};
    local startedCounter = Tests.Counter();
    local stoppedCounter = Tests.Counter();
    local func = Functions.Activator(Curry(Lists.Insert, items), function()
        startedCounter.Hit();
        return stoppedCounter.Hit;
    end);
    startedCounter.Assert(0);
    stoppedCounter.Assert(0);
    local remover = func("A");
    startedCounter.Assert(1);
    stoppedCounter.Assert(0);
    remover();
    startedCounter.Assert(1);
    stoppedCounter.Assert(1);
    remover = func("B");
    startedCounter.Assert(2);
    stoppedCounter.Assert(1);
    remover();
    startedCounter.Assert(2);
    stoppedCounter.Assert(2);
end;

