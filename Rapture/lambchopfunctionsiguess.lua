lambchop = RegisterMod("Lambchop's API", 1)

--[[

all functions :

lambchop:addCollectibleCostume(player, collectible, costumePath)

--]]

function lambchop:addCollectibleCostume(player, collectible, costumePath) -- Call this function in a MC_POST_RENDER callback.
	--possible errors
	if player == nil then print("Bad argument to #1, entity expected, got nil") end
	if collectible == nil then print("Bad argument to #2, CollectibleType expected, got nil") end
	if costumePath == nil then print("Bad argument to #3, string expected, got nil") end
	
    local data = player:GetData()
	
	if data.HasCostume == nil then data.HasCostume = {} end -- Sets data.HasCostume to be a table to store specific costume info about items
    if data.HasCostume[collectible] == nil then data.HasCostume[collectible] = false end -- finds a collectible equal to the one given in the args and if its table data is nil, then it gets set to false
	
    if player:HasCollectible(collectible) then -- does the player have the collectible?
        if not data.HasCostume[collectible] then -- if they dont have the costume, apply it
            data.HasCostume[collectible] = true
            player:AddNullCostume(costumePath)
        end
    end
	
    if not player:HasCollectible(collectible) then -- does the player NOT have the collectible?
        if data.HasCostume[collectible] then -- if they have the costume, and they dont have the collectible associated with it, remove it
            player:TryRemoveNullCostume(costumePath)
            data.HasCostume[collectible] = false
        end
    end
end

function lambchop:addCollectibleBodyCostume(player, collectible, costumePath) -- Call this function in a MC_POST_RENDER callback.
	--possible errors
	if player == nil then print("Bad argument to #1, entity expected, got nil") end
	if collectible == nil then print("Bad argument to #2, CollectibleType expected, got nil") end
	if costumePath == nil then print("Bad argument to #3, string expected, got nil") end
	
    local data = player:GetData()
	
	if data.HasBodyCostume == nil then data.HasBodyCostume = {} end -- Sets data.HasCostume to be a table to store specific costume info about items
    if data.HasBodyCostume[collectible] == nil then data.HasBodyCostume[collectible] = false end -- finds a collectible equal to the one given in the args and if its table data is nil, then it gets set to false
	
    if player:HasCollectible(collectible) then -- does the player have the collectible?
        if not data.HasBodyCostume[collectible] then -- if they dont have the costume, apply it
            data.HasBodyCostume[collectible] = true
            player:AddNullCostume(costumePath)
        end
    end
	
    if not player:HasCollectible(collectible) then -- does the player NOT have the collectible?
        if data.HasBodyCostume[collectible] then -- if they have the costume, and they dont have the collectible associated with it, remove it
            player:TryRemoveNullCostume(costumePath)
            data.HasBodyCostume[collectible] = false
        end
    end
end
--[[
example :
Mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	-- define player, blah blah
	lambchop:addCollectibleCostume(player, CollectibleType.COLLECTIBLE, CollectibleData.COLLECTIBLE.ItemCostume)
end)
--]]

function lambchop:destroyNearbyGrid(e, radius)
    local room = Game():GetRoom()
    radius = radius or 10
    for i = 0, (room:GetGridSize()) do
		local gent = room:GetGridEntity(i)
        if room:GetGridEntity(i) then
            --if (e.Position:Distance(room:GetGridPosition(i))) < radius then
			if (e.Position - gent.Position):Length() <= radius then
                gent:Destroy()
            end
        end
    end
end

function lambchop:enterNearbyDoor(e, fx, radius)
    local room = Game():GetRoom()
    radius = radius or 10
    for i = 0, (room:GetGridSize()) do
		local gent = room:GetGridEntity(i)
        if gent then
            if (fx.Position - gent.Position):Length() <= radius then
                local Door = gent:ToDoor()
				if Door and Door:IsLocked() then
					Door:TryUnlock(false)
				end
				if Door and Door:IsOpen() then
					e.Position = Door.Position
					--fx.Position = Door.Position
				end
            end
			if (fx.Position - gent.Position):Length() <= radius then
                if gent.Desc.Type == GridEntityType.GRID_STAIRS then
					--e.Position = gent.Position
				end
            end
        end
    end
end

-- Use these ones whenever you want to.