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
  
function deleteRev()
  tempLineTrigger(1, 1, [[
    if not isPrompt() then
      moveCursor(0, getLineNumber() - 1) deleteLine()
    end
  ]])
end
  
function optColor(fore, back, match)
  if not match or match == target then
    if selectString(line, 1) > -1 then
      fg(fore) bg(back) 
    end
  end
    
  moveCursorEnd() resetFormat()
end
  
