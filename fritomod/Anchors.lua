-- Anchors frames to one another.
--
-- Anchors provides many ways of anchoring frames to one another. It's
-- designed to be as powerful as possible for the client; the flipside
-- is the source here is rather complicated.
--
-- I've divided the functionality into Strategies and Modes. Each Mode
-- provides a different way of anchoring frames. Each Strategy is a
-- single way to anchor them.
--
-- ### MODES
--
-- Currently, the following modes are available:
--
-- #### FLIPPING MODES
--
-- Flipping modes align frames such that they are next to one another.
--
-- Horizontal (H)
-- Anchor frames along the horizontal axis. Corner anchors are aligned
-- horizontally, so you can align a series of frames using their topmost
-- points.
--
-- Vertical (V)
-- Anchor frames along the vertical axis. Corner anchors are aligned
-- vertically, so you can align a series of frames using their left- or
-- rightmost points.
--
-- Diagonal (D)
-- Anchor frames diagonally. This behaves similarly to Horizontal and
-- Vertical for sides (e.g. Left, Top, Right, or Bottom), but corners
-- will be aligned vertically; a series of frames will extend in a
-- diagonal direction from the first frame.
--
-- #### SHARING MODES
--
-- Sharing modes align frames such that they overlap one another.
--
-- ShareInner (S, Shared, Sharing)
-- Frame anchors will be overlapped. This will stack frames on top of
-- one another. Frame insets from backdrops will be respected, causing
-- frames to be stacked within their borders.
--
-- ShareOuter (OS, OuterShared, OuterSharing)
-- Frames will be stacked, similar to ShareInner. However, frame insets
-- are ignored, so frames will be aligned outside their borders.
--
-- ### COMMON ARGUMENTS
--
-- Unless otherwise specified, each function expects arguments in the following
-- order:

-- Anchors.%s(anchorable, anchor, bounds, gapX, gapy)

-- The anchorable may be either a region (or frame), or a UI object. If it's
-- the latter case, then the helper function GetAnchorable is used to deduce
-- a frame.

-- The anchor is the string specifying an anchor for the given anchorable. It
-- will be used to determined the anchorTo point based on the mode's logic. Some
-- strategies do not expect an anchor (the anchor is implied by the function name,
-- as in EdgeSetStrategy)

-- The bounds is used as the reference. Regions and frames are used directly. UI objects
-- will be converted to frames using the helper function GetBounds.

-- The gap should be specified in absolute terms. The sign will be determined
-- using the mode's strategy for aligning frames. For the most part, gap signs
-- will behave as expected.
--
-- ### STRATEGIES

-- The following strategies are available for the above modes. Each strategy
-- adds several functions to Anchors, available by combining the mode name with
-- the strategy. For example, the stacking strategy with the horizontal mode
-- would be Anchors.HStack ( "H" being the mode, and "Stack" being the
-- strategy).

-- All current strategies are described in brief below. Full documentation can
-- be found for each strategy.

-- #### AnchorSetStrategy

-- Aligns two frames using the specified anchor. For flipping modes, the
-- frames will be aligned next to each other, and for sharing modes, the
-- frames will be stacked on top of one another.

-- * Anchors.HAnchorTo, Anchors.HFlipFrom
-- * Anchors.VAnchorTo, Anchors.VFlipFrom
-- * Anchors.DAnchorTo, Anchors.DFlipFrom
-- * Anchors.ShareOuter
-- * Anchors.ShareInner

-- Anchors.HAnchorTo(f, "left", ref)
-- Anchors f's left anchor to ref.
-- +---+---+
-- |ref| f |
-- +---+---+

-- #### ReverseAnchorSetStrategy

-- Aligns two frames using the specified anchor. The specified frames will
-- be aligned next to each other.

-- * Anchors.HFlipOver, Anchors.HFlipTo, Anchors.HFlip
-- * Anchors.VFlipOver, Anchors.VFlipTo, Anchors.VFlip
-- * Anchors.DFlipOver, Anchors.DFlipTo, Anchors.DFlip

-- Anchors.HFlipOver(f, ref, "left");
-- Flips f over ref's left, aligning f to the left of ref.
-- +---+---+
-- | f |ref|
-- +---+---+

-- #### EdgeSetStrategy

-- Aligns two frames using several anchors, collectively called an edge.
-- Flipping anchors will be aligned next to one another, sharing the specified
-- edge. Sharing anchors will be overlapped using the specified edge.

-- * Anchors.HAnchorToLeft
-- * Anchors.VAnchorToLeft
-- * Anchors.DAnchorToLeft
-- * Anchors.ShareLeft
-- * Anchors.ShareOuterLeft

-- Each of the above is also available for the following edges:

-- * Left (topleft, topright)
-- * Right (topright, bottomright)
-- * Top (topleft, topright)
-- * Bottom (bottomleft, bottomright)
-- * All (left, right, top, bottom)
-- * Orthogonal (left, right, top, bottom)
-- * Verticals (top, bottom)
-- * Horizontals (left, right)

