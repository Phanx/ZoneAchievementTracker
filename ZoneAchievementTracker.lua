--[[--------------------------------------------------------------------
	Zone Achievement Tracker
	Automatically tracks the achievement for completing quests in your current zone.
	Copyright 2012-2016 Phanx <addons@phanx.net>. All rights reserved.
	https://github.com/Phanx/ZoneAchievementTracker
	https://mods.curse.com/addons/wow/zoneachievementtracker
	https://www.wowinterface.com/downloads/info20975-ZoneAchievementTracker.html
----------------------------------------------------------------------]]

local ENABLE_DEBUGGING = false

local AchievementForZone = {
	[14]  = 4896,  -- Arathi Highlands
	[15]  = 4900,  -- Badlands
	[17]  = 4909,  -- Blasted Lands
	[36]  = 4901,  -- Burning Steppes
	[66]  = 4930,  -- Desolace
	[23]  = 4892,  -- Eastern Plaguelands
	[77]  = 4931,  -- Felwood
	[50]  = 4906,  -- Northern Stranglethorn
	[32]  = 4910,  -- Searing Gorge
	[81]  = 4934,  -- Silithus
	[51]  = 4904,  -- Swamp of Sorrows
	[71]  = 4935,  -- Tanaris
	[510] = 4905,  -- The Cape of Stranglethorn
	[26]  = 4897,  -- The Hinterlands
	[61]  = 4938,  -- Thousand Needles
	[78]  = 4939,  -- Un'Goro Crater
	[22]  = 4893,  -- Western Plaguelands
	[83]  = 4940,  -- Winterspring
	-- The Burning Crusade
	[105] = 1193,  -- Blade's Edge Mountains
	[109] = 1194,  -- Netherstorm
	[104] = 1195,  -- Shadowmoon Valley
	[102] = 1190,  -- Zangarmarsh
	-- Wrath of the Lich King
	[118] = 40,    -- Icecrown
	[119] = 39,    -- Sholazar Basin
	[120] = 38,    -- The Storm Peaks
	[121] = 36,    -- Zul'Drak
	-- Cataclysm
	[207] = 4871,  -- Deepholm
	[198] = 4870,  -- Mount Hyjal
	[249] = 4872,  -- Uldum
	-- Mists of Pandaria
	[422] = 6540,  -- Dread Wastes
	[388] = 6539,  -- Townlong Steppes
	[390] = 7315,  -- Vale of Eternal Blossoms
	[376] = 6301,  -- Valley of the Four Winds
	-- Warlords of Draenor
		-- All faction-specific, see below
	-- Legion
	[630] = 10763, -- Aszuna
	[650] = 10059, -- Highmountain
	[634] = 10790, -- Stormheim
	[680] = 11124, -- Suramar
	[641] = 10698, -- Val'sharah
}

local A = {
	[63]  = 4925,  -- Ashenvale
	[62]  = 4928,  -- Darkshore
	[47]  = 4903,  -- Duskwood
	[70]  = 4929,  -- Dustwallow Marsh
	[69]  = 4932,  -- Feralas
	[48]  = 4899,  -- Loch Modan
	[49]  = 4902,  -- Redridge Mountains
	[199] = 4937,  -- Southern Barrens
	[65]  = 4936,  -- Stonetalon Mountains
	[52]  = 4903,  -- Westfall
	[56]  = 4899,  -- Wetlands
	-- The Burning Crusade
	[106] = 4926,  -- Bloodmyst Isle
	[100] = 1189,  -- Hellfire Peninsula
	[107] = 1192,  -- Nagrand
	[108] = 1191,  -- Terokkar Forest
	-- Wrath of the Lich King
	[114] = 33,    -- Borean Tundra
	[115] = 35,    -- Dragonblight
	[116] = 37,    -- Grizzly Hills
	[117] = 34,    -- Howling Fjord
	-- Cataclysm
	[241] = 4873,  -- Twilight Highlands
	-- Mists of Pandaria
	[418] = 6535,  -- Krasarang Wilds
	[379] = 6537,  -- Kun-Lai Summit
	[371] = 6300,  -- The Jade Forest
	[203] = 4869,  -- Vashj'ir
	-- Warlords of Draenor
	[543] = 8923, -- Gorgrond
	[550] = 8927, -- Nagrand
	[539] = 8845, -- Shadowmoon Valley
	[542] = 8925, -- Spires of Arak
	[535] = 8920, -- Talador
	-- Battle for Azeroth
	[896] = 12497, -- Drustvar
	[942] = 12496, -- Stormsong Valley
	[895] = 12473, -- Tiragarde Sound
}

