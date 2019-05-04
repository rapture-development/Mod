local Mod = RegisterMod("Tboi - The Rapture", 1)

local _, err = pcall(require, "lambchopfunctionsiguess")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(tostring(err))
end

Mod.SavedData = {
}

local json = require("json")
local speaker = SFXManager()

--EchoModData = json.decode(EchoMod:LoadData())
    --EchoMod:SaveData(json.encode(EchoModData))
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	Mod.SavedData = json.decode(Isaac.LoadModData(Mod))
	if Mod.SavedData.hasTamperedWithSaveDat == nil then Mod.SavedData.hasTamperedWithSaveDat = true end --I do this because of some weird error
end)

-- Save Moddata
function Mod:SaveGame()
	Mod.SaveData(Mod, json.encode(Mod.SavedData))
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.SaveGame)
Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Mod.SaveGame)

local roomWasJustCleared = false
local roomWasCleared = true

RaptureModCollectibleType = {
	COLLECTIBLE_MERCURY_BOOTS = Isaac.GetItemIdByName("Mercury Boots"),
	COLLECTIBLE_CHOPSTICKS = Isaac.GetItemIdByName("Chopsticks"),
	COLLECTIBLE_IMMORTAL_SOUL = Isaac.GetItemIdByName("Immortal Soul"),
	COLLECTIBLE_SLAPSTICK = Isaac.GetItemIdByName("Slapstick"),
	--COLLECTIBLE_BUTTHEAD = Isaac.GetItemIdByName("Butthead"),
	COLLECTIBLE_AKEDAH = Isaac.GetItemIdByName("Akedah"),
	COLLECTIBLE_SAVINGSBOND = Isaac.GetItemIdByName("Savings Bond"),
	COLLECTIBLE_BLOODMONEY = Isaac.GetItemIdByName("Blood Money"),
	COLLECTIBLE_SCRUFFY = Isaac.GetItemIdByName("Scruffy"),
	COLLECTIBLE_PLUCK = Isaac.GetItemIdByName("Pluck!"),
}

EffectVariant.ENTITY_WANTEDICON = Isaac.GetEntityVariantByName("Wanted Icon")
FamiliarVariant.ENTITY_SCRUFFY = Isaac.GetEntityVariantByName("Scruffy")

RaptureModCollectibleData = {
	COLLECTIBLE_MERCURY_BOOTS = {
		Countdown = 0,
		Costume = Isaac.GetCostumeIdByPath("gfx/characters/costume_000_mercuryboots.anm2"),
	},
	COLLECTIBLE_CHOPSTICKS = {
		Costume = Isaac.GetCostumeIdByPath("gfx/characters/costume_001_chopsticks.anm2"),
	},
	COLLECTIBLE_IMMORTAL_SOUL = {
		Costume = Isaac.GetCostumeIdByPath("gfx/characters/costume_002_immortalsoul.anm2"),
	},
	COLLECTIBLE_SLAPSTICK = {
		Costume = Isaac.GetCostumeIdByPath("gfx/characters/costume_003_slapstick.anm2"),
	},
	--[[
	COLLECTIBLE_BUTTHEAD = {
		Costume = Isaac.GetCostumeIdByPath("gfx/characters/costume_003_slapstick.anm2"),
	},
	--]]
	COLLECTIBLE_AKEDAH = {
		BodyCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_005_akedah_body.anm2"),
		HeadCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_005_akedah.anm2"),
	},
}



Mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	for i = 0, (Game():GetNumPlayers()) do
		local player = Isaac.GetPlayer(i - 1)
		lambchop:addCollectibleCostume(player, RaptureModCollectibleType.COLLECTIBLE_MERCURY_BOOTS, RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Costume)
		lambchop:addCollectibleCostume(player, RaptureModCollectibleType.COLLECTIBLE_CHOPSTICKS, RaptureModCollectibleData.COLLECTIBLE_CHOPSTICKS.Costume)
		lambchop:addCollectibleCostume(player, RaptureModCollectibleType.COLLECTIBLE_IMMORTAL_SOUL, RaptureModCollectibleData.COLLECTIBLE_IMMORTAL_SOUL.Costume)
		lambchop:addCollectibleCostume(player, RaptureModCollectibleType.COLLECTIBLE_SLAPSTICK, RaptureModCollectibleData.COLLECTIBLE_SLAPSTICK.Costume)
		lambchop:addCollectibleCostume(player, RaptureModCollectibleType.COLLECTIBLE_AKEDAH, RaptureModCollectibleData.COLLECTIBLE_AKEDAH.HeadCostume)
			lambchop:addCollectibleBodyCostume(player, RaptureModCollectibleType.COLLECTIBLE_AKEDAH, RaptureModCollectibleData.COLLECTIBLE_AKEDAH.BodyCostume)
	end
end) -- used to render costumes



--------------- ITEM LOGIC ---------------------------------------------



----- Mercury Boots ------------------------------
do
Mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, e, hook, action)
	for i = 0, (Game():GetNumPlayers()) do
		local player = Isaac.GetPlayer(i - 1)
		if player then
			if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_MERCURY_BOOTS) then
				if RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Countdown == 0 then
					if Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) or Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, player.ControllerIndex) then
						player.Velocity = (player.Velocity*3.5):Resized(20)
						--player.Position = player.Position + player.Velocity*50
						RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Countdown = 50
						SFXManager():Play(SoundEffect.SOUND_BIRD_FLAP, 0.75, 0, false, 2.25)
						--player:AnimateTeleport() -- save this for later!
					end
				end
			end
		end
	end
end)
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
	for i = 0, (Game():GetNumPlayers()) do
		local player = Isaac.GetPlayer(i - 1)
		if RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Countdown > 0 then
			RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Countdown = RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Countdown - 1
			player.FireDelay = 1
		end
	end
end)
Mod:AddCallback(ModCallbacks.MC_POST_RENDER, function(_)
	for i = 0, (Game():GetNumPlayers()) do
		local player = Isaac.GetPlayer(i - 1)
		if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_MERCURY_BOOTS) then
			if RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Countdown >= 30 then
				if player.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
					player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					player:GetSprite().Color = Color(1, 1, 1, 0.90, 100, 100, 100)
				end
			end
			if RaptureModCollectibleData.COLLECTIBLE_MERCURY_BOOTS.Countdown < 30 then
				if player.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
					player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
					player:GetSprite().Color = Color(1, 1, 1, 1, 0, 0, 0)
				end
			end
			--[[
			if player:GetSprite().Color == Color(1, 1, 1, 0.90, 100, 100, 100) then
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsActiveEnemy() == true then
						if e:IsVulnerableEnemy() == true then
							if (e.Position - player.Position):Length() <= 40 then
								e:TakeDamage(0.75, 0, EntityRef(e), 0)
						--SFXManager():Play(SoundEffect.SOUND_BIRD_FLAP, 0.75, 0, false, 2.25)
							end
						end
					end
				end
			end 
			--]]
		end
	end
end)
end
--------------------------------------------------



----- Chopsticks ---------------------------------
do
function Mod:postEvaluateCache_Chopsticks(passedPlayer, flag)
    for i = 0, (Game():GetNumPlayers() - 1) do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_CHOPSTICKS) then
			if flag == CacheFlag.CACHE_FIREDELAY then
				if player.MaxFireDelay > 5 then
					player.MaxFireDelay = player.MaxFireDelay - ((math.ceil(2 * player.MaxFireDelay/10)))
				elseif player.MaxFireDelay < 5 then
					if not player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
						player.MaxFireDelay = player.MaxFireDelay - ((math.ceil(-2 * player.MaxFireDelay/10)))
					end
				end
			end
			if flag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + (0.75 * player:GetCollectibleNum(RaptureModCollectibleType.COLLECTIBLE_CHOPSTICKS))
			end
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.postEvaluateCache_Chopsticks)
function Mod:replaceTearVariant_Chopsticks(tear)
	for i = 0, (Game():GetNumPlayers()) do
		local player = Isaac.GetPlayer(i - 1)
		if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_CHOPSTICKS) then
			if tear.Variant == TearVariant.BLUE then
				tear:ChangeVariant(TearVariant.BLOOD)
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Mod.replaceTearVariant_Chopsticks)
end
--------------------------------------------------



