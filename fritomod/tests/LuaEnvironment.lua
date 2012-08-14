local Suite = CreateTestSuite("fritomod.LuaEnvironment");

do
    local g1, g2, g3;
    Suite:AddListener(Metatables.Noop({
        TestStarted = function(self, suite)
            g1 = __g1;
            g2 = __g2;
            g3 = __g3;
        end,
        TestFinished = function(self, suite)
            __g1 = g1;
            __g2 = g2;
            __g3 = g3;
        end
    }));
end;

function Suite:TestGlobalEnvironmentIsClean()
    Assert.Nil(__g1);
    Assert.Nil(__g2);
    Assert.Nil(__g3);
end;

function Suite:TestSimpleEnvironment()
    local env = LuaEnvironment:New();
    env:Set("__g1", 42);
    Assert.Nil(__g1);
    Assert.Equals(42, env:Get("__g1"));
end;

function Suite:TestLuaEnvironmentShieldsGlobals()
    local env = LuaEnvironment:New();
    env:Run(function()
        __g1 = 43;
    end);
    Assert.Nil(__g1);
    Assert.Equals(43, env:Get("__g1"));
end;

function Suite:TestLuaEnvironmentAcceptsStrings()
    local env = LuaEnvironment:New();
    env:Run([[
        __g1 = 44;
    ]]);
    Assert.Nil(__g1);
    Assert.Equals(44, env:Get("__g1"));
end;

function Suite:TestLuaEnvCanUndoChange()
    local env = LuaEnvironment:New();
    env:Set("foo", 24);
    Assert.Equals(24, env:Get("foo"), "Original value set");
    local undo = env:Change("foo", 25);
    Assert.Equals(25, env:Get("foo"), "Value changed");
    undo();
    Assert.Equals(24, env:Get("foo"), "Original value reset");
    env:Set("foo", 26);
    undo();
    Assert.Equals(26, env:Get("foo"), "Undo only works once");
end;

function Suite:TestLuaEnvironmentAcceptsLazyValues()
    local env = LuaEnvironment:New();
    local counter = Tests.Counter(0);
    env:Lazy("lazy", function(name)
        Assert.Equals("lazy", name);
        counter.Hit();
        return 45;
    end);

    local Assert = Assert;
    env:Run(function()
        Assert.Equals(45, lazy);
    end);
    Assert.Nil(lazy);

    Assert.Equals(45, env:Get("lazy"));
    counter.Assert(1);
    Assert.Equals(45, env:Get("lazy"));
    counter.Assert(1);

end;

function Suite:TestLuaEnvironmentAcceptsProxies()
    local env = LuaEnvironment:New();
    local counter = Tests.Counter(0);
    local v = 2;
    env:Proxy("proxy", function(name)
        Assert.Equals("proxy", name);
        counter.Hit();
        v = v + 2;
        return v;
    end);
    Assert.Equals(4, env:Get("proxy"));
    counter.Assert(1);
    Assert.Equals(6, env:Get("proxy"));
    counter.Assert(2);

    local Assert = Assert;
    env:Run(function()
        Assert.Equals(8, proxy);
    end);
end;

function Suite:TestLuaEnvironmentSupportsTableInjection()
    local env = LuaEnvironment:New();

    local injected = {
        foo = 37
    };

    env:Inject(injected);
    env:Inject(function(name)
        if name == "bar" then
            return 38;
        end;
    end);

    local f = Tests.Flag();
    local Assert = Assert;
    env:Run(function()
        Assert.Equals(37, foo);
        Assert.Equals(38, bar);
        f.Raise();
    end);
    f.Assert();
end;

function Suite:TestLuaEnvironmentCanRetrieveValuesFromParents()
    local parent = LuaEnvironment:New();

    local child = LuaEnvironment:New({}, parent);

    parent:Set("foo", 97);
    Assert.Equals(97, child:Get("foo"));
end;

function Suite:TestLuaEnvironmentCanRetrieveValuesFromParents()
    local parent = LuaEnvironment:New();

    local child = LuaEnvironment:New({}, parent);
    child:Set("foo", 45);

    child:Export("foo");

    Assert.Equals(45, parent:Get("foo"));
    Assert.Equals(45, child:Get("foo"));

    local remover = child:Change("foo", 47);
    Assert.Equals(47, parent:Get("foo"));
    Assert.Equals(47, child:Get("foo"));
    remover();
    Assert.Equals(45, parent:Get("foo"));
    Assert.Equals(45, child:Get("foo"));
end;



-- vim: set et :
