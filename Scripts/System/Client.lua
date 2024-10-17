setConsoleBufferSize("main", 1000000, 1000) -- Extends buffer to actually be useful and not five lines long.

---
  
createMapper(0, 0, 455, 460) -- Self-explained. Makes a mapper miniConsole open to manipulation.
  
setMapZoom(25) -- Preference. Just right for me, depends on screen size.
  
---
  
createConsole("chatConsole", 8, 55, 38, 1480, 369) -- This and the rest below are regarding communication capture. Yes, I am pixel specific. It is dumb.
  
function onProtocolEnabled(_, protocol)
  if protocol == "GMCP" then
    sendGMCP([[ Core.Supports.Add ["Comm.Channel 1"] ]])
  end
end
  
registerAnonymousEventHandler("sysProtocolEnabled", "onProtocolEnabled")
  
function digestChat()
  local ANSI, MXP = rex.new("\\e\\[(\\d+;)*\\d+m"), rex.new("\\e\\[4z\\x3\.+?\\x4")
  local text = rex.gsub(ansi2decho(gmcp.Comm.Channel.Text.text), MXP, "")
  
  if not gmcp.Comm.Channel.Text.channel:find("Homunculus") then -- Easy to add exceptions for spam from denizens, mobs, people, etc. Below is the only one I have at this time.
		decho("chatConsole", "<255,255,255:0,0,0>- "..text.."\n")
	end
end
  
registerAnonymousEventHandler("gmcp.Comm.Channel.Text", "digestChat")