----- Immortal Soul ------------------------------
do
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
	for i = 0, (Game():GetNumPlayers()) do
		local player = Isaac.GetPlayer(i - 1)
		local room = Game():GetRoom()
		roomWasJustCleared = false
		if not roomWasCleared and room:IsClear() then
			roomWasJustCleared = true
		end
		roomWasCleared = room:IsClear()
		if roomWasJustCleared then
			if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_IMMORTAL_SOUL) then
				if player:GetSoulHearts() > 0 then
					if player:GetSoulHearts() == 1 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 3 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 5 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 7 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 9 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 11 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 13 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 15 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 17 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 19 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 21 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
					if player:GetSoulHearts() == 23 then
						player:AddSoulHearts(1)
						SFXManager():Play(SoundEffect.SOUND_HOLY, 0.90, 0, false, 1.10)
					end
				end
			end
		end
	end
end)
end
--------------------------------------------------



----- Slapstick ----------------------------------
do
local firedelayBoost_Slapstick = 0
function Mod:postEvaluateCache_Slapstick(passedPlayer, flag)
    for i = 0, (Game():GetNumPlayers() - 1) do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_SLAPSTICK) then
			if flag == CacheFlag.CACHE_FIREDELAY then
				if player.MaxFireDelay > 5 then
					player.MaxFireDelay = player.MaxFireDelay - ((math.ceil(firedelayBoost_Slapstick * player.MaxFireDelay/10)))
				elseif player.MaxFireDelay < 5 then
					if not player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
						player.MaxFireDelay = player.MaxFireDelay - ((math.ceil(-firedelayBoost_Slapstick * player.MaxFireDelay/10)))
					end
				end
			end
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.postEvaluateCache_Slapstick)
function Mod:onDamage_Slapstick(entity, amount, damageFlag, source, countdown) -- Item function
	if entity.Type == EntityType.ENTITY_PLAYER then -- Check if entity is the player
		for i = 0, (Game():GetNumPlayers() - 1) do
			local player = Isaac.GetPlayer(i)
			if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_SLAPSTICK) then
				if player.MaxFireDelay > 5 and firedelayBoost_Slapstick == 0 then
					firedelayBoost_Slapstick = firedelayBoost_Slapstick + 3
				end
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:EvaluateItems()
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsVulnerableEnemy() and e:IsActiveEnemy() then
						e:AddConfusion(EntityRef(player), 360, false)
					end
				end
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.onDamage_Slapstick)
function Mod:OnStart_Slapstick(isSave)
	for i = 0, (Game():GetNumPlayers() - 1) do
		local player = Isaac.GetPlayer(i)
		firedelayBoost_Slapstick = 0
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.OnStart_Slapstick)
function Mod:Transition_Slapstick()
	for i = 0, (Game():GetNumPlayers() - 1) do
		local player = Isaac.GetPlayer(i)
		firedelayBoost_Slapstick = 0
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.Transition_Slapstick)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.Transition_Slapstick)
end
--------------------------------------------------



----- Butthead -----------------------------------
-- not ported yet
--------------------------------------------------



