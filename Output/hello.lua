 -- BASE FUNCTIONS OF DASHBASIC BEGINNING.
function class(base, init)
local c = {}    -- a new class instance
if not init and type(base) == 'function' then
init = base
base = nil
elseif type(base) == 'table' then
-- our new class is a shallow copy of the base class!
for i,v in pairs(base) do
c[i] = v
end
c._base = base
end
-- the class will be the metatable for all its objects,
-- and they will look up their methods in it.
c.__index = c
 -- expose a constructor which can be called by <classname>(<args>)
local mt = {}
mt.__call = function(class_tbl, ...)
local obj = {}
setmetatable(obj,c)
if init then
init(obj,...)
else 
-- make sure that any stuff from the base class is initialized!
if base and base.init then
base.init(obj, ...)
end
end
return obj
end
c.init = init
c.is_a = function(self, klass)
local m = getmetatable(self)
while m do 
if m == klass then return true end
m = m._base
end
return false
end
setmetatable(c, mt)
return c
end
function split(str, pat)
local t = {}  -- NOTE: use {n = 0} in Lua-5.0
local fpat = "(.-)" .. pat
local last_end = 1
local s, e, cap = str:find(fpat, 1)
while s do
if s ~= 1 or cap ~= "" then
table.insert(t,cap)
end
last_end = e+1
s, e, cap = str:find(fpat, last_end)
end
if last_end <= #str then
cap = str:sub(last_end)
table.insert(t, cap)
end
return t
end
 -- BASE FUNCTIONS OF DASHBASIC ENDING.

print('Hello World!')
