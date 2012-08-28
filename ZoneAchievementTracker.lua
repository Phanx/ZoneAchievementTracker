--[[--------------------------------------------------------------------
	Zone Achievement Tracker
	Automatically tracks the achievement for completing quests in your current zone.
	Copyright (c) 2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info20975-ZoneAchievementTracker.html
	http://www.curse.com/addons/wow/zoneachievementtracker
----------------------------------------------------------------------]]

local ENABLE_DEBUGGING = 1--false

local AchievementForZone = {
	[16]  = 4896,  -- Arathi Highlands
	[17]  = 4900,  -- Badlands
	[475] = 1193,  -- Blade's Edge Mountains
	[19]  = 4909,  -- Blasted Lands
	[29]  = 4901,  -- Burning Steppes
	[640] = 4871,  -- Deepholm
	[101] = 4930,  -- Desolace
	[23]  = 4892,  -- Eastern Plaguelands
	[182] = 4931,  -- Felwood
	[492] = 40,    -- Icecrown
	[606] = 4870,  -- Mount Hyjal
	[479] = 1194,  -- Netherstorm
	[37]  = 4906,  -- Northern Stranglethorn
	[28]  = 4910,  -- Searing Gorge
	[473] = 1195,  -- Shadowmoon Valley
	[493] = 39,    -- Sholazar Basin
	[261] = 4934,  -- Silithus
	[38]  = 4904,  -- Swamp of Sorrows
	[161] = 4935,  -- Tanaris
	[673] = 4905,  -- The Cape of Stranglethorn
	[26]  = 4897,  -- The Hinterlands
	[495] = 38,    -- The Storm Peaks
	[61]  = 4938,  -- Thousand Needles
	[720] = 4872,  -- Uldum
	[201] = 4939,  -- Un'Goro Crater
	[22]  = 4893,  -- Western Plaguelands
	[281] = 4940,  -- Winterspring
	[467] = 1190,  -- Zangarmarsh
	[496] = 36,    -- Zul'Drak
	[858] = 6540,  -- Dread Wastes
	[810] = 6539,  -- Townlong Steppes
	[811] = 7315,  -- Vale of Eternal Blossoms
	[807] = 6301,  -- Valley of the Four Winds
}

local A = {
	[43]  = 4925,  -- Ashenvale [A]
	[476] = 4926,  -- Bloodmyst Isle [A]
	[486] = 33,    -- Borean Tundra [A]
	[42]  = 4928,  -- Darkshore [A]
	[488] = 35,    -- Dragonblight [A]
	[34]  = 4907,  -- Duskwood [A]
	[141] = 4929,  -- Dustwallow Marsh [A]
	[121] = 4932,  -- Feralas [A]
	[490] = 37,    -- Grizzly Hills [A]
	[465] = 1189,  -- Hellfire Peninsula [A]
	[491] = 34,    -- Howling Fjord [A]
	[35]  = 4899,  -- Loch Modan [A]
	[477] = 1192,  -- Nagrand [A]
	[36]  = 4902,  -- Redridge Mountains [A]
	[607] = 4937,  -- Southern Barrens [A]
	[81]  = 4936,  -- Stonetalon Mountains [A]
	[478] = 1191,  -- Terokkar Forest [A]
	[700] = 4873,  -- Twilight Highlands [A]
	[613] = 4869,  -- Vashj'ir [A]
	[39]  = 4903,  -- Westfall [A]
	[40]  = 4898,  -- Wetlands [A]
	[857] = 6535,  -- Krasarang Wilds [A]
	[809] = 6537,  -- Kun-Lai Summit [A]
	[806] = 6300,  -- The Jade Forest [A]
}