----- Akedah -------------------------------------
do
function Mod:postEvaluateCache_Akedah(passedPlayer, flag)
    for i = 0, (Game():GetNumPlayers() - 1) do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_AKEDAH) then
			if flag == CacheFlag.CACHE_FIREDELAY then
				if player.MaxFireDelay > 5 then
					player.MaxFireDelay = player.MaxFireDelay - ((math.ceil(2 * player.MaxFireDelay/10)))
				elseif player.MaxFireDelay < 5 then
					if not player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
						player.MaxFireDelay = player.MaxFireDelay - ((math.ceil(-2 * player.MaxFireDelay/10)))
					end
				end
			end
			if flag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + 0.32
			end
			if flag == CacheFlag.CACHE_FLYING then
				if player.CanFly == false then
					player.CanFly = true
				end
			end
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.postEvaluateCache_Akedah)
end
--------------------------------------------------



----- Savings Bond -------------------------------
do
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, isaac)
	if isaac:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_SAVINGSBOND) then
		local coins = isaac:GetNumCoins()
		if not Mod.SavedData.savingsBank or Mod.SavedData.savingsBank ~= coins then
			Mod.SavedData.savingsBank = coins
		end
	end
end)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, hasstarted)
	local isaac = Isaac.GetPlayer(0)
	if not hasstarted then
		if Mod.SavedData.savingsBank ~= nil then
			if Mod.SavedData.savingsBank > 0 then
				local newEarnedCoins = math.ceil(Mod.SavedData.savingsBank/2)
				--print(tostring(newEarnedCoins))
				isaac:AddCoins(newEarnedCoins)
			else
				isaac:AddCoins(5)
			end
			Mod.SavedData.savingsBank = nil
		end
    end
end)
end
--------------------------------------------------



----- Blood Money --------------------------------
do
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--function actives each room; gives a 1/10 chance to make every enemy have a bounty
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
	local isaac = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	if isaac:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_BLOODMONEY) then

		if not Mod.SavedData.bountyCoins then Mod.SavedData.bountyCoins = 0 end --makes sure it isnt nil. vountyCoins saves how much potential coins you will have for the next floor
		if room:GetType() == RoomType.ROOM_BOSS or (math.random(1,10)==10 and RoomType.ROOM_DEFAULT) and not room:IsClear() then --if room is not cleared and a random chance by 1/10 or if its a boss room, then
			print(true)
			speaker:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1)
			--this loop gets all vulnerable enemies wanted when needed
			local entities = Isaac.GetRoomEntities()
			for i = 1, #entities do --loop to check every enemy
				if entities[i]:IsVulnerableEnemy() and entities[i]:IsEnemy() and entities[i].Type ~= EntityType.ENTITY_FIREPLACE then --if enemy is vulnerable
					if entities[i]:IsBoss() then
						entities[i]:GetData().IsWanted = true -- then make wanted	
					end
					--print(true)					
				end
			end
		end
	else --makes sure its nil if you dont have the item
		Mod.SavedData.bountyCoins = nil
	end
end)

--function to wanted enemies
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent) --effect
	local player = Isaac.GetPlayer(0)
	local data = ent:GetData()
	
	if data.IsWanted then --if enemies are wanted then....
		--[[if not data.IsWantedSprite then
			local wantedicon = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENTITY_WANTEDICON, 0, player.Position, Vector(0,0), player)
			data.IsWantedSprite = wantedicon
		else
			if ent.Visible then --the icon needs to be shown if its visible, otherwise a creepy looking icon would be floating lol
				data.IsWantedSprite:Render(Isaac.WorldToScreen(ent.Position + Vector(0, ent.Size * -5)), Vector(0,0), Vector(0,0))
			end
		end]]
	end
	if data.IsWanted then -- if killed code
		if ent:IsDead() then -- on death
			local coins
			if ent:IsBoss() then
				coins = math.random(5,7)
			elseif ent:IsChampion() then
				coins = math.random(0,0)
			else
				coins = math.random(0,0)
			end
			for i = 1, coins do
				local coindropvecX = (math.random(-100, 100))/50
				local coindropvecY = (math.random(-100, 100))/50
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ent.Position, Vector(coindropvecX, coindropvecY), ent)
			end
			--TheRaptureItems.SavedData.bountyCoins = TheRaptureItems.SavedData.bountyCoins + coins
		end
	end