-- #### StackStrategy

-- Aligns a series of frames in order. For flipping modes, the frames will
-- be arranged linearly. For sharing modes, the frames will be stacked on
-- top of one another.

-- * Anchors.HStack%s
-- * Anchors.VStack%s
-- * Anchors.DStack%s
-- * Anchors.SStack%s, Anchors.SharedStack%s
-- * Anchors.OSStack%s, Anchors.OuterSharedStack%s

-- ##### Anchors.%sStackTo

-- The frames will be stacked in the specified anchor direction. For example,
-- Anchors.DStackTo("topright", a, b, c) will stack frames in the topright direction,
-- with the last frame becoming the reference frame.

-- local ref = Anchors.HStackTo("right", a, b, c)
-- +---+---+---+
-- | a>| b>| c |
-- +---+---+---+

-- ##### Anchors.%sStackFrom

-- The frames will be stacked similarly to StackTo. However, the first rather than
-- last frame will become the reference frame.

-- local ref = Anchors.HStackFrom("right", a, b, c)
-- +---+---+---+
-- | a |<b |<c |
-- +---+---+---+

-- #### CenterStackStrategy

-- * Anchors.HCStack
-- * Anchors.VCStack
-- * Anchors.CStack

-- Stacks a series of frames in the specified direction, similar to StackStrategy.
-- However, the middle-most frame will become the reference frame.

-- local ref = Anchors.HCStack("right", a, b, c)
-- +---+---+---+
-- | a>| b |<c |
-- +---+---+---+

-- #### JustifyStrategy

-- The frames will be arranged in order, similar to stack. However, the visible
-- order will always match the argument order; the frames will never appear "reverse"

-- Internally, StackStrategy is used to implement justified frames.

-- * Anchors.HJustify%s
-- * Anchors.VJustify%s
-- * Anchors.DJustify%s

-- local ref = Anchors.HJustifyTo("left", a, b, c)
-- +---+---+---+
-- | a |<b |<c |
-- +---+---+---+

-- local ref = Anchors.HJustifyFrom("left", a, b, c)
-- +---+---+---+
-- | a>| b>| c |
-- +---+---+---+

-- #### CJustifyStrategy

-- Justifies a series of frames, similar to JustifyStrategy. However, the central
-- frame will be used as the reference frame. The visible order is identical to
-- JustifyStrategy.

-- local ref = Anchors.HCJustify("right", a, b, c)
-- +---+---+---+
-- | a>| b |<c |
-- +---+---+---+
-- assert(ref == b);

-- local ref = Anchors.HCJustify("left", a, b, c)
-- +---+---+---+
-- | a>| b |<c |
-- +---+---+---+
-- assert(ref == b);

if nil ~= require then
	require "wow/Frame-Layout";
	require "wow/Frame-Container";
	require "fritomod/Strings";
	require "fritomod/Metatables";
end;

Anchors={};

DEBUG_TRACE_ANCHORS = false;

local gtrace = trace;
local function trace(...)
	if DEBUG_TRACE_ANCHORS then
		return gtrace(...);
	end;
end;

-- Converts passed anchor arguments into a canonical form. Anchors allows
-- clients to omit some arguments when it is convenient to do so. I wanted
-- these conversions to be shared across Anchors functions, so this function
-- was written to ensure the conversion is consistent.
local function GetAnchorArguments(frame, ...)
	local anchor, ref, x, y, parent;
	if type(select(1, ...)) == "string" then
		-- Since type() is a C function, it makes a nuisance of itself
		-- by demanding we always pass at least one argument. This is true
		-- even if the argument is nil. Since select(2, ...) can return
		-- nothing, we have to add the "or nil" to the end to be safe.
		if type(select(2, ...) or nil)=="number" then
			anchor, x, y=...;
		else
			anchor, ref, x, y=...;
		end;
	else
		ref, anchor, x, y=...;
	end;
	anchor = anchor:upper();
	if not ref then
		ref = assert(Frames.AsRegion(frame), "Frame or UI object has no parent"):GetParent()
	end;
	return anchor, ref, x, y;
end;

--- Returns an object that may be anchored. Frames, regions, and their subclasses are
--- returned directly.
---
--- UI objects may manage the reanchoring process themselves using an Anchor
--- method.  This Anchor method should expect an anchor name. The UI object is
--- responsible for reanchoring its children relative to the specified anchor
--- name. It is up to the UI object whether this change should result in a
--- visual appearance change or not.
local function GetAnchorable(frame, anchor)
	return Frames.AsRegion(frame) or GetAnchorable(frame:Anchor(anchor), anchor);
end;

-- Returns a region that represents the bounds of the specified object. Frames, regions,
-- and their subclasses will be returned directly.
--
-- UI objects must provid a Bounds method that will return a region that at that corner
-- of the UI object. Anchoring operations will use the returned region as the reference
-- anchor.
--
-- UI objects may also return another UI object. In this case, GetBounds will recurse
-- until a real region is found.
local function GetBounds(frame, anchor)
	return Frames.AsRegion(frame) or GetBounds(frame:Bounds(anchor), anchor);