local H = {
	[63]  = 4976,  -- Ashenvale
	[76]  = 4927,  -- Azshara
	[70]  = 4978,  -- Dustwallow Marsh
	[69]  = 4979,  -- Feralas
	[25]  = 4895,  -- Hillsbrad Foothills
	[10]  = 4933,  -- Northern Barrens
	[21]  = 4894,  -- Silverpine Forest
	[199] = 4981,  -- Southern Barrens
	[65]  = 4980,  -- Stonetalon Mountains
	-- The Burning Crusade
	[95]  = 4908,  -- Ghostlands
	[100] = 1271,  -- Hellfire Peninsula
	[107] = 1273,  -- Nagrand
	[108] = 1272,  -- Terokkar Forest
	-- Wrath of the Lich King
	[114] = 1358,  -- Borean Tundra
	[115] = 1359,  -- Dragonblight
	[116] = 1357,  -- Grizzly Hills
	[117] = 1356,  -- Howling Fjord
	-- Cataclysm
	[241] = 5501,  -- Twilight Highlands
	-- Mists of Pandaria
	[418] = 6536,  -- Krasarang Wilds
	[379] = 6538,  -- Kun-Lai Summit
	[371] = 6534,  -- The Jade Forest
	[203] = 4982,  -- Vashj'ir
	-- Warlords of Draenor
	[525] = 8671, -- Frostfire Ridge
	[543] = 8924, -- Gorgrond
	[550] = 8928, -- Nagrand
	[542] = 8926, -- Spires of Arak
	[535] = 8919, -- Talador
	-- Battle for Azeroth
	[863] = 11868, -- Nazmir
	[864] = 12478, -- Vol'dun
	[862] = 11861, -- Zuldazar
}

local M = {
	-- Mists of Pandaria
	[422] = true,  -- Dread Wastes
	[418] = true,  -- Krasarang Wilds
	[379] = true,  -- Kun-Lai Summit
	[371] = true,  -- The Jade Forest
	[388] = true,  -- Townlong Steppes
	[390] = true,  -- Vale of Eternal Blossoms
	[376] = true,  -- Valley of the Four Winds
	-- Warlords of Draenor
	[525] = true,  -- Frostfire Ridge
	[543] = true,  -- Gorgrond
	[550] = true,  -- Nagrand
	[539] = true,  -- Shadowmoon Valley
	[542] = true,  -- Spires of Arak
	[535] = true,  -- Talador
	-- Legion
	[630] = true, -- Aszuna
	[650] = true, -- Highmountain
	[634] = true, -- Stormheim
	[680] = true, -- Suramar
	[641] = true, -- Val'sharah
	-- Battle for Azeroth
	[896] = true, -- Drustvar
	[863] = true, -- Nazmir
	[942] = true, -- Stormsong Valley
	[895] = true, -- Tiragarde Sound
	[864] = true, -- Vol'dun
	[862] = true, -- Zuldazar
}

local PLAYER_FACTION
local ZoneForAchievement