end)
--function to new level, rewarding the bounty you saved up :3
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_)
	local player = Isaac.GetPlayer(0)
	--if Mod.SavedData.bountyCoins and player:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_BLOODMONEY) then --checks if you have coins in the bountyCoins as well if you have the item
		---player:AddCoins(Mod.SavedData.bountyCoins) --add your reward
		--Mod.SavedData.bountyCoins = 0 --turn back to zero
	--end
end)

--render function for the effect
Mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
    local data = ent:GetData()
    if data.IsWanted then --if the thingy is wanted
        if not data.IsWantedSprite or not data.IsWantedSprite:Exists() then
			--setup on the items
            local wantedicon = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENTITY_WANTEDICON, 0, ent.Position, Vector(0,0), ent)
			data.IsWantedSprite = wantedicon
            data.IsWantedSprite:GetSprite():Load("gfx/effects/wantedicon.anm2", true)
            data.IsWantedSprite:GetSprite():Play("Appear", true)
            data.IsWantedSprite.Visible = false
        end
    end

    if data.IsWantedSprite then --if the sprite icon-
        if data.IsWantedSprite:Exists() then --if the icon even exists in the first place
			if data.IsWantedSprite:GetSprite():IsFinished("Appear") then
				data.IsWantedSprite:GetSprite():Play("Idle",true)
			end
			--revelations snippet: i used the sigil thing charon's effect thingy.
            if data.IsWantedSprite:GetSprite():IsFinished("Disappear") then
                data.IsWantedSprite:Remove()
            else
                if ent:IsDead() and not data.IsWantedSprite:GetSprite():IsPlaying("Disappear") then
                    data.IsWantedSprite:GetSprite():Play("Disappear", true)
                end

                if ent.Visible then --the icon needs to be shown if its visible, otherwise a creepy looking icon would be floating lol
                   data.IsWantedSprite:GetSprite():Render(Isaac.WorldToScreen(ent.Position + Vector(0, ent.Size * -5)), Vector(0,0), Vector(0,0))
                end
			end
		else
			data.IsWantedSprite = nil
        end
    end
end)

--lose bounty code
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
	if Mod.SavedData.bountyCoins and damageFlag ~= DamageFlag.DAMAGE_FAKE then
		local penalty = math.random(0,2) --penalty to how much coins you lose
		if Mod.SavedData.bountyCoins > 0 then
			Mod.SavedData.bountyCoins = Mod.SavedData.bountyCoins - penalty
		end
		if Mod.SavedData.bountyCoins <= 0 then Mod.SavedData.bountyCoins = 0 end --I need to make sure the numbers don't hit a negative lol
	end
end, EntityType.ENTITY_PLAYER)
---------------------------------------------------------------------------------
end
--[[
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
	local isaac = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	if isaac:HasCollectible(RaptureModCollectibleType.COLLECTIBLE_BLOODMONEY) then
		if not Mod.SavedData.bountyCoins then Mod.SavedData.bountyCoins = 0 end --makes sure it isnt nil. vountyCoins saves how much potential coins you will have for the next floor
		if (room:GetType() == RoomType.ROOM_BOSS or math.random(1 ,5) == 5) and not room:IsClear() then --if room is not cleared and a random chance by 1/10 or if its a boss room, then
			speaker:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1)
			--this loop gets all vulnerable enemies wanted when needed
			for i, ent in pairs(Isaac.GetRoomEntities()) do --lcheck for every enemy and see if its a boss, make it wanted
				if ent:IsBoss() then
					ent:GetData().IsWanted = true
					ent.CollisionDamage = ent.CollisionDamage + 1
				end
			end
		end
	end
end)
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent) --effect
	local player = Isaac.GetPlayer(0)
	local data = ent:GetData()

	if ent:IsBoss() then -- if killed code
		if data.IsWanted and ent:IsDead() then -- on death
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ent.Position, Vector((math.random(-100, 100)/75), (math.random(-100, 100)/75)), ent)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ent.Position, Vector((math.random(-100, 100)/75), (math.random(-100, 100)/75)), ent)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ent.Position, Vector((math.random(-100, 100)/75), (math.random(-100, 100)/75)), ent)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ent.Position, Vector((math.random(-100, 100)/75), (math.random(-100, 100)/75)), ent)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ent.Position, Vector((math.random(-100, 100)/75), (math.random(-100, 100)/75)), ent)
		end
	end
