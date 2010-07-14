if nil ~= require then
	require "WoW_Player/Player";
	require "WoW_Spells/Spell";

	require "FritoMod_UI/Stage";
	require "FritoMod_UI/TextField";

	require "FritoMod_UI_Tests/CreateUITestSuite";
end;

local Suite=CreateUITestSuite("FritoMod_UI/Box");
local s=Stage.GetInstance();

function Suite:TestNeatSpellbook()
	local vbox = Box:New();
	vbox:SetDirection("vertical");
	local spells,i,hbox={},1;
	while true do
		local spellName = GetSpellName(i, BOOKTYPE_SPELL)
		if not spellName then
			break;
		end
		if not spells[spellName] then
			spells[spellName] = true;
			if not hbox or hbox:GetNumChildren()>10 then
				hbox = Box:New();
				vbox:AddChild(hbox);
				i=0;
			end;
			local b=Button:New();
			b:SetSpell(spellName);
			b:SetTexture(GetSpellTexture(spellName));
			hbox:AddChild(b);
		end;
		i=i+1;
	end
	s:AddChild(vbox);
	s:ValidateNow();
end;

function Suite:TestBuffs()
	local vbox = Box:New();
	vbox:SetDirection("vertical");
	local i=1;
	while true do
		local name, _, icon = UnitBuff("player", i);
		if not icon then
			break;
		end;
		local hbox=Box:New();
		local b=Button:New();
		b:SetTexture(icon);
		hbox:AddChild(b);
		hbox:SetAlignment("center");
		hbox:AddChild(TextField:New(name));
		vbox:AddChild(hbox);
		i=i+1;
	end;
	s:AddChild(vbox);
	s:ValidateNow();
end;
