if nil ~= require then
    require "hack/Connectors";
    require "hack/Assets";
end;

local Suite = CreateTestSuite("hack.Script");

local Connectors = Hack.Connectors;
local Assets = Hack.Assets;

function Suite:TestScript()
    local script = Hack.Script:New();

    script:AddConnector(Connectors.Global("bar", Assets.Flag()));

    script:SetContent([[
        bar.Raise();
        foo = 42;
    ]]);

    script:Execute();

    local env = script:GetEnvironment();
    Assert.Equals(42, env:Get("foo"));

    local flag = env:Get("bar");
    flag:Assert();

    script:Destroy();

    flag:AssertUnset();
end;
