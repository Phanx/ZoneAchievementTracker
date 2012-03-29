--[[--------------------------------------------------------------------
	Zone Achievement Tracker
	Automatically tracks the achievement for completing
	a certain number of quests in your current zone.
	Written by Phanx <addons@phanx.net>
	Copyright © 2012 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info20975-ZoneAchievementTracker.html
	http://www.curse.com/addons/wow/zoneachievementtracker
----------------------------------------------------------------------]]

local zoneAchievements = {
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
}

local A = {
	[43]  = 4925,  -- Ashenvale [A]
	[476] = 4926,  -- Bloodmyst Isle [A]
	[486] = 33,    -- Borean Tundra [A]
	[42]  = 4928,  -- Darkshore [A]
	[491] = 34,    -- Howling Fjord [A]
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
}

local H = {
	[43]  = 4976,  -- Ashenvale [H]
	[181] = 4927,  -- Azshara [H]
	[486] = 1358,  -- Borean Tundra [H]
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
	[700] = 5504,  -- Twilight Highlands [H]
	[613] = 4982,  -- Vashj'ir [H]
}

local reverse

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:SetScript("OnEvent", function()
	-- print("|cffff6666ZAT:|r", "OnEvent")
	if not reverse then
		-- print("|cffff6666ZAT:|r", "initalizing")
		local faction = UnitFactionGroup("player")
		if faction == "Alliance" then
			for zoneID, achievementID in pairs(A) do
				zoneAchievements[zoneID] = achievementID
			end
		elseif faction == "Horde" then
			for zoneID, achievementID in pairs(H) do
				zoneAchievements[zoneID] = achievementID
			end
		end
		A, H = nil, nil

		reverse = {}
		for zoneID, achievementID in pairs(zoneAchievements) do
			reverse[achievementID] = zoneID
		end
	end

	local zone = GetCurrentMapAreaID()
	if not zone then return end

	local achievement = zoneAchievements[zone]

	-- print("|cffff6666ZAT:|r", "zone:", zone, "achivement:", achievement)

	local tracked
	for _, id in ipairs({ GetTrackedAchievements() }) do
		if id == achievement then
			-- print("|cffff6666ZAT:|r", "already tracking", (select(2, GetAchievementInfo(id))))
			tracked = true
		elseif reverse[id] then
			-- print("|cffff6666ZAT:|r", "RemoveTrackedAchievement", (select(2, GetAchievementInfo(id))))
			RemoveTrackedAchievement(id)
		end
	end

	if achievement and not tracked then
		-- print("|cffff6666ZAT:|r", "AddTrackedAchievement", (select(2, GetAchievementInfo(achievement))))
		AddTrackedAchievement(achievement)
	end
end)

-- ZoneAchievementTracker = f