end;

-- Return the gap and a table containing the frames given in the arguments. This
-- handles a few different styles of arguments for convenience, so it should be used
-- when writing anchor functions that involve multiple frames combined with a gap.
local function GetGapAndFrames(gap, ...)
	local frames;
	if Frames.IsFrame(gap) then
		frames={gap, ...};
		gap=0;
	elseif select("#", ...) == 0 and type(gap) == "table" then
		if Frames.IsFrame(gap) then
			frames = {gap}
		else
			frames = gap;
		end;
		gap=0;
	elseif select("#", ...) == 1 and not Frames.IsFrame(...) then
		frames = ...;
	else
		frames={...};
	end;
	return gap, frames;
end;

-- Insert the specified function into the Anchors table. If format is itself
-- a table, then each entry within format will be used. If name is a table, then
-- each name will also be inserted.
--
-- format (if it is a string) is a format string that will be interpolated
-- using name. This interpolation will serve as the name used within Anchors.
--
-- The curried function will be the value to the interpolated name.
local function InjectIntoAnchors(format, name, func, ...)
	func=Curry(func, ...);
	if type(format) == "table" then
		for i=1, #format do
			InjectIntoAnchors(format[i], name, func);
		end;
		return;
	end;
	if type(name) == "table" then
		for i=1, #name do
			InjectIntoAnchors(format, name[i], func);
		end;
		return;
	end;
	Anchors[format:format(name)] = func;
end;

-- Returns the canonical mode name for the given mode. By convention, the
-- first name within name is the "full" name. (e.g, "Horizontal" for the "H"
-- mode).
local function CanonicalModeName(name)
	if type(name) == "string" then
		return name;
	end;
	return name[1];
end;

local function GapAnchorStrategy(name, signs, masks)
	if IsCallable(signs) then
		InjectIntoAnchors("%sGap", name, signs);
		return;
	end;
	InjectIntoAnchors("%sGap", name, function(anchor, x, y, ref)
		if not x then
			x=0;
		end;
		anchor = tostring(anchor):upper();
		local sign=signs[anchor];
		if not sign then
			assert(
				(x == nil or x == 0) and
				(y == nil or y == 0),
				"Anchor is not supported: "..anchor
			);
			return 0, 0;
		end;
		assert(tonumber(x), "X must be a number. Given: "..tostring(x));
		local sx, sy=unpack(sign);
		if not y then
			y=x;
			local mask;
			if #masks > 0 then
				mask=masks;
			else
				mask=masks[anchor];
			end;
			sx, sy = mask[1] * sx, mask[2] * sy;
		end;
		assert(tonumber(y), "Y must be a number. Given: "..tostring(y));
		return sx * x, sy * y;
	end);
end;

local function AnchorPairStrategy(name, anchorPairs)
	for k,v in pairs(Tables.Clone(anchorPairs)) do
		anchorPairs[v]=k;
	end;

	InjectIntoAnchors("%sAnchorPair", name, function(anchor)
		assert(anchor, "Anchor must not be falsy");
		anchor=anchor:upper();
		return anchorPairs[anchor];
	end);

	InjectIntoAnchors("%sAnchorPairs", name, function()
		return anchorPairs;
	end);
end;

-- A strategy for anchoring frames using the mode's pairing strategy. Flipping
-- modes will cause the two frames to be aligned next to one another. Sharing
-- modes will cause the two frames to be stack on top of one another, with the
-- specified anchor determining where the frames are aligned.  All modes will
-- cause the paired anchors to touch (assuming no gap is specified)

-- Anchors.HFlipFrom(f, "topright", ref) causes f to be flipped over its topright
-- anchor.
-- +---+---+
-- | f |   |
-- +---|ref|
--     |   |
--     +---+
--
--see
--	ReverseAnchorSetStrategy
local function AnchorSetStrategy(name, setVerb)
	if type(setVerb) == "table" then
		for i=1, #setVerb do
			AnchorSetStrategy(name, setVerb[i]);
		end;
		return;
	end;

	local mode = CanonicalModeName(name);
	local Gap = Anchors[mode.."Gap"];
	local AnchorPair = Anchors[mode.."AnchorPair"];

	InjectIntoAnchors(setVerb, name, function(frame, ...)
		local anchor, ref, x, y=GetAnchorArguments(frame, ...);
		local anchorTo = AnchorPair(anchor);
		assert(anchorTo, "Frames cannot be "..mode.." aligned using the "..anchor.." anchor");
		Anchors.Set(frame, anchor, ref, anchorTo, Gap(anchorTo, x, y, ref));
	end);
end;

-- A strategy for anchoring frames using the mode's pairing strategy. This
-- will produce the same set of results as AnchorSetStrategy. However, the
-- anchor pairs are "reversed".