local function init()
	ZATDB = ZATDB or {}

	local factionGroup = UnitFactionGroup("player")

	local temp
	if factionGroup == "Alliance" then
		temp = A
	elseif factionGroup == "Horde" then
		temp = H
	end

	if not temp then
		if ENABLE_DEBUGGING then
			print("|cffff6666ZAT:|r", "Unsupported faction:", factionGroup)
		end
		return
	end

	if ENABLE_DEBUGGING then
		print("|cffff6666ZAT:|r", "Initalizing...")
	end

	PLAYER_FACTION = factionGroup

	for zoneID, achievementID in pairs(AchievementForZone) do
		temp[zoneID] = achievementID
	end

	wipe(AchievementForZone)
	for zoneID, achievementID in pairs(temp) do
		local _, _, name = pcall(GetAchievementInfo, achievementID)
		if not name then
			if ENABLE_DEBUGGING then
				print(achievementID, "is not a valid achievement.")
			end
		elseif select(2, GetCategoryInfo(GetAchievementCategory(achievementID))) ~= 96 then
			if ENABLE_DEBUGGING then
				print(achievementID, "is not a quest achievement.")
			end
		else
			AchievementForZone[zoneID] = achievementID
		end
	end

	ZoneForAchievement = {}
	for zoneID, achievementID in pairs(AchievementForZone) do
		ZoneForAchievement[achievementID] = zoneID
	end

	A, H, temp = nil, nil, nil
	if ENABLE_DEBUGGING then
		print("|cffff6666ZAT:|r", "Done.")
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:SetScript("OnEvent", function(self, event)
	if ENABLE_DEBUGGING then
		print("|cffff6666ZAT:|r", "OnEvent", event)
	end
	if not ZoneForAchievement then
		init()
	end

	local zoneID = C_Map.GetBestMapForUnit("player")
	if not zoneID then return end

	local achievementID, achievementName, completed, _ = AchievementForZone[zoneID]
	if type(achievementID) == "number" then
		_, achievementName, _, _, _, _, _, _, _, _, _, _, completed = GetAchievementInfo(achievementID)
	elseif achievementID then
		print("|cffff6666[ERROR] Zone Achievement Tracker:|r")
		print(string.format(">> %s achievement for %s zone %d %s.", achievementID, PLAYER_FACTION, zoneID, GetRealZoneText()))
		print("Please report this error so it can be fixed!")
		achievementID = nil
	end

	if ENABLE_DEBUGGING then
		print("|cffff6666ZAT:|r", zoneID, GetRealZoneText(), achievementID, achievementName, completed)
	end

	if M[zoneID] and ZATDB.noMoP then
		achievementID = nil
		if ENABLE_DEBUGGING then
			print("|cffff6666ZAT:|r", "noMoP")
		end
	end

	local tracked
	for _, id in ipairs({ GetTrackedAchievements() }) do
		if id == achievementID and not completed then
			if ENABLE_DEBUGGING then
				print("|cffff6666ZAT:|r", "Already tracking", achievementID, achievementName)
			end
			tracked = true
		elseif ZoneForAchievement[id] then
			if ENABLE_DEBUGGING then
				local _, name = GetAchievementInfo(id)
				print("|cffff6666ZAT:|r", "RemoveTrackedAchievement", id, name)
			end
			RemoveTrackedAchievement(id)
		end
	end

	if achievementID and not completed and not tracked then
		if ENABLE_DEBUGGING then
			print("|cffff6666ZAT:|r", "AddTrackedAchievement", achievementID, achievementName)
		end
		AddTrackedAchievement(achievementID)
	end
end)

if ENABLE_DEBUGGING then
	f.Ach4Zone = AchievementForZone
	f.Zone4Ach = ZoneForAchievement
	ZAT = f
end

SLASH_ZONEACHIEVEMENTTRACKER1 = "/zat"
SlashCmdList.ZONEACHIEVEMENTTRACKER = function()
	ZATDB.noMoP = not ZATDB.noMoP

	local LOCALE = GetLocale()
	if LOCALE == "deDE" then
		DEFAULT_CHAT_FRAME:AddMessage(format("|cffffcc00Zone Achievement Tracker:|r Zonen mit mehreren Geschichtsstränge %s|r.", ZATDB.noMoP and "|cff7f7f7fdeaktiviert" or "|cff7fff7faktiviert"))
	elseif LOCALE == "esES" or LOCALE == "esMX" then
		DEFAULT_CHAT_FRAME:AddMessage(format("|cffffcc00Zone Achievement Tracker:|r Zonas con múltiples tramas %s|r.", ZATDB.noMoP and "|cff7f7f7fdesactivada" or "|cff7fff7factivada"))
	elseif LOCALE == "frFR" then
		DEFAULT_CHAT_FRAME:AddMessage(format("|cffffcc00Zone Achievement Tracker:|r Zones avec des suites de quêtes multiples %s|r.", ZATDB.noMoP and "|cff7f7f7fdésactivé" or "|cff7fff7factivé"))
	elseif LOCALE == "itIT" then
		DEFAULT_CHAT_FRAME:AddMessage(format("|cffffcc00Zone Achievement Tracker:|r Zone con gruppi di missioni multipli %s|r.", ZATDB.noMoP and "|cff7f7f7fdisattivata" or "|cff7fff7fattivata"))
	elseif LOCALE == "ptBR" then
		DEFAULT_CHAT_FRAME:AddMessage(format("|cffffcc00Zone Achievement Tracker:|r Zonas com múltiplos histórias %s|r.", ZATDB.noMoP and "|cff7f7f7fdesativada" or "|cff7fff7fativada"))
	elseif LOCALE == "ruRU" then
		DEFAULT_CHAT_FRAME:AddMessage(format("|cffffcc00Zone Achievement Tracker:|r Зоны с несколько этапов развития сюжета %s|r.", ZATDB.noMoP and "|cff7f7f7fотключена" or "|cff7fff7fвключена"))
	else
		DEFAULT_CHAT_FRAME:AddMessage(format("|cffffcc00Zone Achievement Tracker:|r Zones with multiple criteria %s|r.", ZATDB.noMoP and "|cff7f7f7fdisabled" or "|cff7fff7fenabled"))
	end

	f:GetScript("OnEvent")(f, "SlashCmdList")
end
