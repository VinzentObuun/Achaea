sys.Ink = sys.Ink or {}

sys.Ink.Blue, sys.Ink.Red = "lumic", "redclay" -- Defaults. Change for preference.
  
sys.Ink.Mill = "mill" -- ID or "mill"
  
sys.Ink.List = {
  black = { [sys.Ink.Red] = 1, [sys.Ink.Blue] = 1, buffalohorn = 2, fishscales = 2, goldflakes = 1, sharktooth = 2, wyrmtongue = 3, yellowchitin = 1 },
   blue = { [sys.Ink.Blue] = 1, buffalohorn = 1 },
   gold = { buffalohorn = 2, fishscales = 2, goldflakes = 1, sharktooth = 2, wyrmtongue = 1 },
  green = { [sys.Ink.Blue] = 2, buffalohorn = 2, sharktooth = 1, yellowchitin = 1 },
 purple = { [sys.Ink.Red] = 2, [sys.Ink.Blue] = 2, buffalohorn = 2, fishscales = 2, wyrmtongue = 1 },
    red = { [sys.Ink.Red] = 1, fishscales = 1 },
 yellow = { sharktooth = 1, yellowchitin = 1 }
}

function sys.Ink.Commit(type, amount)
  sys.Ink.Left = tonumber(amount)
    
  for k, v in pairs(sys.Ink.List[type]) do
    sendAll("outr "..v * ((sys.Ink.Left <= 5) and sys.Ink.Left or 5).." "..k,
      "put "..((sys.Ink.Left > 1 or v > 1) and "group " or "")..k.." in "..sys.Ink.Mill, false)
  end
    
  sys.Ink.Type = type
    
  send("queue addclear eqbal mill for "..((sys.Ink.Left > 5) and 5 or sys.Ink.Left).." "..type, false)
    
  sys.Ink.Left = (sys.Ink.Left > 5) and (sys.Ink.Left - 5) or 0
    
  sys.Ink.Timer = (sys.Ink.Left > 5) and 10 or (tonumber(amount) * 2)
end

function sys.Ink.Update()
  if sys.Ink.Type and sys.Bal == "1" then
    tempTimer(.85, function() -- For standard mill. Need an adjust for golden mill speed, but don't own it.
      while sys.Ink.Timer > 0 do
        send("g ink from "..sys.Ink.Mill, false)
          
        sys.Ink.Timer = sys.Ink.Timer - 1
      end
      
      send("inr all ink")
        
      if sys.Ink.Left > 0 then
        sys.Ink.Commit(sys.Ink.Type, sys.Ink.Left)
      else
        sys.Ink.Left, sys.Ink.Type, sys.Ink.Timer = nil, nil, nil
      end
    end)
  end
end
