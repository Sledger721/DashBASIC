This is simply a small, primitive BASIC dialect that was written up in Lua and transpiles out to raw Lua source-code and Lua bytecode. Run the DashBASIC.lua program, it's quite self-explanatory once running in a default Lua console. Also, all functions are the same as Lua. As you may see if you dig around the transpiler, you can simply: 'SET myVar=anyLuaFunction(1,2,3)' and it will call that Lua function accordingly. I see this having quite a strong use as perhaps a domain-specific language or for beginners.