local H = {
	[43]  = 4976,  -- Ashenvale [H]
	[181] = 4927,  -- Azshara [H]
	[486] = 1358,  -- Borean Tundra [H]
	[488] = 1359,  -- Dragonblight [H]
	[141] = 4978,  -- Dustwallow Marsh [H]
	[121] = 4979,  -- Feralas [H]
	[463] = 4908,  -- Ghostlands [H]
	[490] = 1357,  -- Grizzly Hills [H]
	[465] = 1271,  -- Hellfire Peninsula [H]
	[24]  = 4895,  -- Hillsbrad Foothills [H]
	[491] = 1356,  -- Howling Fjord [H]
	[477] = 1273,  -- Nagrand [H]
	[11]  = 4933,  -- Northern Barrens [H]
	[21]  = 4894,  -- Silverpine Forest [H]
	[607] = 4981,  -- Southern Barrens [H]
	[81]  = 4980,  -- Stonetalon Mountains [H]
	[478] = 1272,  -- Terokkar Forest [H]
	[700] = 5501,  -- Twilight Highlands [H]
	[613] = 4982,  -- Vashj'ir [H]
	[857] = 6536,  -- Krasarang Wilds [H]
	[809] = 6538,  -- Kun-Lai Summit [H]
	[806] = 6534,  -- The Jade Forest [H]
}

local M = {
	[858] = true,  -- Dread Wastes
	[857] = true,  -- Krasarang Wilds
	[809] = true,  -- Kun-Lai Summit
	[806] = true,  -- The Jade Forest
	[810] = true,  -- Townlong Steppes
	[811] = true,  -- Vale of Eternal Blossoms
	[807] = true,  -- Valley of the Four Winds
}

local ZoneForAchievement

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:SetScript("OnEvent", function(self, event)
	if ENABLE_DEBUGGING then
		print("|cffff6666ZAT:|r", "OnEvent", event)
	end
	if not ZoneForAchievement then
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

		self.factionGroup = factionGroup

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
				AchievementForZone[zoneID] = "Invalid"
			elseif select(2, GetCategoryInfo(GetAchievementCategory(achievementID))) ~= 96 then
				if ENABLE_DEBUGGING then
					print(achievementID, "is not a quest achievement.")
				end
				AchievementForZone[zoneID] = "Wrong"
			else
				AchievementForZone[zoneID] = achievementID
			end
		end

		ZoneForAchievement = {}
		for zoneID, achievementID in pairs(AchievementForZone) do
			if type(achievementID) == "number" then
				ZoneForAchievement[achievementID] = zoneID
			end
		end

		A, H, temp = nil, nil, nil
		if ENABLE_DEBUGGING then
			print("|cffff6666ZAT:|r", "Done.")
		end
	end

	local zoneID = GetCurrentMapAreaID()
	if not zoneID then return end

	local achievementID, achievementName, completed, _ = AchievementForZone[zoneID]
	if type(achievementID) == "number" then
		_, achievementName, _, completed = GetAchievementInfo(achievementID)
	elseif achievementID then
		print("|cffff6666[ERROR] Zone Achievement Tracker:|r")
		print(string.format(">> %s achievement for %s zone %d %s.", achievementID, self.factionGroup, zoneID, GetRealZoneText()))
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
		print("|cffffcc00Zone Achievement Tracker:|r", ZATDB.noMoP and "\"Mists of Pandaria\"-Zonen deaktiviert." or "\"Mists of Pandaria\"-Zonen aktiviert.")
	elseif LOCALE == "esES" or LOCALE == "esMX" then
		print("|cffffcc00Zone Achievement Tracker:|r", ZATDB.noMoP and "Zonas de Mists of Pandaria desactivada." or "Zonas de Mists of Pandaria activada.")
	elseif LOCALE == "frFR" then
		print("|cffffcc00Zone Achievement Tracker:|r", ZATDB.noMoP and "Zones de Mists of Pandaria désactivé." or "Zones de Mists of Pandaria activé.")
	elseif LOCALE == "itIT" then
		print("|cffffcc00Zone Achievement Tracker:|r", ZATDB.noMoP and "Zone di Mists of Pandaria disattivata." or "Zone di Mists of Pandaria attivata.")
	elseif LOCALE == "ptBR" then
		print("|cffffcc00Zone Achievement Tracker:|r", ZATDB.noMoP and "Zonas de Mists of Pandaria desativada." or "Zonas de Mists of Pandaria ativada.")
	elseif LOCALE == "ruRU" then
		print("|cffffcc00Zone Achievement Tracker:|r", ZATDB.noMoP and "Зоны Mists of Pandaria отключена." or "Зоны Mists of Pandaria включена.")
	else
		print("|cffffcc00Zone Achievement Tracker:|r", ZATDB.noMoP and "Mists of Pandaria zones disabled." or "Mists of Pandaria zones enabled.")
	end
	f:GetScript("OnEvent")(f, "SlashCmdList")
end