end)
end
--]]
--------------------------------------------------



----- Scruffy ------------------------------------
do
--cleared room function detection
function Mod:ClearedRoom()
	if Mod.SavedData.ScruffyTime ==  nil then Mod.SavedData.ScruffyTime = 0 end
	if Mod.SavedData.ScruffyTime or Mod.SavedData.ScruffyTime > 0 then --if ScruffyTime isnt nil or empty
		Mod.SavedData.ScruffyTime = Mod.SavedData.ScruffyTime - 1
	end
end
Mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, Mod.ClearedRoom)

--used scruffy code
function Mod:useScruffy(collItem, rng)
	local player = Isaac.GetPlayer(0)
	local data = player:GetData()
	if player:GetNumCoins() >= 12 then
		if not data.Scruffy or not data.Scruffy:Exists() then --if there's no Scruffy while he was spawned then...
			local dude = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ENTITY_SCRUFFY, 0, player.Position, Vector(0,0), player) --spawn
			dude:GetSprite():Play("Appear",true)
			data.Scruffy = dude
		end
		if not Mod.SavedData.ScruffyTime then-- ScruffyTime is how much rooms he will continue attacking
			Mod.SavedData.ScruffyTime = 3 --add three if nil
		else
			Mod.SavedData.ScruffyTime = Mod.SavedData.ScruffyTime + 3 --add three more
		end
		player:AddCoins(-12)
	end
	return true
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, Mod.useScruffy, RaptureModCollectibleType.COLLECTIBLE_SCRUFFY)

