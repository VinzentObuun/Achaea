createConsole("itemConsole", 8, 56, 32, 5, 461)

gmcpItems = gmcpItems or {}

function listItems()
  if gmcp.Char.Items.List.location == "room" then
	  gmcpItems = {}
	  
		for _, v in ipairs(gmcp.Char.Items.List.items) do
		  gmcpItems[v.id] = v
		end

		printItems()
	end
end

local listItemsHandler = registerAnonymousEventHandler("gmcp.Char.Items.List", "listItems")

function addItem()
  if gmcp.Char.Items.Add.location == "room" then
    gmcpItems[gmcp.Char.Items.Add.item.id] = gmcp.Char.Items.Add.item
	end
  
	--[[
  if string.find(gmcp.Char.Items.Add.item.name, "item") then -- 'item' to be replaced with anything as needed.
    send("queue prepend eqbal g "..gmcp.Char.items.Add.item.id, false)
  end
  --]]
  
	printItems()
end

local addItemsHandler = registerAnonymousEventHandler("gmcp.Char.Items.Add", "addItem")

function removeItem()
  if gmcp.Char.Items.Remove.location == "room" then
    gmcpItems[gmcp.Char.Items.Remove.item.id] = nil
	end
	
	printItems()
end

local removeItemHandler = registerAnonymousEventHandler("gmcp.Char.Items.Remove", "removeItem")

function printItems()
  clearWindow("itemConsole")
  
	for k, v in pairs(gmcpItems) do
	  local rightAlign = 56 - #v.name - 9
		local highlight = highlightItems(v) or ""
		
		cecho("itemConsole", string.rep(" ", rightAlign)..highlight..(function() 
			if #v.name > 47 then
				return string.rep(" ", 44).."..."
			else
				return v.name
			end
		end)().." <DimGrey>(<white>"..k.."<DimGrey>)\n")
	end
end

function highlightItems(v)
  if v.attrib == "m" then return "<medium_spring_green>" end
	if v.attrib == "mx" and v.icon ~= "guard" then return "<DarkGreen>" end
	if v.icon == "door" then return "<SaddleBrown>" end
	if v.icon == "guard" then return "<medium_blue>" end
	if v.icon == "plant" then return "<purple>" end
	if v.name == "an eye sigil" then return "<pink>" end
	if v.name == "a key-shaped sigil" then return "<dark_goldenrod>" end
	if v.name == "a monolith sigil" then return "<DimGrey>" end
  if v.name:find("sovereign") ~= nil then return "<gold>" end
	if v.name == "a runic totem" then return "<sienna>" end
end -- Other modifiers can be added easily, this is not conclusive.
