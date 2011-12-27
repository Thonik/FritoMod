if nil ~= require then
	require "wow/Frame";
	require "wow/Frame-Events";
end;

local Frame=WoW.Frame;

Frame:AddConstructor(function(self)
	self.shown=true;
end);

function Frame:SetAllPoints()

end;

function Frame:SetPoint()

end;

function Frame:GetNumPoints()

end;

function Frame:SetHeight()

end;

function Frame:GetHeight()

end;

function Frame:SetWidth()

end;

function Frame:GetWidth()

end;

function Frame:Show()
	if not self.shown then
		self.shown=true;
		self:FireEvent("OnShow");
	end;
end;

function Frame:Hide()
	if self.shown then
		self.shown=false;
		self:FireEvent("OnHide");
	end;
end;

function Frame:IsShown()
	return self.shown;
end;

function Frame:SetAlpha()

end;

function Frame:SetFrameStrata()

end;

function Frame:SetParent()

end;

function Frame:SetBackdrop()

end;

function Frame:SetBackdropBorderColor()

end;