function Mod:ClearScruffyData(hasstarted) --Init
	local player = Isaac.GetPlayer(0)
    if not hasstarted then
		Mod.SavedData.ScruffyTime = nil
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.ClearScruffyData)

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local player = fam.Player
	player:ToPlayer()
	local data = player:GetData()
	local famdata = fam:GetData()
	print(tostring(Mod.SavedData.ScruffyTime))
	
	if fam:GetSprite():IsFinished("Appear") then 
		fam:GetSprite():Play("Idle") 
		if (player.Position - fam.Position):Length() >= 50 then
			fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
		else
			fam.Velocity = fam.Velocity - fam.Velocity/5
		end
	end --automatically play idle after appear
	
	if fam:GetSprite():IsPlaying("Idle") then--if she is active
		
		--target code
		local entities = Isaac.GetRoomEntities()
		famdata.closestEnemy = nil -- i need to force it to nil
		famdata.closestEnemyDist = 99506742
		if #entities > 0 then
			local chosenEnemy = math.random(1,#entities)
			for i = 1, #entities do
				if entities[i]:IsVulnerableEnemy() and entities[i].Type ~= EntityType.ENTITY_FIREPLACE and entities[i]:IsActiveEnemy() then--list of what makes an entity an enemy
					if not famdata.target or (famdata.target:IsDead() or not famdata.target:Exists()) then --checks if it is dead or gone
						local savedDist = (entities[i].Position - fam.Position):Length()
						if savedDist < famdata.closestEnemyDist and savedDist < 300 then
							famdata.closestEnemy = entities[i]
							famdata.target = famdata.closestEnemy
						end
					end
				end
			end
		end
		
		if famdata.target then
			if not famdata.target:IsVulnerableEnemy() and not famdata.target:IsActiveEnemy() then
				fam:GetSprite():Play("Sleep", true)
				if (player.Position - fam.Position):Length() >= 50 then
					fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
				else
					fam.Velocity = fam.Velocity - fam.Velocity/5
				end
			end
			if not famdata.target:IsVulnerableEnemy()then
				fam:GetSprite():Play("Sleep", true)
				if (player.Position - fam.Position):Length() >= 50 then
					fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
				else
					fam.Velocity = fam.Velocity - fam.Velocity/5
				end
			end
			if not famdata.target:IsDead() or famdata.target:Exists() then
				if famdata.target:IsVulnerableEnemy() and famdata.target:IsActiveEnemy() then
					fam.Velocity = fam.Velocity * 0.7 + ((famdata.target.Position - fam.Position):Resized(1) * 3)
					--else--if not famdata.target or (famdata.target:IsDead() or not famdata.target:Exists()) then
						--[[elseif not famdata.target or (famdata.target:IsDead() or not famdata.target:Exists()) then
							fam:GetSprite():Play("Sleep", false)
						if (player.Position - fam.Position):Length() >= 50 then
							fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
						else
							fam.Velocity = fam.Velocity - fam.Velocity/5
						end]]
					--end
				end
			--else
				if not famdata.target:IsVulnerableEnemy() and not famdata.target:IsActiveEnemy() then
					fam:GetSprite():Play("Sleep", true)
					if (player.Position - fam.Position):Length() >= 50 then
						fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
					else
						fam.Velocity = fam.Velocity - fam.Velocity/5
					end
				end
			end
		else
		
			
			--fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
			--fam:GetSprite():Play("Sleep") 
			if (player.Position - fam.Position):Length() >= 50 then
				fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
			else
				fam.Velocity = fam.Velocity - fam.Velocity/5
			end
		end
	end
	if fam:GetSprite():IsPlaying("Sleep") then--if she is inactive
		--fam.Velocity = fam.Velocity * 0.7
	end
	--code to make scruffy disappear
	if Mod.SavedData.ScruffyTime <= 0 then
		fam:GetSprite():Play("Sleep", false)
		if (player.Position - fam.Position):Length() >= 50 then
					--fam.Velocity = fam.Velocity + ((player.Position - fam.Position):Resized(1) * 2)
			fam.Velocity = fam.Velocity * 0.7 + ((player.Position - fam.Position):Resized(1) * 2)
		else
			fam.Velocity = fam.Velocity - fam.Velocity/5
		end
	else
		if fam:GetSprite():IsPlaying("Sleep") then fam:GetSprite():Play("Idle") end
	end
end, FamiliarVariant.ENTITY_SCRUFFY)
end
--------------------------------------------------



----- Pluck --------------------------------------
do
function Mod:usePlucked(collItem, rng)
	local player = Isaac.GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	if not Mod.SavedData.pluckedType then --code that adjusts the type just in case it is nil to begin with
		Mod.SavedData.pluckedType = 0
	end
	for i, entities in pairs(Isaac.GetRoomEntities()) do
		if entities:IsVulnerableEnemy() and entities:IsEnemy() and entities.Type ~= EntityType.ENTITY_FIREPLACE then --if enemy is vulnerable
			entities:ToNPC()
			if Mod.SavedData.pluckedType == 0 then --charm
				entities:AddCharmed(700) --add charmed
			elseif Mod.SavedData.pluckedType == 1 then --fear
				entities:AddFear(EntityRef(player),700) --add fear
			end
		end
	end
	-- the switching thingy code
	--"he loves me, he loves me not"
    if Mod.SavedData.pluckedType == 0 then --charm	
		Mod.SavedData.pluckedType = 1
	elseif Mod.SavedData.pluckedType == 1 then --fear
		Mod.SavedData.pluckedType = 0
	end
	return true
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, Mod.usePlucked, RaptureModCollectibleType.COLLECTIBLE_PLUCK)

function Mod:ClearPlucked(hasstarted) --Init
	local player = Isaac.GetPlayer(0)
    if not hasstarted then
		Mod.SavedData.pluckedType = nil
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.ClearPlucked)

end
--------------------------------------------------



-----------------------------------------------------------------------