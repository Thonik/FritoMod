if nil ~= require then
    require "fritomod/basic";
    require "fritomod/Metatables";
    require "fritomod/Mixins-Iteration";
    require "fritomod/Lists";
    require "fritomod/Tables";
    require "fritomod/Iterators";
    require "fritomod/OOP";
end;

Strings=Mixins.Iteration();
Strings.__print=print;
Metatables.Defensive(Strings);

function Strings.Iterator(str)
    local k=0;
    return function()
        if k==nil then
            return;
        end;
        k=k+1;
        if k > #str then
            k=nil;
            return nil;
        end;
        return k, Strings.Get(str, k);
    end;
end;

function Strings.KeyIterator(str)
    return Iterators.Counter(#str);
end;

Strings.DIGITS = "0123456789"
Strings.ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
Strings.ALPHANUMERICS = Strings.DIGITS .. Strings.ALPHABET;

function Strings.Matches(str, pattern)
    return Bool(str:find(pattern));
end;

function Strings.IsLetter(letter)
    return Bool(letter:find("^%a*$"));
end;

function Strings.IsNumber(letter)
    return Bool(letter:find("^%d*$"));
end;

function Strings.IsUpper(word)
    if word==nil then
        return false;
    end
    if word:lower() == word:upper() then
        -- It contains no upper or lower-case values, so
        -- it's neither upper nor lower case.
        return false;
    end;
    return word:upper() == word;
end;

function Strings.IsLower(word)
    if word==nil then
        return false;
    end
    if word:lower() == word:upper() then
        -- It contains no upper or lower-case values, so
        -- it's neither upper nor lower case.
        return false;
    end;
    return word:lower() == word;
end;

function Strings.CharAt(str, index)
    local b=str:byte(index);
    if b~=nil then
        return string.char(b);
    end;
end;
Strings.Get=Strings.CharAt;

function Strings.Next(iterable, i)
    if i==nil or i<1 then
        i=0;
    end;
    i=i+1;
    local c=Strings.Get(iterable, i);
    if c then
        return i, c;
    end;
end;

function Strings.Previous(iterable, i)
    if i==nil or i<1 then
        i=0;
    end;
    i=i-1;
    local c=Strings.Get(iterable, i);
    if c then
        return i, c;
    end;
end;

function Strings.Length(iterable)
    return #iterable;
end;

function Strings.Snippet(str, first, last)
    if last==nil then
        return str:sub(first);
    end;
    return str:sub(first, last);
end;

function Strings.StartsWith(str, match)
	assert(type(match) == "string", "match must be a string, got: " .. type(match));
	assert(#match > 0, "match must contain at least one character");
	return match==str:sub(1, #match);
end;

function Strings.EndsWith(str, match)
	assert(type(match) == "string", "match must be a string, got:" .. type(match));
	assert(#match > 0, "match must contain at least one character");
	return match==str:sub(#str-#match+1);
end;

function Strings.Pretty(value)
    if value == nil then
        return "<nil>";
    end;
    local valueType = Strings.ProperNounize(type(value));
    if valueType == "Table" then
        if OOP.IsClass(value) then
            return ("Class@%s"):format(Reference(value));
        end;
        if OOP.IsInstance(value) then
            return value:ToString();
        end;
        if #value > 0 then
            return Strings.PrettyList(value);
        end
        return Strings.PrettyMap(value);
    end;
    local prettyPrinter = Strings["Pretty" .. valueType];
    assert(prettyPrinter, "prettyPrinter not available for type. Type: " .. valueType);
    return prettyPrinter(value);
end;

function Strings.Print(...)
	Strings.__print(Strings.JoinArray(" ", Lists.Map({...}, Strings.Pretty)));
end;
Strings.p=Strings.Print;
dump=Strings.Print

function Strings.PrettyFunction(value)
    assert(type(value) == "function", "value is not a function. Type: " .. type(value));
    local name = Tables.KeyFor(_G, value);
    if not name then
        name = Reference(value);
    end
    return ("Function@%s"):format(name);
end;

function Strings.PrettyNamedNumber(number, itemName, pluralName)
    if not pluralName then
        pluralName = itemName .. "s";
    elseif not Strings.StartsWith(pluralName, itemName) then
        pluralName = itemName + pluralName;
    end;
    local numberString = Strings.PrettyNumber(number);
    if number == 1 then
        return ("%s %s"):format(numberString, itemName);
    end;
    return ("%s %s"):format(numberString, pluralName);
end;

function Strings.PrettyList(value)
    assert(type(value) == "table", "value is not a table. Type: " .. type(value));
    local size = #value;
    if size == 0 then
        return "[<empty>]";
    end;
    local size = Strings.PrettyNamedNumber(Strings.PrettyNumber(size), "item");
    local contents = Lists.Map(value, Strings.Pretty);
    return ("[<%s> %s]"):format(size, Strings.JoinArray(", ", contents));
end;

function Strings.PrettyMap(value)
    assert(type(value) == "table", "value is not a table. Type: " .. type(value));
    local size = Tables.Size(value);
    if size == 0 then
        return "{<empty>}";
    end;
    size = Strings.PrettyNamedNumber(Strings.PrettyNumber(size), "item");
    local contents = Tables.MapPairs(value, function(key, value)
        return ("%s = %s"):format(Strings.Pretty(key), Strings.Pretty(value));
    end);
    return ("[<%s> %s]"):format(size, Strings.JoinArray(", ", contents));
end;

function Strings.PrettyNumber(value)
    local number = tonumber(value);
    if not number then
        return "<NaN>";
    end
    -- TODO Make this add commas
    return tostring(number);
end;

function Strings.PrettyBoolean(value)
    return Strings.ProperNounize(Bool(value));
end;

function Strings.PrettyString(value)
    value = tostring(value);
    return ('%q'):format(value);
end;

function Strings.JoinArray(delimiter, items)
    assert(delimiter ~= nil, "delimiter is nil");
    delimiter = tostring(delimiter);
    return Lists.Reduce(items, "", function(concatted, word)
        while IsCallable(word) do
            word=word();
        end;
        if type(word)=="table" then
            word=Strings.JoinArray(delimiter, word)
        end;
        word = tostring(word);
        if #word == 0 then
            return concatted;
        end;
        if #concatted > 0 then
            return concatted .. delimiter  .. word;
        end;
        return word;
    end);
end

function Strings.JoinValues(delimiter, ...)
    return Strings.JoinArray(delimiter, { ... });
end
Strings.Join=Strings.JoinValues;

-- Splits originalString by the given delimiter.
--
-- delimiter:regex
--     a pattern indicating what defines the "split" characters
-- limit:number
--     optional. the final number of strings that should be returned
-- returns:list
--     a list of strings, split by the specified delimiter
function Strings.SplitByDelimiter(delimiter, originalString, limit)
    if IsCallable(originalString) then
        return Strings.SplitByDelimiter(delimiter, originalString(), limit);
    elseif not IsPrimitive(originalString) then
        error("Unsupported "..type(originalString).." value: "..tostring(originalString));
    end;
    if IsCallable(delimiter) then
        return Strings.SplitByDelimiter(delimiter(), originalString, limit);
    elseif not IsPrimitive(delimiter) then
        error("Unsupported "..type(originalString).." value: "..tostring(originalString));
    end;
    delimiter=tostring(delimiter);
    originalString=tostring(originalString);
    if delimiter=="" then
        return Strings.Array(originalString);
    end;
    local remainder = originalString;
    local items = {};
    while limit == nil or #items + 1 < limit do
        local startMatch, endMatch = remainder:find(delimiter);
        if not startMatch then
            break;
        end;
        if startMatch > 1 then
            Lists.Insert(items, remainder:sub(1, startMatch - 1));
        end;
        remainder = remainder:sub(endMatch + 1);
    end;
    if #remainder > 0 then
        table.insert(items, remainder);
    end;
    if #items == 0 then
        Lists.Insert(items, "");
    end;
    return items;
end;
Strings.Split=Strings.SplitByDelimiter;

function Strings.Array(str)
    local chars={};
    for i=1,#str do
        table.insert(chars, str:sub(i, i));
    end;
    return chars;
end;

-- Removes leading and trailing whitespace from the specified string.
--
-- str:string
--     the string that is the target of this operation
-- returns:string
--     the specified string without leading or trailing whitespace
function Strings.Trim(str)
    str = str:sub(str:find("[^ ]") or #str);
    return str:sub(1, (str:find("[ ]*$" or 1)-1) or #str);
end;

function Strings.ProperNounize(word)
    word = tostring(word);
    return string.upper(string.sub(word, 1, 1)) .. string.lower(string.sub(word, 2));
end;

function Strings.ConvertToBase(base, number, digits)
    digits = digits or Strings.ALPHANUMERICS;
    if base > #digits or base < 2 then
        error("Invalid base: " .. base);
    end;
    local isNegative = number < 0;
    number = math.abs(number);
    local converted = "";
    while number > 0 do
        local place = (number % base) + 1;
        number = math.floor(number / base);
        converted = Strings.CharAt(digits, place) .. converted;
    end
    if #converted == 0 then
        converted = Strings.CharAt(digits, 1);
    end;
    if isNegative then
        converted = "-" .. converted;
    end;
    return converted;
end