-- For example, the following two lines of code will produce the same result:
-- Anchors.HFlipFrom(f, "topright", ref) causes f to be flipped over its topright
-- anchor.
-- Anchors.HFlipTo(f, ref, "topleft") causes f to be flipped over ref's topleft
-- anchor.
-- +---+---+
-- | f |   |
-- +---|ref|
--     |   |
--     +---+

-- It is up to the client's preference which method is preferred. I personally
-- prefer the reverse anchor strategy.

--see
--	AnchorSetStrategy
local function ReverseAnchorSetStrategy(name, setVerb, reversingVerb)
	if type(setVerb) == "table" then
		for i=1, #setVerb do
			ReverseAnchorSetStrategy(name, setVerb[i], reversingVerb);
		end;
		return;
	end;

	local mode = CanonicalModeName(name);
	local AnchorPair = Anchors[mode.."AnchorPair"];
	local Gap = Anchors[mode.."Gap"];

	if type(reversingVerb) == "table" then
		reversingVerb = reversingVerb[1];
	end;

	InjectIntoAnchors(
		setVerb,
		name,
		function(frame, ...)
			local anchor, ref, x, y=GetAnchorArguments(frame, ...);
			local anchorTo = AnchorPair(anchor);
			assert(anchorTo, "No anchor pair found for "..mode.." set: "..anchor);
			Anchors.Set(frame, anchorTo, ref, anchor, Gap(anchor, x, y, ref));
		end
	);
end;

-- A strategy that sets multiple anchors using the AnchorSetStrategy for the
-- specified mode. This will change the size of the anchoring frame if it
-- differs from the size of the reference frame.
--
-- Anchors.HFlipFromLeft(f, ref)
-- +---+---+
-- |   |   |
-- |ref| f |
-- |   |   |
-- +---+---+
--
-- Anchors.ShareLeft(f, ref)
-- +---+---+
-- | f :   |
-- |and:ref|
-- |ref:   |
-- +---+---+
--
-- I personally only use this strategy for sharing modes.
local function EdgeSetStrategy(name, setVerb)
	local mode = CanonicalModeName(name);

	if type(setVerb) == "table" then
		for i=1, #setVerb do
			EdgeSetStrategy(name, setVerb[i]);
		end;
		return;
	end;
	local SetPoint = Anchors[setVerb:format(mode)];

	local function FlipEdge(...)
		local anchors = {...};
		return function(frame, ref, x, y)
			for i=1, #anchors do
				SetPoint(frame, anchors[i], ref, x, y);
			end;
		end;
	end;
	InjectIntoAnchors(setVerb.."Left",
		name,
		FlipEdge("TOPLEFT", "BOTTOMLEFT")
	);
	InjectIntoAnchors(setVerb.."Right",
		name,
		FlipEdge("TOPRIGHT", "BOTTOMRIGHT")
	);
	InjectIntoAnchors(setVerb.."Top",
		name,
		FlipEdge("TOPLEFT", "TOPRIGHT")
	);
	InjectIntoAnchors(setVerb.."Bottom",
		name,
		FlipEdge("BOTTOMLEFT", "BOTTOMRIGHT")
	);
	InjectIntoAnchors(setVerb.."All",
		name,
		FlipEdge("LEFT", "RIGHT", "TOP", "BOTTOM")
	);
	InjectIntoAnchors(setVerb.."Orthogonal",
		name,
		FlipEdge("LEFT", "RIGHT", "TOP", "BOTTOM")
	);
	InjectIntoAnchors(setVerb.."Diagonals",
		name,
		FlipEdge("TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT")
	);
	InjectIntoAnchors(setVerb.."Verticals",
		name,
		FlipEdge("TOP", "BOTTOM")
	);
	InjectIntoAnchors(setVerb.."Horizontals",
		name,
		FlipEdge("LEFT", "RIGHT")
	);
end;

