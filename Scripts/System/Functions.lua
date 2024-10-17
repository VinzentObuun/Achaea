function inParty(text)
  local i
      
  for i = 1, #gmcp.Comm.Channel.List do
    if gmcp.Comm.Channel.List[i].name == "party" then
      if text then
          send("pt "..text, false)
      end
        
      return true
    end
  end
  
  return false
end

---

function deleteRev()
  tempLineTrigger(1, 1, [[
    if not isPrompt() then
      moveCursor(0, getLineNumber() - 1) deleteLine()
    end
  ]])
end

---

function optColor(fore, back, match)
  if not match or match == target then
    if selectString(line, 1) > -1 then
      fg(fore) bg(back) 
    end
  end
    
  moveCursorEnd() resetFormat()
end

---

cmdPre = { "clot", "compose", "concentrate", "g body", "stand" } -- Ideal to add a better body grabber, based on present item IDs.

cmdClass = {
  ["Black Dragon"] = { "summon acid" },
  ["Blue Dragon"] = { "summon ice" },
  ["Dual Blunt"] = { "falcon slay" },
  ["Green Dragon"] = { "summon venom" },
  ["Gold Dragon"] = { "summon psi" },
  ["Psion"] = { "weave prepare "..wpnWeave or "disruption" },
  [ "Red Dragon"] = { "summon dragonfire" },
  ["Two Handed"] = { "order 174658 kill &tar" },
  ["Silver Dragon"] = { "summon lightning" },
} -- As a temporary measure, adding individual specs as 'class' items.

function cmdSend(cmdList, useGeneric, useClass)
  local currentClass = (gmcp.Char.Status.class == "Runewarden" and gmcp.Char.Vitals.charstats[3]:match("%s.+"):gsub("%s", "", 1)) or gmcp.Char.Status.class 

  if not string.find(currentClass, "Dragon") and not currentClass == "Blademaster" then
    table.insert(cmdList, 1, "vault "..urnMount)
  end

  if not amBlock and blockDir then
    table.insert(cmdList, 1, "block "..blockDir)
  end

  if table.contains(cmdClass, currentClass) and not useClass then
    for _, v in ipairs(cmdClass[currentClass]) do
      table.insert(cmdList, 1, v)
    end
  end
    
  if not useGeneric then
    for _, v in ipairs(cmdPre) do
      table.insert(cmdList, 1, v)
    end
  end
    
  send("queue addclear free "..(function()
    if #cmdList <= 10 then
      return table.concat(cmdList, cmdSep)
    else
      cmdList = table.concat(cmdList, " / ")
        
      if cmdHold ~= cmdList then
        cmdHold = cmdList
          
        send("setalias atk "..cmdList, false)
      end
        
      return "atk"
    end
  end)())
end
