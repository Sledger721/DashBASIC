 -- Dash BASIC
--For each var, function or class added, throw it in a table.
--STILL NEED TO TRIM WHITESPACE
--
--

base_functions=[[ -- BASE FUNCTIONS OF DASHBASIC BEGINNING.
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
]]

words={}
data={}
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
function writeLua(str)
	out:write(str..'\n')
end
function trim(s)
return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end
function process(data) -- WORD ARGA,ARGB,ARGC ; words[1]='WORD', args[1]='ARGA', args[2]='ARGB', etc.
  if string.find(data,' ') then
	words=split(data," ")
	args=split(words[2],",")
		if words[1]=='PRINT' then
			trimmed=string.sub(data,7)
			writeLua('print('..trimmed..')')
		elseif words[1]=='SET' then
			vars={}
			vars=split(words[2],"=")
			writeLua(vars[1]..'='..vars[2])
			print(vars[1]..'|'..vars[2])
		elseif words[1]=='REM' then
			writeLua('--'..words[2])
			print('Comment|'..string.sub(data,5))
		elseif words[1]=='DIM' then
			writeLua(words[2]..'={}')
		elseif words[1]=='FUNCTION' then -- FUNCTION NAME:arga,argb,etc
			parse={}
			parse=split(words[2],':')
				writeLua('function '..parse[1]..'('..parse[2]..')')
		elseif words[1]=='INPUT' then
			writeLua(words[2]..'=io.read()')
		elseif words[1]=='FOR' then
			writeLua('for '..words[2]..' do')
		elseif words[1]=='UNTIL' then
			writeLua('until '..words[2])
		elseif words[1]=='WHILE' then
			writeLua('while '..words[2]..' do')
		elseif words[1]=='IF' then
			writeLua('if '..words[2]..' then')
		elseif words[1]=='ELSEIF' then
			writeLua('elseif '..words[2])
		elseif words[1]=='CLASS' then -- CLASS NAME:PARENT
			parse={}
				if string.find(words[2],':') then 
					parse=split(words[2],':')
					writeLua(parse[1]..'=class('..parse[2]..')')
				else
					writeLua(words[2]..'=class()')
				end
		elseif words[1]=='CALL' then -- CALL path/to/module OR_IT_CAN_BE CALL reference_variable path/to/module
			writeLua("require '"..words[2].."'")
				if words[3]~=nil then
					writeLua(words[2].." require '"..words[3].."'")	
				end
		elseif words[1]=='RETURN' then
			writeLua('return '..words[2]
		end
  else	
	if data=='END' then
		writeLua('end')
	elseif data=='REPEAT' then
		writeLua('repeat')
	elseif data=='ELSE' then
		writeLua('else')
	elseif data=='MODULE' then
		writeLua('module(..., package.seeall);')
	end
  end
end
function compilation(name)
	a=io.open(name..'.lua','r')
	contents=a:read('*all')
	a:close()
	
	o=io.open(name..'_bytecode.lua','wb')
	code=assert(loadstring(contents))
	o:write(string.dump(code))
	o:close()
end
function init()
  print("Enter name of file to input from:")
   inFile=io.read()
  print("Enter name of file to ouput too:")
   outFile=io.read()
   outFile='Output/'..outFile
	f=io.open(inFile,'r')
	out=io.open(outFile..'.lua','w')
	contents=f:read("*all")
	f:close()
		data=split(contents,"\n")
		  writeLua(base_functions)
		  writeLua(base_api_functions)
			for i=1,#data do
				data[i]=trim(data[i])
				print("Processing Line: "..i)
				process(tostring(data[i]))
			end
				compilation(outFile)
end

init()