-- A strategy for lining up a series of frames.
--
-- local ref = Anchors.HStackTo("right", a, b, c)
-- +---+---+---+
-- | a>| b>| c |
-- +---+---+---+
-- For StackTo, the last frame is always the reference frame.
--
-- local ref = Anchors.HStackFrom("right", a, b, c)
-- +---+---+---+
-- | a |<b |<c |
-- +---+---+---+
-- For StackFrom, the first frame is always the reference frame.
--
-- The mode will determine the anchor pairs used for a given anchor.
--
-- Use this if you want to align a series of frames, but don't care about
-- the visible ordering. I rarely use Stack over Justify, since it's very
-- common to expect the visible ordering of frames to be preserved.
local function StackStrategy(name, defaultAnchor)
	local mode = CanonicalModeName(name);

	if type(setVerb) == "table" then
		setVerb = setVerb[1];
	end;
	local FlipTo = Anchors[mode.."FlipTo"];
	local AnchorPair = Anchors[mode.."AnchorPair"];

	local function Stack(towardsFirst, anchor, gap, ...)
		anchor=anchor:upper();
		if anchor == "CENTER" and defaultAnchor then
			local CStack = Anchors[mode.."CStack"];
			return CStack(defaultAnchor, ...);
		end;
		local frames;
		gap, frames = GetGapAndFrames(gap, ...);
		local marcher=Lists.March;
		if towardsFirst then
			-- We want A<B<C (stack from the right), so we need to reverse-march
			-- so we get the following moves:
			--
			-- Flip(C, B)
			-- Flip(B, A)
			--
			-- This is a reverse march, with the "first" frame being the anchor
			-- (or reference).
			--
			-- We don't need to get the paired anchor, since each subsequent frame
			-- will be flipped over the previous frame's point.
			marcher=Lists.ReverseMarch;
		else
			-- We want A>B>C (stack to the right). This is accomplished by:
			-- Flip(A, B)
			-- Flip(B, C)
			--
			-- Each subsequent frame is to the right of the previous frame,
			-- with the last frame being the anchor (or reference).
			--
			-- We need to get the paired anchor, since the flips are based off
			-- the reference's opposing anchor.
			anchor=AnchorPair(anchor);
		end;
		local i=1;
		return marcher(frames, function(first, second)
			local thisGap = gap;
			if IsCallable(thisGap) then
				thisGap = thisGap(first, second);
			elseif type(thisGap) == "table" and #thisGap > 0 then
				thisGap = thisGap[1 + (i % #thisGap)]
				i=i + 1;
			end;
			FlipTo(first, second, anchor, thisGap);
		end);
	end
	InjectIntoAnchors({
			"%sStack",
			"%sStackTo"
		},
		name,
		Curry(Stack, false)
	);

	local AnchorPair = Anchors[CanonicalModeName(name) .. "AnchorPair"];

	InjectIntoAnchors(
		"%sStackFrom",
		name,
		Curry(Stack, true)
	);
end;

-- A strategy for "lining up" a series of frames, ensuring the middle frame
-- is always the reference frame.
--
-- local ref = Anchors.HCStack("right", a, b, c)
-- +---+---+---+
-- | a>| b |<c |
-- +---+---+---+
--
-- local ref = Anchors.HCStack("left", a, b, c)
-- +---+---+---+
-- | c>| b |<a |
-- +---+---+---+
--
-- The visible order of the frames will match the ordering produced by StackTo,
-- however the anchoring will always place the middle frame as the reference
-- frame.
--
-- Personally, I rarely use CStack directly. It's more often used as a result of
-- CJustify.
local function CenterStackStrategy(name)
	local mode = CanonicalModeName(name);
	local StackFrom = Anchors[mode.."StackFrom"];
	local StackTo = Anchors[mode.."StackTo"];

	InjectIntoAnchors({
			"%sCStack",
			"%sCenterStack",
		},
		name,
		function(anchor, gap, ...)
			anchor=anchor:upper();
			local gap, frames = GetGapAndFrames(gap, ...);
			local count = #frames;
			local mid;
			if count % 2 == 0 then
				-- We have an even number of frames, so
				-- we need to pick one arbitrarily to be
				-- the "middle".
				mid = count / 2;
			else
				mid = (count + 1) / 2;
			end;
			-- Align the leading slice
			StackTo(anchor, gap,
				Lists.Slice(frames, 1, mid));
			-- Align the trailing slice
			StackFrom(anchor, gap,
				Lists.Slice(frames, mid, #frames));
			-- Return the middle
			return frames[mid];
		end
	);
end;

-- A strategy for lining up a series of frames, with the ordering of frames
-- always matching the ordering of the arguments.
--
-- local ref = Anchors.HJustifyTo("right", a, b, c)
-- +---+---+---+
-- | a>| b>| c |
-- +---+---+---+
--
-- local ref = Anchors.HJustifyTo("left", a, b, c)
-- +---+---+---+
-- | a |<b |<c |
-- +---+---+---+
--
-- Observe how the specified ordering is preserved in the visible ordering
-- of the frames. This differs from StackTo:
-- local ref = Anchors.HStackTo("left", a, b, c)
-- +---+---+---+
-- | c |<b |<a |
-- +---+---+---+
--
-- local ref = Anchors.HJustifyFrom("right", a, b, c)
-- +---+---+---+
-- | a |<b |<c |
-- +---+---+---+
-- This invocation behaves identically to Anchors.HJustifyto("left", a, b, c)
--
-- Use justify when you always want the visible ordering to be in a specified
-- order, regardless of where the frames are aligned. The frames will be aligned
-- lexicographically, with left-to-right and top-to-bottom being preferred.
local function JustifyStrategy(name, reverseJustify, defaultAnchor)
	local mode = CanonicalModeName(name);
	local AnchorPair = Anchors[mode.."AnchorPair"];

	local StackTo = Anchors[mode.."StackTo"];
	local StackFrom = Anchors[mode.."StackFrom"];

	InjectIntoAnchors({
			"%sJustify",
			"%sJustifyTo"
		},
		name,
		function(anchor, ...)
			anchor=anchor:upper();
			if anchor == "CENTER" and defaultAnchor then
				local CJustify = Anchors[mode.."CJustify"];
				return CJustify(defaultAnchor, ...);
			end;
			if reverseJustify[anchor] then
				return StackFrom(AnchorPair(anchor), ...);
			end;
			return StackTo(anchor, ...);
		end
	);
	InjectIntoAnchors(
		"%sJustifyFrom",
		name,
		function(anchor, ...)
			anchor=anchor:upper();
			if anchor == "CENTER" and defaultAnchor then
				local CJustify = Anchors[mode.."CJustify"];
				return CJustify(defaultAnchor, ...);
			end;
			if reverseJustify[anchor] then
				return StackTo(AnchorPair(anchor), ...);
			end;
			return StackFrom(anchor, ...);
		end
	);
end;

-- Justifies a series of frames, with the central frame being used as
-- the reference. This will produce visibily identical results to Justify,
-- but the central frame will be used as the reference frame in all cases.
--
-- Anchors.HCJustify("right", a, b, c)
-- +---+---+---+
-- | a>| b |<c |
-- +---+---+---+
--
-- Anchors.HCJustify("left", a, b, c)
-- +---+---+---+
-- | a>| b |<c |
-- +---+---+---+
--
-- As you can see, when CJustify is used, the anchor provided specifies very
-- little. For example, for HCJustify, "right" and "left" produce identical
-- results: the frames are aligned such that their centers are vertically aligned.
-- If "topright" or "topleft" are given, then the topmost anchors are vertically
-- aligned.
--
-- I use CJustify when I want to perform two alignments. I want to vertically
-- align a series of UI objects. Each UI object is comprised of a number of
-- horizontally-aligned regions. I want the UI objects to be vertically aligned
-- using a central axis. Such an alignment is shown below:
--
--    Foo [ ] Onyxia
-- Edward [ ] Ragnaros
--   Karl [ ] Nefarian
--
-- In this case, each UI object (a line comprised of two names and an icon) must
-- be centrally stacked. I don't want the visible order to change, so I use justify.
-- The following code is called within UI object:
--
-- Anchors.HCJustify("right", sourceName, icon, targetName)
--
-- I want each UI object to be vertically aligned, so I need a stack or a justify.
-- I also want the visible ordering to be consistent, regardless of whether I use
-- the first or the last frame as the reference for the whole list, so I need to
-- use justify.
--
-- local ref = Anchors.VJustify("top", foo, edward, karl);
-- assert(ref == foo, "foo is the reference frame");
local function CenterJustifyStrategy(name, reverseJustify)
	local mode = CanonicalModeName(name);
	local AnchorPair = Anchors[mode.."AnchorPair"];
	local CStack = Anchors[mode.."CStack"];

	InjectIntoAnchors({
			"%sCJustify",
			"%sCenterJustify",
		},
		name,
		function(anchor, ...)
			anchor=anchor:upper();
			if reverseJustify[anchor] then
				return CStack(AnchorPair(anchor), ...);
			end;
			return CStack(anchor, ...);
		end
	);
end;


local modes = {};

-- Anchors.HorizontalFlip(f, "TOPRIGHT", ref);
-- +---+---+
-- |   | f |
-- |ref|---+
-- |   |
-- +---+
--
-- Anchors.HorizontalFlip(f, "RIGHT", ref);
-- +---+
-- |   |---+
-- |ref| f |
-- |   |---+
-- +---+
--
-- Anchors.HorizontalFlip(f, "BOTTOMRIGHT", ref);
-- +---+
-- |   |
-- |ref|---+
-- |   | f |
-- +---+---+
--
-- Anchors.HorizontalFlip(f, "TOPLEFT", ref);
-- +---+---+
-- | f |   |
-- +---|ref|
--     |   |
--     +---+
--
-- Anchors.HorizontalFlip(f, "LEFT", ref);
--     +---+
-- +---|   |
-- | f |ref|
-- +---|   |
--     +---+
--
-- Anchors.HorizontalFlip(f, "BOTTOMLEFT", ref);
--     +---+
--     |   |
-- +---|ref|
-- | f |   |
-- +---+---+

modes.Horizontal = {
	name = {"Horizontal", "H"},
	gapSigns = {
		TOPRIGHT	=  {  1,  1 },
		RIGHT	   =  {  1,  1 },
		BOTTOMRIGHT =  {  1, -1 },
		BOTTOMLEFT  =  { -1, -1 },
		LEFT		=  { -1,  1 },
		TOPLEFT	 =  { -1,  1 }
	},
	gapMask = { 1, 0 },
	anchorPairs = {
		TOPLEFT	= "TOPRIGHT",
		BOTTOMLEFT = "BOTTOMRIGHT",
		LEFT	   = "RIGHT"
	},
	setVerb = "%sFlipFrom",
	reverseSetVerb = { "%sFlipTo", "%sFlip" },
	reverseJustify = {
		TOPLEFT = true,
		LEFT = true,
		BOTTOMLEFT = true
	},
	defaultAnchor = "RIGHT"
};

-- Anchors.VerticalFlip(f, "BOTTOMLEFT", ref);
-- +-------+
-- |  ref  |
-- +-------+
-- | f |
-- +---+
--
-- Anchors.VerticalFlip(f, "BOTTOM", ref);
-- +-------+
-- |  ref  |
-- +-------+
--   | f |
--   +---+
--
-- Anchors.VerticalFlip(f, "BOTTOMRIGHT", ref);
-- +-------+
-- |  ref  |
-- +-------+
--     | f |
--     +---+
--
-- Anchors.VerticalFlip(f, "TOPLEFT", ref);
-- +---+
-- | f |
-- +-------+
-- |  ref  |
-- +-------+
--
-- Anchors.VerticalFlip(f, "TOP", ref);
--   +---+
--   | f |
-- +-------+
-- |  ref  |
-- +-------+
--
-- Anchors.VerticalFlip(f, "TOPRIGHT", ref);
--     +---+
--     | f |
-- +-------+
-- |  ref  |
-- +-------+

modes.Vertical = {
	name = {"Vertical", "V"},
	gapSigns = {
		TOPRIGHT	=  {  1,  1 },
		TOP		 =  {  1,  1 },
		TOPLEFT	 =  { -1,  1 },
		BOTTOMRIGHT =  {  1, -1 },
		BOTTOM	  =  {  1, -1 },
		BOTTOMLEFT  =  { -1, -1 }
	},
	gapMask = { 0, 1 },
	anchorPairs = {
		BOTTOMRIGHT = "TOPRIGHT",
		BOTTOMLEFT  = "TOPLEFT",
		BOTTOM	  = "TOP"
	},
	setVerb = "%sFlipFrom",
	reverseSetVerb = { "%sFlipTo", "%sFlip" },
	reverseJustify = {
		TOPLEFT = true,
		TOP = true,
		TOPRIGHT = true
	},
	defaultAnchor = "BOTTOM"
};

-- "frame touches ref's anchor."
--
-- frame will be "flipped" over the reference frame. The centers of the two frames
-- will form a line that passes through the anchor.
-- Given a single number, convert it to the appropriate direction depending on
-- what anchor is used.
--
-- Positive gap values will increase the distance between frames.
-- Negative gap values will decrease the distance between frames.
--
-- The centers will form a line that passes through the anchor; diagonal anchor
-- points will cause the frames to separate diagonally.
--
-- Anchors.DiagonalFlip(f, "TOPLEFT", ref);
-- +---+
-- | f |
-- +---+---+
--     |ref|
--     +---+
--
-- Anchors.DiagonalFlip(f, "TOP", ref);
-- +---+
-- | f |
-- +---+
-- |ref|
-- +---+
--
-- Anchors.DiagonalFlip(f, "TOPRIGHT", ref);
--     +---+
--     | f |
-- +---+---+
-- |ref|
-- +---+
--
-- Anchors.DiagonalFlip(f, "RIGHT", ref);
-- +---+---+
-- |ref| f |
-- +---+---+
--
--
-- Anchors.DiagonalFlip(f, "BOTTOMRIGHT", ref);
-- +---+
-- |ref|
-- +---+---+
--     | f |
--     +---+
--
-- Anchors.DiagonalFlip(f, "BOTTOM", ref);
-- +---+
-- |ref|
-- +---+
-- | f |
-- +---+
--
-- Anchors.DiagonalFlip(f, "BOTTOMLEFT", ref);
--     +---+
--     |ref|
-- +---+---+
-- | f |
-- +---+
--
-- Anchors.DiagonalFlip(f, "LEFT", ref);
-- +---+---+
-- | f |ref|
-- +---+---+

modes.Diagonal = {
	name = {
		"Diagonal",
		"D",
		""
	},
	gapSigns = {
		TOP		 = {  1,  1 },
		TOPRIGHT	= {  1,  1 },
		RIGHT	   = {  1,  1 },
		BOTTOMRIGHT = {  1, -1 },
		BOTTOM	  = {  1, -1 },
		BOTTOMLEFT  = { -1, -1 },
		LEFT		= { -1, -1 },
		TOPLEFT	 = { -1,  1 },
	},
	gapMask = {
		TOP		 = {  0,  1 },
		TOPRIGHT	= {  1,  1 },
		RIGHT	   = {  1,  0 },
		BOTTOMRIGHT = {  1,  1 },
		BOTTOM	  = {  0,  1 },
		BOTTOMLEFT  = {  1,  1 },
		LEFT		= {  1,  0 },
		TOPLEFT	 = {  1,  1 },
	},
	anchorPairs = {
		TOP	  = "BOTTOM",
		RIGHT	= "LEFT",
		TOPLEFT  = "BOTTOMRIGHT",
		TOPRIGHT = "BOTTOMLEFT",
	},
	setVerb = "%sFlipFrom",
	reverseSetVerb = { "%sFlipTo", "%sFlip" },
	reverseJustify = {
		TOP = true,
		TOPLEFT = true,
		LEFT = true,
		BOTTOMLEFT = true,
	},
	defaultAnchor = "RIGHT"
};

modes.ShareInner = {
	name = {
		"Shared",
		"Sharing",
		"S",
	},
	gapSigns = function(anchor, x, y, ref)
		anchor=tostring(anchor):upper();
		assert(ref, "Reference frame must be provided for determining gap strategy");
		local insets=Frames.Insets(ref);
		if insets.top > 0 and Strings.StartsWith(anchor, "TOP") then
			y=y or 0;
			y=y+insets.top;
		elseif insets.bottom > 0 and Strings.StartsWith(anchor, "BOTTOM") then
			y=y or 0;
			y=y+insets.bottom;
		end;
		if insets.left > 0 and Strings.EndsWith(anchor, "LEFT") then
			x=x or 0;
			x=x+insets.left;
		elseif insets.right > 0 and Strings.EndsWith(anchor, "RIGHT") then
			x=x or 0;
			x=x+insets.right;
		end;
		if x ~= nil then
			x=-x;
		end;
		if y ~= nil then
			y=-y;
		end;
		return Anchors.DiagonalGap(anchor, x, y);
	end,
	anchorPairs = {
		RIGHT  = "RIGHT",
		TOPRIGHT  = "TOPRIGHT",
		TOP = "TOP",
		TOPLEFT  = "TOPLEFT",
		BOTTOMRIGHT  = "BOTTOMRIGHT",
		BOTTOM = "BOTTOM",
		BOTTOMLEFT  = "BOTTOMLEFT",
		LEFT  = "LEFT",
		CENTER = "CENTER",
	},
	setVerb = {"Share", "ShareInner"},
};

modes.ShareOuter = setmetatable({
		name = {
			"OuterShared",
			"OuterSharing",
			"OS"
		},
		setVerb = "ShareOuter",
		gapSigns = function(anchor, x, y, ref)
			if x ~= nil then
				x=-x;
			end;
			if y ~= nil then
				y=-y;
			end;
			return Anchors.DiagonalGap(anchor, x, y);
		end
	}, {
		__index = modes.ShareInner
});

for _, strategy in pairs(modes) do
	local name = strategy.name;
	GapAnchorStrategy(
		name,
		strategy.gapSigns,
		strategy.gapMask
	);
	AnchorPairStrategy(name, strategy.anchorPairs);
	AnchorSetStrategy(name, strategy.setVerb);
	if strategy.reverseSetVerb then
		ReverseAnchorSetStrategy(name,
			strategy.reverseSetVerb,
			strategy.setVerb);
	end;
	EdgeSetStrategy(name, strategy.setVerb);
	StackStrategy(name, strategy.defaultAnchor);
	CenterStackStrategy(name);

	strategy.reverseJustify = strategy.reverseJustify or {};
	JustifyStrategy(name, strategy.reverseJustify, strategy.defaultAnchor);
	CenterJustifyStrategy(name, strategy.reverseJustify);
end;

-- Tweak some default functions for least-surprise usage.
Anchors.FlipTop   =Anchors.VFlipTop;
Anchors.FlipBottom=Anchors.VFlipBottom;

Anchors.FlipLeft =Anchors.HFlipLeft;
Anchors.FlipRight=Anchors.HFlipRight;

function Anchors.Center(frame, ref)
	return Anchors.Share(frame, ref, "CENTER");
end;

function Anchors.Set(frame, anchor, ref, anchorTo, x, y)
	anchor=anchor:upper();
	anchorTo=anchorTo:upper();
	local region = GetAnchorable(frame, anchor);
	assert(Frames.IsRegion(region), "frame must be a frame. Got: "..type(region));
	ref=GetBounds(ref or region:GetParent(), anchorTo);
	assert(Frames.IsRegion(ref), "ref must be a frame. Got: "..type(ref));
	x = x or 0;
	y = y or 0;
	if DEBUG_TRACE_ANCHORS then
		trace("%s:SetPoint(%q, %s, %q, %d, %d)",
			tostring(region),
			anchor,
			tostring(ref),
			anchorTo,
			x,
			y
		);
	end;
	region:SetPoint(anchor, ref, anchorTo, x, y);
end;

function Anchors.Clear(...)
	if select("#", ...) == 1 and #(...) > 0 then
		trace("Unpacking list for clearing")
		return Anchors.Clear(unpack(...));
	end;
	for i=1, select("#", ...) do
		local frame = select(i, ...);
		if frame then
			Frames.AsRegion(frame):ClearAllPoints();
		end;
	end;
end;
