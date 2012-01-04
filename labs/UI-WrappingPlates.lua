if nil ~= require then
	require "wow/api/Frame";
	require "wow/FontString";

	require "fritomod/OOP-Class";
	require "fritomod/Frames";
	require "fritomod/Anchors";
	require "fritomod/Lists";
	require "fritomod/Tables";
end;

UI = UI or {};

WrappingPlates = OOP.Class();
UI.WrappingPlates = WrappingPlates;

function WrappingPlates:Constructor()
	self.children = {};
	self.currentFrame = 0;
end;

function WrappingPlates:Get(index)
	assert(#self.children > 0, "No children present!");
	return self.children[self:Index(index)];
end;

function WrappingPlates:Current()
	return self:Get(self.currentFrame);
end;

function WrappingPlates:Next()
	return self:Get(self.currentFrame + 1)
end;

function WrappingPlates:Previous()
	return self:Get(self.currentFrame - 1)
end;

function WrappingPlates:Index(index)
	index = index or self.currentFrame;
	return (index % #self.children) + 1;
end;

function WrappingPlates:Add(child)
	table.insert(self.children, child);
end;

function WrappingPlates:Set(...)
	self.currentFrame = self.currentFrame + 1;
	local child = self:Get();
	child:Set(...);
	if self.anchor then
		-- We wrapped so rearrange
		-- TODO Reenable this wrapping
		--Anchors.Share(self:Next(), self, self.anchor);
		--Anchors.HFlip(self:Current(), self:Previous(), self.anchor, 12);
	else
		trace("No anchor, just setting for now");
	end;
end;

function WrappingPlates:Anchor(anchor)
	trace("Anchoring WrappingPlates to: "..anchor);
	self.anchor = anchor;
	local orderedChildren = Tables.Clone(self.children);
	Lists.Rotate(orderedChildren, self:Index());
	return Anchors.HJustifyFrom(anchor, 10, orderedChildren);
end;

function WrappingPlates:Destroy()
	Lists.Each(self.children, Frames.Destroy);
end;
