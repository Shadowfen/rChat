--  rChat object will receive functions
rChat = rChat or {}

-- Common
local ADDON_NAME = rChat.name
local ADDON_VERSION	= rChat.version
local ADDON_AUTHOR	= rChat.author

-- Init
local isAddonLoaded			= false -- OnAddonLoaded() done
local isAddonInitialized	= false

-- Default variables to push in SavedVars
local defaults = {
	-- LAM handled
	showGuildNumbers = false,
	allGuildsSameColour = false,
	allZonesSameColour = true,
	allNPCSameColour = true,
	delzonetags = true,
	carriageReturn = false,
	alwaysShowChat = false,
	augmentHistoryBuffer = true,
	oneColour = false,
	showTagInEntry = true,
	showTimestamp = true,
	timestampcolorislcol = false,
	useESOcolors = true,
	diffforESOcolors = 40,
	timestampFormat = "HH:m",
	guildTags = {},
	officertag = {},
	switchFor = {},
	officerSwitchFor = {},
	formatguild = {},
	defaultchannel = CHAT_CHANNEL_GUILD_1,
	soundforincwhisps = SOUNDS.NEW_NOTIFICATION,
	enablecopy = true,
	enableChatTabChannel = true,
	enablepartyswitch = true,
	enableWhisperTab = false,
	groupLeader = false,
	disableBrackets = true,
	chatMinimizedAtLaunch = false,
	chatMinimizedInMenus = false,
	chatMaximizedAfterMenus = false,
	windowDarkness = 6,
	chatSyncConfig = true,
	floodProtect = true,
	floodGracePeriod = 30,
	lookingForProtect = false,
	wantToProtect = false,
	restoreOnReloadUI = true,
	restoreOnLogOut = true,
	restoreOnQuit = false,
	restoreOnAFK = true,
	restoreSystem = true,
	restoreSystemOnly = false,
	restoreWhisps = true,
	restoreTextEntryHistoryAtLogOutQuit = false,
	addChannelAndTargetToHistory = true,
	timeBeforeRestore = 2,
	notifyIM = false,
	nicknames = "",
	defaultTab = 1,
	defaultTabName = "",
	groupNames = 1,
	geoChannelsFormat = 2,
	urlHandling = true,
	-- guildRecruitProtect = false,
	spamGracePeriod = 5,
	fonts = "ESO Standard Font",
	colours =
	{
		[2*CHAT_CHANNEL_SAY] = "|cFFFFFF", -- say Left
		[2*CHAT_CHANNEL_SAY + 1] = "|cFFFFFF", -- say Right
		[2*CHAT_CHANNEL_YELL] = "|cE974D8", -- yell Left
		[2*CHAT_CHANNEL_YELL + 1] = "|cFFB5F4", -- yell Right
		[2*CHAT_CHANNEL_WHISPER] = "|cB27BFF", -- tell in Left
		[2*CHAT_CHANNEL_WHISPER + 1] = "|cB27BFF", -- tell in Right
		[2*CHAT_CHANNEL_PARTY] = "|c6EABCA", -- group Left
		[2*CHAT_CHANNEL_PARTY + 1] = "|cA1DAF7", -- group Right
		[2*CHAT_CHANNEL_WHISPER_SENT] = "|c7E57B5", -- tell out Left
		[2*CHAT_CHANNEL_WHISPER_SENT + 1] = "|c7E57B5", -- tell out Right
		[2*CHAT_CHANNEL_EMOTE] = "|cA5A5A5", -- emote Left
		[2*CHAT_CHANNEL_EMOTE + 1] = "|cA5A5A5", -- emote Right
		[2*CHAT_CHANNEL_MONSTER_SAY] = "|c879B7D", -- npc Left
		[2*CHAT_CHANNEL_MONSTER_SAY + 1] = "|c879B7D", -- npc Right
		[2*CHAT_CHANNEL_MONSTER_YELL] = "|c879B7D", -- npc yell Left
		[2*CHAT_CHANNEL_MONSTER_YELL + 1] = "|c879B7D", -- npc yell Right
		[2*CHAT_CHANNEL_MONSTER_WHISPER] = "|c879B7D", -- npc whisper Left
		[2*CHAT_CHANNEL_MONSTER_WHISPER + 1] = "|c879B7D", -- npc whisper Right
		[2*CHAT_CHANNEL_MONSTER_EMOTE] = "|c879B7D", -- npc emote Left
		[2*CHAT_CHANNEL_MONSTER_EMOTE + 1] = "|c879B7D", -- npc emote Right
		[2*CHAT_CHANNEL_GUILD_1] = "|c94E193", -- guild Left
		[2*CHAT_CHANNEL_GUILD_1 + 1] = "|cC3F0C2", -- guild Right
		[2*CHAT_CHANNEL_GUILD_2] = "|c94E193",
		[2*CHAT_CHANNEL_GUILD_2 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_GUILD_3] = "|c94E193",
		[2*CHAT_CHANNEL_GUILD_3 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_GUILD_4] = "|c94E193",
		[2*CHAT_CHANNEL_GUILD_4 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_GUILD_5] = "|c94E193",
		[2*CHAT_CHANNEL_GUILD_5 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_1] = "|cC3F0C2", -- guild officers Left
		[2*CHAT_CHANNEL_OFFICER_1 + 1] = "|cC3F0C2", -- guild officers Right
		[2*CHAT_CHANNEL_OFFICER_2] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_2 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_3] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_3 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_4] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_4 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_5] = "|cC3F0C2",
		[2*CHAT_CHANNEL_OFFICER_5 + 1] = "|cC3F0C2",
		[2*CHAT_CHANNEL_ZONE] = "|cCEB36F", -- zone Left
		[2*CHAT_CHANNEL_ZONE + 1] = "|cB0A074", -- zone Right
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_1] = "|cCEB36F", -- EN zone Left
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_1 + 1] = "|cB0A074", -- EN zone Right
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_2] = "|cCEB36F", -- FR zone Left
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_2 + 1] = "|cB0A074", -- FR zone Right
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_3] = "|cCEB36F", -- DE zone Left
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_3 + 1] = "|cB0A074", -- DE zone Right
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_4] = "|cCEB36F", -- JP zone Left
		[2*CHAT_CHANNEL_ZONE_LANGUAGE_4 + 1] = "|cB0A074", -- JP zone Right
		["timestamp"] = "|c8F8F8F", -- timestamp
		["tabwarning"] = "|c76BCC3", -- tab Warning ~ "Azure" (ZOS default)
		["groupleader"] = "|cC35582", -- 
		["groupleader1"] = "|c76BCC3", -- 
	},
	-- Not LAM
	chatConfSync = {},
}

-- SV
local db
local targetToWhisp
local guild1 = 1
local guild2 = 2
local guild3 = 3
local guild4 = 4
local guild5 = 5
local guildName1 = ""
local guildName2 = ""
local guildName3 = ""
local guildName4 = ""
local guildName5 = ""
local guildId1 = nil
local guildId2 = nil
local guildId3 = nil
local guildId4 = nil
local guildId5 = nil
local guildMaxNum = 0



-- rChatData will receive variables and objects.
local rChatData = {
	cachedMessages = {}, -- This one must be init before OnAddonLoaded because it will receive data before this event.
}

-- Used for rChat LinkHandling
local RCHAT_LINK = "p"
local RCHAT_URL_CHAN = 97
local RCHAT_CHANNEL_SAY = 98
local RCHAT_CHANNEL_NONE = 99

-- Init Automated Messages
local automatedMessagesList = ZO_SortFilterList:Subclass()

-- Backuping AddMessage for internal debug - AVOID DOING A CHAT_SYSTEM:AddMessage() in rChat, it can cause recursive calls
CHAT_SYSTEM.Zo_AddMessage = CHAT_SYSTEM.AddMessage

--[[
RCHAT_LINK format : ZO_LinkHandler_CreateLink(message, nil, RCHAT_LINK, data)
message = message to display, nil (ignored by ZO_LinkHandler_CreateLink), RCHAT_LINK : declaration
data : strings separated by ":"
1st arg is chancode like CHAT_CHANNEL_GUILD_1
]]--

local ChanInfoArray = ZO_ChatSystem_GetChannelInfo()

rChatData.chatCategories = {
	CHAT_CATEGORY_SAY,
	CHAT_CATEGORY_YELL,
	CHAT_CATEGORY_WHISPER_INCOMING,
	CHAT_CATEGORY_WHISPER_OUTGOING,
	CHAT_CATEGORY_ZONE,
	CHAT_CATEGORY_PARTY,
	CHAT_CATEGORY_EMOTE,
	CHAT_CATEGORY_SYSTEM,
	CHAT_CATEGORY_GUILD_1,
	CHAT_CATEGORY_GUILD_2,
	CHAT_CATEGORY_GUILD_3,
	CHAT_CATEGORY_GUILD_4,
	CHAT_CATEGORY_GUILD_5,
	CHAT_CATEGORY_OFFICER_1,
	CHAT_CATEGORY_OFFICER_2,
	CHAT_CATEGORY_OFFICER_3,
	CHAT_CATEGORY_OFFICER_4,
	CHAT_CATEGORY_OFFICER_5,
	CHAT_CATEGORY_ZONE_ENGLISH,
	CHAT_CATEGORY_ZONE_FRENCH,
	CHAT_CATEGORY_ZONE_GERMAN,
	CHAT_CATEGORY_ZONE_JAPANESE,
	CHAT_CATEGORY_MONSTER_SAY,
	CHAT_CATEGORY_MONSTER_YELL,
	CHAT_CATEGORY_MONSTER_WHISPER,
	CHAT_CATEGORY_MONSTER_EMOTE,
}

rChatData.guildCategories = {
	CHAT_CATEGORY_GUILD_1,
	CHAT_CATEGORY_GUILD_2,
	CHAT_CATEGORY_GUILD_3,
	CHAT_CATEGORY_GUILD_4,
	CHAT_CATEGORY_GUILD_5,
	CHAT_CATEGORY_OFFICER_1,
	CHAT_CATEGORY_OFFICER_2,
	CHAT_CATEGORY_OFFICER_3,
	CHAT_CATEGORY_OFFICER_4,
	CHAT_CATEGORY_OFFICER_5,
}

rChatData.defaultChannels = {
	RCHAT_CHANNEL_NONE,
	CHAT_CHANNEL_ZONE,
	CHAT_CHANNEL_SAY,
	CHAT_CHANNEL_GUILD_1,
	CHAT_CHANNEL_GUILD_2,
	CHAT_CHANNEL_GUILD_3,
	CHAT_CHANNEL_GUILD_4,
	CHAT_CHANNEL_GUILD_5,
	CHAT_CHANNEL_OFFICER_1,
	CHAT_CHANNEL_OFFICER_2,
	CHAT_CHANNEL_OFFICER_3,
	CHAT_CHANNEL_OFFICER_4,
	CHAT_CHANNEL_OFFICER_5,
}

local chatStrings = {
	standard = "%s%s: |r%s%s%s|r", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone
	esostandart = "%s%s %s: |r%s%s%s|r", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone with tag (except for monsters)
	esoparty = "%s%s%s: |r%s%s%s|r", -- standard format: party
	tellIn = "%s%s: |r%s%s%s|r", -- tell in
	tellOut = "%s-> %s: |r%s%s%s|r", -- tell out
	emote = "%s%s |r%s%s|r", -- emote
	guild = "%s%s %s: |r%s%s%s|r", -- guild
	language = "%s[%s] %s: |r%s%s%s|r", -- language zones
	
	-- For copy System, only Handle "From part"
	
	copystandard = "[%s]: ", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone
	copyesostandard = "[%s] %s: ", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone with tag (except for monsters)
	copyesoparty = "[%s]%s: ", -- standard format: party
	copytellIn = "[%s]: ", -- tell in
	copytellOut = "-> [%s]: ", -- tell out
	copyemote = "%s ", -- emote
	copyguild = "[%s] [%s]: ", -- guild
	copylanguage = "[%s] %s: ", -- language zones
	copynpc = "%s: ", -- language zones
}

-- Registering librairies
local LAM = LibAddonMenu2
local RCHATLC = LibChat2
local LMP = LibMediaProvider
local LMM = LibMainMenu
local MENU_CATEGORY_RCHAT = nil

-- Return true/false if text is a flood
local function SpamFlood(from, text, chanCode)

	-- 2+ messages identiqual in less than 30 seconds on Character channels = spam
		
	-- Should not happen
	if db.LineStrings then
		
		if db.lineNumber then
			-- 1st message cannot be a spam
			if db.lineNumber > 1 then
				
				local checkSpam = true
				local previousLine = db.lineNumber - 1
				local ourMessageTimestamp = GetTimeStamp()
				
				while checkSpam do
					
					-- Previous line can be a ChanSystem one
					if db.LineStrings[previousLine].channel ~= CHAT_CHANNEL_SYSTEM then
						if (ourMessageTimestamp - db.LineStrings[previousLine].rawTimestamp) < db.floodGracePeriod then
							-- if our message is sent by our chatter / will be break by "Character" channels and "UserID" Channels
							if from == db.LineStrings[previousLine].rawFrom then
								-- if our message is eq of last message
								if text == db.LineStrings[previousLine].rawText then
									-- Previous and current must be in zone(s), yell, say, emote (Character Channels except party)
									-- TODO: Find a characterchannel func
									
									-- CHAT_CHANNEL_SAY = 0 == nil in lua, will broke the array, so use RCHAT_CHANNEL_SAY
									local spamChanCode = chanCode
									if spamChanCode == CHAT_CHANNEL_SAY then
										spamChanCode = RCHAT_CHANNEL_SAY
									end
									
									local spammableChannels = {}
									spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_1] = true
									spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_2] = true
									spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_3] = true
									spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_4] = true
									spammableChannels[RCHAT_CHANNEL_SAY] = true
									spammableChannels[CHAT_CHANNEL_YELL] = true
									spammableChannels[CHAT_CHANNEL_ZONE] = true
									spammableChannels[CHAT_CHANNEL_EMOTE] = true
									
									-- spammableChannels[spamChanCode] = return true if our message was sent in a spammable channel
									-- spammableChannels[db.LineStrings[previousLine].channel] = return true if previous message was sent in a spammable channel
									if spammableChannels[spamChanCode] and spammableChannels[db.LineStrings[previousLine].channel] then
										-- Spam
										--CHAT_SYSTEM:Zo_AddMessage("Spam detected ( " .. text ..  " )")
										return true
									end
								end
							end
						else
							-- > 30s, stop analyzis
							checkSpam = false
						end
					end
					
					if previousLine > 1 then
						previousLine = previousLine - 1
					else
						checkSpam = false
					end
				
				end
				
			end
		end
		
	end
	
	return false
		
end

-- Return true/false if text is a LFG message
local function SpamLookingFor(text)

	local spamStrings = {
		[1] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[mMgG]",
		[2] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[hH][eE][aA][lL]",
		[3] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[dD][dD]",
		[4] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[dD][pP][sS]",
		[5] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[tT][aA][nN][kK]",
		[6] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[dD][aA][iI][lL][yY]",
		[7] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[sS][iI][lL][vV][eE][rR]",
		[8] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[gG][oO][lL][dD]", -- bypassed by first rule
		[9] = "[lL][%s.]?[fF][%s.]?[%d]?[%s.]?[dD][uU][nN][gG][eE][oO][nN]",
	}
	
	for _, spamString in ipairs(spamStrings) do
		if string.find(text, spamString) then
			--CHAT_SYSTEM:Zo_AddMessage("spamLookingFor:" .. text .." ;spamString=" .. spamString)
			return true
		end
	end

	return false

end

-- Return true/false if text is a WTT message
local function SpamWantTo(text)

	-- "w.T S"
	if string.find(text, "[wW][%s.]?[tT][%s.]?[bBsStT]") then
		
		-- Item Handler
		if string.find(text, "|H(.-):item:(.-)|h(.-)|h") then
			-- Match
			--CHAT_SYSTEM:Zo_AddMessage("WT detected ( " .. text .. " )")
			return true
		elseif string.find(text, "[Ww][Ww][%s]+[Bb][Ii][Tt][Ee]") then
			-- Match
			--CHAT_SYSTEM:Zo_AddMessage("WT WW Bite detected ( " .. text .. " )")
			return true
		end
	
	end
	
	return false
	
end

-- Return true/false if text is a Guild recruitment one
local function SpamGuildRecruit(text, chanCode)

	-- Guild Recruitment message are too complex to only use 1/2 patterns, an heuristic method must be used
	
	-- 1st is channel. only check geographic channels (character ones)
	-- 2nd is text len, they're generally long ones
	-- Then, presence of certain words
	
	--CHAT_SYSTEM:Zo_AddMessage("GR analizis")
	
	local spamChanCode = chanCode
	if spamChanCode == CHAT_CHANNEL_SAY then
		spamChanCode = RCHAT_CHANNEL_SAY
	end
	
	local spammableChannels = {}
	spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_1] = true
	spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_2] = true
	spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_3] = true
	spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_4] = true
	spammableChannels[RCHAT_CHANNEL_SAY] = true
	spammableChannels[CHAT_CHANNEL_YELL] = true
	spammableChannels[CHAT_CHANNEL_ZONE] = true
	spammableChannels[CHAT_CHANNEL_EMOTE] = true
	
	local spamStrings = {
		["[Ll]ooking [Ff]or ([Nn]ew+) [Mm]embers"] = 5, -- looking for (new) members
		["%d%d%d\+"] = 5, -- 398+
		["%d%d%d\/500"] = 5, -- 398/500
		["gilde"] = 1, -- 398/500
		["guild"] = 1, -- 398/500
		["[Tt][Ee][Aa][Mm][Ss][Pp][Ee][Aa][Kk]"] = 1,
	}
	
	--[[
	
Polska gildia <OUTLAWS> po stronie DC rekrutuje! Oferujemy triale, eventy pvp, dungeony, hardmody, porady doswiadczonych graczy oraz mila atmosfere. Wymagamy TS-a i mikrofonu. "OUTLAWS gildia dla ludzi chcacych tworzyc gildie, a nie tylko byc w gildii!" W sprawie rekrutacji zloz podanie na www.outlawseso.guildlaunch.com lub napisz w grze.
Seid gegrüßt liebe Abenteurer.  Eine der ältesten aktiven Handelsgilden (seit 30.03.14), Caveat Emptor (deutschsprachig), hat wieder Plätze frei. (490+ Mitglieder). Gildenhändler vorhanden! /w bei Interesse
Salut. L'esprit d'équipe est quelque chose qui vous parle ? Relever les plus haut défis en PvE comme en PvP et  RvR vous tente, mais vous ne voulez pas sacrifier votre IRL pour cela ? Empirium League est construite autours de tous ces principes. /w pour plus d'infos ou sur Empiriumleague.com 
Die Gilde Drachenstern sucht noch Aktive Member ab V1 für gemeinsamen Spaß und Erfolg:) unserer aktueller Raidcontent ist Sanctum/HelRah und AA unsere Raidtage sind Mittwoch/Freitags und Sonntag bei Fragen/Intresse einfach tell/me:)
Anyone wants to join a BIG ACTIVE TRADE GUILD? Then join Daggerfall Trade Masters 493/500 MEMBERS--5DAYS ACTIVITY--_TEAMSPEAK--CRAGLORN FRONT ROW TRADER (SHELZAKA) Whisper me for invite and start BUYING and SELLING right NOW! 
The Cambridge Alliance is a multi-faction social guild based in the UK.  Send me a whisper if you would like to join!  www.cambridge-alliance.co.uk
Rejoignez le Comptoir de Bordeciel, Guilde Internationale de Trade (490+) présente depuis la release. Bénéficiez de nos prices check grâce à un historique de vente et bénéficiez d’estimations réelles. Les taxes sont investies dans le marchand de guilde. Envoyez-moi par mp le code « CDC » pour invitation auto
Valeureux soldats de l'Alliance, rejoignez l'Ordre des Ombres, combattez pour la gloire de Daguefillante, pour la victoire, et la conquète du trône impérial ! -- Mumble et site -- Guilde PVE-PVP -- 18+ -- MP pour info
Join Honour. A well established guild with over 10 years gaming experience and almost 500 active members. We run a full week of Undaunted, Trials, Cyrodiil and low level helper nights. With a social and helpful community and great crafting support. Check out our forums www.honourforever.com. /w for invite  
{L'Ordre des Ombres} construite sur l'entraide, la sympathie et bonne ambiance vous invite a rejoindre ses rangs afin de profiter au maximum de TESO. www.ordredesombres.fr Cordialement - Chems
The new guild Auctionhouse Extended is recruiting players, who want to buy or sell items! (300+ member
Totalitarnaya Destructivnaya Sekta "Cadwell's Honor" nabiraet otvazhnyh i bezbashennyh rakov, krabov i drugie moreprodukty v svoi tesnye ryady!! PvE, PvP, TS, neobychnyi RP i prochie huliganstva. Nam nuzhny vashi kleshni!! TeamSpeak dlya priema cadwells-honor.ru
you look for a guild (united trade post / 490+ member) for trade, pve and all other things in eso without obligations? /w me for invitation --- du suchst eine gilde (united trade post / 490+ mitglieder) für handel, pve und alle anderen dinge in eso ohne verpflichtungen. /w me
[The Warehouse] Trading Guild Looking for Members! /w me for Invite :)
Russian guild Daggerfall Bandits is looking for new members! We are the biggest and the most active russian community in Covenant. Regular PvE and PvP raids to normal and hard mode content! 490+ members. Whisper me.
  Bonjour, la Guilde La Flibuste recherche des joueurs francophones.  Sans conditions et pour jouer dans la bonne humeur, notre guilde est ouverte à tous.  On recherche des joueurs de toutes les classes et vétérang pour compléter nos raids.  Pour plus d'infos, c'est ici :) Merci et bon jeu.  
	
	]]--
	
	-- Our note. Per default, each message get its heuristic level to 0
	local guildHeuristics = 0
	
	-- spammableChannels[db.LineStrings[previousLine].channel] = return true if previous message was sent in a spammable channel
	if spammableChannels[spamChanCode] then
		
		local textLen = string.len(text)
		local text300 = (string.len(text) > 300) -- 50
		local text250 = (string.len(text) > 250) -- 40
		local text200 = (string.len(text) > 200) -- 30
		local text150 = (string.len(text) > 150) -- 20
		local text100 = (string.len(text) > 100) -- 10
		local text30  = (string.len(text) > 30)  -- 0
		
		-- 30 chars are needed to make a phrase of guild recruitment. If recruiter spam in SMS, rChat won't handle it.
		if text30 then
			
			-- Each message can possibly be a spam, let's wrote our checklist
			--CHAT_SYSTEM:Zo_AddMessage("GR Len ( " .. textLen .. " )")
			
			if text300 then
				guildHeuristics = 50
			elseif text250 then
				guildHeuristics = 40
			elseif text200 then
				guildHeuristics = 30
			elseif text150 then
				guildHeuristics = 20
			elseif text100 then
				guildHeuristics = 10
			end
			
			-- Still to do
			
			for spamString, value in ipairs(spamStrings) do
				if string.find(text, spamString) then
					--CHAT_SYSTEM:Zo_AddMessage(spamString)
					guildHeuristics = guildHeuristics + value
				end
			end
			
			if guildHeuristics > 60 then
				--CHAT_SYSTEM:Zo_AddMessage("GR : true (score=" .. guildHeuristics .. ")")
				return true
			end
		
		end
	
	end
	
	--CHAT_SYSTEM:Zo_AddMessage("GR : false (score=" .. guildHeuristics .. ")")
	return false
	
end

-- Return true/false if anti spam is enabled for a certain category
-- Categories must be : Flood, LookingFor, WantTo, GuildRecruit
local function IsSpamEnabledForCategory(category)
	
	if category == "Flood" then
	
		-- Enabled in Options?
		if db.floodProtect then
			--CHAT_SYSTEM:Zo_AddMessage("floodProtect enabled")
			-- AntiSpam is enabled
			return true
		end
		
		--CHAT_SYSTEM:Zo_AddMessage("floodProtect disabled")
		-- AntiSpam is disabled
		return false
	
	-- LFG
	elseif category == "LookingFor" then
		-- Enabled in Options?
		if db.lookingForProtect then
			-- Enabled in reality?
			if rChatData.spamLookingForEnabled then
				--CHAT_SYSTEM:Zo_AddMessage("lookingForProtect enabled")
				-- AntiSpam is enabled
				return true
			else
			
				--CHAT_SYSTEM:Zo_AddMessage("lookingForProtect is temporary disabled since " .. rChat.spamTempLookingForStopTimestamp)
				
				-- AntiSpam is disabled .. since -/+ grace time ?
				if GetTimeStamp() - rChatData.spamTempLookingForStopTimestamp > (db.spamGracePeriod * 60) then
					--CHAT_SYSTEM:Zo_AddMessage("lookingForProtect enabled again")
					-- Grace period outdatted -> we need to re-enable it
					rChatData.spamLookingForEnabled = true
					return true
				end
			end
		end
		
		--CHAT_SYSTEM:Zo_AddMessage("lookingForProtect disabled")
		-- AntiSpam is disabled
		return false
	
	-- WTT
	elseif category == "WantTo" then
		-- Enabled in Options?
		if db.wantToProtect then
			-- Enabled in reality?
			if rChatData.spamWantToEnabled then
				--CHAT_SYSTEM:Zo_AddMessage("wantToProtect enabled")
				-- AntiSpam is enabled
				return true
			else
				-- AntiSpam is disabled .. since -/+ grace time ?
				if GetTimeStamp() - rChatData.spamTempWantToStopTimestamp > (db.spamGracePeriod * 60) then
					--CHAT_SYSTEM:Zo_AddMessage("wantToProtect enabled again")
					-- Grace period outdatted -> we need to re-enable it
					rChatData.spamWantToEnabled = true
					return true
				end
			end
		end
		
		--CHAT_SYSTEM:Zo_AddMessage("wantToProtect disabled")
		-- AntiSpam is disabled
		return false
	
	-- Join my Awesome guild
	elseif category == "GuildRecruit" then
		-- Enabled in Options?
		if db.guildRecruitProtect then
			-- Enabled in reality?
			if rChatData.spamGuildRecruitEnabled then
				-- AntiSpam is enabled
				return true
			else
				-- AntiSpam is disabled .. since -/+ grace time ?
				if GetTimeStamp() - rChatData.spamTempGuildRecruitStopTimestamp > (db.spamGracePeriod * 60) then
					-- Grace period outdatted -> we need to re-enable it
					rChatData.spamGuildRecruitEnabled = true
					return true
				end
			end
		end
		
		-- AntiSpam is disabled
		return false
	
	end
	
end

-- Return true is message is a spam depending on MANY parameters
local function SpamFilter(chanCode, from, text, isCS)

	-- 5 options for spam : Spam (multiple messages) ; LFM/LFG ; WT(T/S/B) ; Guild Recruitment ; Gold Spamming for various websites
	
	-- ZOS GM are NEVER blocked
	if isCS then
		return false
	end
	
	-- CHAT_CHANNEL_PARTY is not spamfiltered, party leader get its own antispam tool (= kick)
	if chanCode == CHAT_CHANNEL_PARTY then
		return false
	end
	
	-- "I" or anyone do not flood
	if IsSpamEnabledForCategory("Flood") then
		if SpamFlood(from, text, chanCode) then return true end
	end
	
	-- But "I" can have exceptions
	if zo_strformat(SI_UNIT_NAME, from) == rChatData.localPlayer or from == GetDisplayName() then
	
		--CHAT_SYSTEM:Zo_AddMessage("I say something ( " .. text .. " )")
		
		if IsSpamEnabledForCategory("LookingFor") then
			-- "I" can look for a group
			if SpamLookingFor(text) then
				
				--CHAT_SYSTEM:Zo_AddMessage("I say a LF Message ( " .. text .. " )")
				
				-- If I break myself the rule, disable it few minutes
				rChatData.spamTempLookingForStopTimestamp = GetTimeStamp()
				rChatData.spamLookingForEnabled = false
				
			end
		end
		
		if IsSpamEnabledForCategory("WantTo") then
			-- "I" can be a trader
			if SpamWantTo(text) then
				
				--CHAT_SYSTEM:Zo_AddMessage("I say a WT Message ( " .. text .. " )")
				
				-- If I break myself the rule, disable it few minutes
				rChatData.spamTempWantToStopTimestamp = GetTimeStamp()
				rChatData.spamWantToStop = true
				
			end
		end
		
		--[[
		if IsSpamEnabledForCategory("GuildRecruit") then
			-- "I" can do some guild recruitment
			if SpamGuildRecruit(text, chanCode) then
				
				--CHAT_SYSTEM:Zo_AddMessage("I say a GR Message ( " .. text .. " )")
				
				-- If I break myself the rule, disable it few minutes
				rChatData.spamTempGuildRecruitStopTimestamp = GetTimeStamp()
				rChatData.spamGuildRecruitStop = true
				
			end
		end
		]]--
		
		-- My message will be displayed in any case
		return false
		
	end
	
	-- Spam
	if IsSpamEnabledForCategory("Flood") then
		if SpamFlood(from, text, chanCode) then return true end
	end
	
	-- Looking For
	if IsSpamEnabledForCategory("LookingFor") then
		if SpamLookingFor(text) then return true end
	end
	
	-- Want To
	if IsSpamEnabledForCategory("WantTo") then
		if SpamWantTo(text) then return true end
	end
	
	-- Guild Recruit
	--[[
	if IsSpamEnabledForCategory("GuildRecruit") then
		if SpamGuildRecruit(text, chanCode) then return true end
	end
	]]--
	
	return false

end

-- Turn a ([0,1])^3 RGB colour to "|cABCDEF" form. We could use ZO_ColorDef, but we have so many colors so we don't do it.
local function ConvertRGBToHex(r, g, b)
	return string.format("|c%.2x%.2x%.2x", zo_floor(r * 255), zo_floor(g * 255), zo_floor(b * 255))
end

-- Convert a colour from "|cABCDEF" form to [0,1] RGB form.
local function ConvertHexToRGBA(colourString)
	local r=tonumber(string.sub(colourString, 3, 4), 16) or 255
	local g=tonumber(string.sub(colourString, 5, 6), 16) or 255
	local b=tonumber(string.sub(colourString, 7, 8), 16) or 255
	return r/255, g/255, b/255, 1
end

-- Return a formatted time
local function CreateTimestamp(timeStr, formatStr)
	formatStr = formatStr or db.timestampFormat
	
	-- split up default timestamp
	local hours, minutes, seconds = timeStr:match("([^%:]+):([^%:]+):([^%:]+)")
	local hoursNoLead = tonumber(hours) -- hours without leading zero
	local hours12NoLead = (hoursNoLead - 1)%12 + 1
	local hours12
	if (hours12NoLead < 10) then
		hours12 = "0" .. hours12NoLead
	else
		hours12 = hours12NoLead
	end
	local pUp = "AM"
	local pLow = "am"
	if (hoursNoLead >= 12) then
		pUp = "PM"
		pLow = "pm"
	end
	
	-- create new one
	local timestamp = formatStr
	timestamp = timestamp:gsub("HH", hours)
	timestamp = timestamp:gsub("H", hoursNoLead)
	timestamp = timestamp:gsub("hh", hours12)
	timestamp = timestamp:gsub("h", hours12NoLead)
	timestamp = timestamp:gsub("m", minutes)
	timestamp = timestamp:gsub("s", seconds)
	timestamp = timestamp:gsub("A", pUp)
	timestamp = timestamp:gsub("a", pLow)
	
	return timestamp
	
end

-- Format from name
local function ConvertName(chanCode, from, isCS, fromDisplayName)
	
	local function DisplayWithOrWoBrackets(realFrom, displayed, linkType)
		if not displayed then -- reported. Should not happen, maybe parser error with nicknames.
			displayed = realFrom
		end
		if db.disableBrackets then
			return ZO_LinkHandler_CreateLinkWithoutBrackets(displayed, nil, linkType, realFrom)
		else
			return ZO_LinkHandler_CreateLink(displayed, nil, linkType, realFrom)
		end
	end
	
	-- From can be UserID or Character name depending on wich channel we are
	local new_from = from
	
	-- Messages from @Someone (guild / whisps)
	if IsDecoratedDisplayName(from) then
		
		-- Guild / Officer chat only
		if chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_OFFICER_5 then
			
			-- Get guild ID based on channel id
			local guildId = GetGuildId((chanCode - CHAT_CHANNEL_GUILD_1) % 5 + 1)
			local guildName = GetGuildName(guildId)
			
			if rChatData.nicknames[new_from] then -- @UserID Nicknammed
				db.LineStrings[db.lineNumber].rawFrom = rChatData.nicknames[new_from]
				new_from = DisplayWithOrWoBrackets(new_from, rChatData.nicknames[new_from], DISPLAY_NAME_LINK_TYPE)
			elseif db.formatguild[guildName] == 2 then -- Char
				local _, characterName = GetGuildMemberCharacterInfo(guildId, GetGuildMemberIndexFromDisplayName(guildId, new_from))
				characterName = zo_strformat(SI_UNIT_NAME, characterName)
				local nickNamedName
				if rChatData.nicknames[characterName] then -- Char Nicknammed
					nickNamedName = rChatData.nicknames[characterName]
				end
				db.LineStrings[db.lineNumber].rawFrom = nickNamedName or characterName
				new_from = DisplayWithOrWoBrackets(characterName, nickNamedName or characterName, CHARACTER_LINK_TYPE)
			elseif db.formatguild[guildName] == 3 then -- Char@UserID
				local _, characterName = GetGuildMemberCharacterInfo(guildId, GetGuildMemberIndexFromDisplayName(guildId, new_from))
				characterName = zo_strformat(SI_UNIT_NAME, characterName)
				if characterName == "" then characterName = new_from end -- Some buggy rosters
				
				if rChatData.nicknames[characterName] then -- Char Nicknammed
					characterName = rChatData.nicknames[characterName]
				else
					characterName = characterName .. new_from
				end
				
				db.LineStrings[db.lineNumber].rawFrom = characterName
				new_from = DisplayWithOrWoBrackets(new_from, characterName, DISPLAY_NAME_LINK_TYPE)
			else
				db.LineStrings[db.lineNumber].rawFrom = new_from
				new_from = DisplayWithOrWoBrackets(new_from, new_from, DISPLAY_NAME_LINK_TYPE)
			end

		else
			-- Wisps with @ We can't guess characterName for those ones
			
			if rChatData.nicknames[new_from] then -- @UserID Nicknammed
				db.LineStrings[db.lineNumber].rawFrom = rChatData.nicknames[new_from]
				new_from = DisplayWithOrWoBrackets(new_from, rChatData.nicknames[new_from], DISPLAY_NAME_LINK_TYPE)
			else
				db.LineStrings[db.lineNumber].rawFrom = new_from
				new_from = DisplayWithOrWoBrackets(new_from, new_from, DISPLAY_NAME_LINK_TYPE)
			end

		end
		
	-- Geo chat, Party, Whisps with characterName
	else
		
		new_from = zo_strformat(SI_UNIT_NAME, new_from)
		
		local nicknamedFrom
		if rChatData.nicknames[new_from] then -- Character or Account Nicknammed
			nicknamedFrom = rChatData.nicknames[new_from]
		elseif rChatData.nicknames[fromDisplayName] then
			nicknamedFrom = rChatData.nicknames[fromDisplayName]
		end
		
		db.LineStrings[db.lineNumber].rawFrom = nicknamedFrom or new_from
		
		-- No brackets / UserID for emotes
		if chanCode == CHAT_CHANNEL_EMOTE then
			new_from = ZO_LinkHandler_CreateLinkWithoutBrackets(nicknamedFrom or new_from, nil, CHARACTER_LINK_TYPE, from)
		-- zones / whisps / say / tell. No Handler for NPC
		elseif not (chanCode == CHAT_CHANNEL_MONSTER_SAY or chanCode == CHAT_CHANNEL_MONSTER_YELL or chanCode == CHAT_CHANNEL_MONSTER_WHISPER or chanCode == CHAT_CHANNEL_MONSTER_EMOTE) then
			
			if chanCode == CHAT_CHANNEL_PARTY then
				if db.groupNames == 1 then
					db.LineStrings[db.lineNumber].rawFrom = nicknamedFrom or fromDisplayName
					new_from = DisplayWithOrWoBrackets(fromDisplayName, nicknamedFrom or fromDisplayName, DISPLAY_NAME_LINK_TYPE)
				elseif db.groupNames == 3 then
					new_from = new_from .. fromDisplayName
					db.LineStrings[db.lineNumber].rawFrom = nicknamedFrom or new_from
					new_from = DisplayWithOrWoBrackets(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
				else
					db.LineStrings[db.lineNumber].rawFrom = nicknamedFrom or new_from
					new_from = DisplayWithOrWoBrackets(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
				end
			else
				if db.geoChannelsFormat == 1 then
					db.LineStrings[db.lineNumber].rawFrom = nicknamedFrom or fromDisplayName
					new_from = DisplayWithOrWoBrackets(fromDisplayName, nicknamedFrom or fromDisplayName, DISPLAY_NAME_LINK_TYPE)
				elseif db.geoChannelsFormat == 3 then
					new_from = new_from .. fromDisplayName
					db.LineStrings[db.lineNumber].rawFrom = nicknamedFrom or new_from
					new_from = DisplayWithOrWoBrackets(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
				else
					db.LineStrings[db.lineNumber].rawFrom = nicknamedFrom or new_from
					new_from = DisplayWithOrWoBrackets(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
				end
			end
			
		end
		
	end
	
	if isCS then -- ZOS icon
		new_from = "|t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t" .. new_from
	end
	
	return new_from
	
end

local function UndockTextEntry()
	
	-- Unfinshed
	
	if not db.chatConfSync[rChatData.localPlayer].TextEntryPoint then
		db.chatConfSync[rChatData.localPlayer].TextEntryPoint = CENTER
		db.chatConfSync[rChatData.localPlayer].TextEntryRelPoint = CENTER
		db.chatConfSync[rChatData.localPlayer].TextEntryX = 0
		db.chatConfSync[rChatData.localPlayer].TextEntryY = -300
		db.chatConfSync[rChatData.localPlayer].TextEntryWidth = 200
	end
		
	ZO_ChatWindowTextEntry:ClearAnchors()
	ZO_ChatWindowTextEntry:SetAnchor(db.chatConfSync[rChatData.localPlayer].TextEntryPoint, GuiRoot, db.chatConfSync[rChatData.localPlayer].TextEntryRelPoint, db.chatConfSync[rChatData.localPlayer].TextEntryX, 300)
	ZO_ChatWindowTextEntry:SetDimensions(400, 27)
	ZO_ChatWindowTextEntry:SetMovable(false)
	
	local undockedTexture = WINDOW_MANAGER:CreateControl("UndockedBackground", ZO_ChatWindowTextEntry, CT_TEXTURE)
	undockedTexture:SetTexture("EsoUI/Art/Performance/StatusMeterMunge.dds")
	undockedTexture:SetAnchor(CENTER, ZO_ChatWindowTextEntry, CENTER, 0, 0)
	undockedTexture:SetDimensions(800, 250)
	
end

local function RedockTextEntry()

	-- Unfinished

	ZO_ChatWindowTextEntry:ClearAnchors()
	ZO_ChatWindowTextEntry:SetAnchor(BOTTOMLEFT, ZO_ChatWindowMinimize, BOTTOMRIGHT, -6, -13)
	ZO_ChatWindowTextEntry:SetAnchor(BOTTOMRIGHT, ZO_ChatWindow, BOTTOMRIGHT, -23, -13)
	ZO_ChatWindowTextEntry:SetMovable(false)

end


-- For console
function rChat.CMD_DEBUG()
	if rChat.DEBUG ~= 1 then
		d("rChat Debug : On")
		rChat.DEBUG = 1
	else
		d("rChat Debug : Off")
		rChat.DEBUG = 0
	end
end

-- For console quest time
function rChat.CMD_DEBUG1()
	if rChat.DEBUG ~= 2 then
		d("rChat Debug 2: On")
		rChat.DEBUG = 2
	else
		d("rChat Debug 2: Off")
		rChat.DEBUG = 0
	end
end

function rChat.CMD_DEBUG2()
	if rChat.DEBUG ~=3 then
		d("rChat Debug 3 : On")
		rChat.DEBUG = 3
	else
		d("rChat Debug 3 : Off")
		rChat.DEBUG = 0
	end
end


-- Also called by bindings
function rChat_ShowAutoMsg()
	LMM:ToggleCategory(MENU_CATEGORY_RCHAT)
end

-- Register Slash commands
SLASH_COMMANDS["/msg"] = rChat_ShowAutoMsg
SLASH_COMMANDS["/rchat_debug"] = rChat.CMD_DEBUG
SLASH_COMMANDS["/rchat_debug1"] = rChat.CMD_DEBUG1
SLASH_COMMANDS["/rchat_debug2"] = rChat.CMD_DEBUG2

ZO_CreateStringId("RCHAT_AUTOMSG_NAME_DEFAULT_TEXT", GetString(RCHAT_RCHAT_AUTOMSG_NAME_DEFAULT_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_DEFAULT_TEXT", GetString(RCHAT_RCHAT_AUTOMSG_MESSAGE_DEFAULT_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_TIP1_TEXT", GetString(RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP1_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_TIP2_TEXT", GetString(RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP2_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_TIP3_TEXT", GetString(RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP3_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_NAME_HEADER", GetString(RCHAT_RCHAT_AUTOMSG_NAME_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_HEADER", GetString(RCHAT_RCHAT_AUTOMSG_MESSAGE_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_ADD_TITLE_HEADER", GetString(RCHAT_RCHAT_AUTOMSG_ADD_TITLE_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_EDIT_TITLE_HEADER", GetString(RCHAT_RCHAT_AUTOMSG_EDIT_TITLE_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_ADD_AUTO_MSG", GetString(RCHAT_RCHAT_AUTOMSG_ADD_AUTO_MSG))
ZO_CreateStringId("RCHAT_AUTOMSG_EDIT_AUTO_MSG", GetString(RCHAT_RCHAT_AUTOMSG_EDIT_AUTO_MSG))
ZO_CreateStringId("SI_BINDING_NAME_RCHAT_SHOW_AUTO_MSG", GetString(RCHAT_SI_BINDING_NAME_RCHAT_SHOW_AUTO_MSG))
ZO_CreateStringId("RCHAT_AUTOMSG_REMOVE_AUTO_MSG", GetString(RCHAT_RCHAT_AUTOMSG_REMOVE_AUTO_MSG))




function automatedMessagesList:New(control)
	
	ZO_SortFilterList.InitializeSortFilterList(self, control)
	
	local AutomatedMessagesSorterKeys =
	{
		["name"] = {},
		["message"] = {tiebreaker = "name"}
	}
	
 	self.masterList = {}
 	ZO_ScrollList_AddDataType(self.list, 1, "rChatXMLAutoMsgRowTemplate", 32, function(control, data) self:SetupEntry(control, data) end)
 	ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
 	self.sortFunction = function(listEntry1, listEntry2) return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, AutomatedMessagesSorterKeys, self.currentSortOrder) end
	--self:SetAlternateRowBackgrounds(true)
	
	return self
	
end

-- format ESO text to raw text
-- IE : Transforms LinkHandlers into their displayed value
local function FormatRawText(text)

	-- Strip colors from chat
	local newtext = string.gsub(text, "|[cC]%x%x%x%x%x%x", ""):gsub("|r", "")
	
	-- Transforms a LinkHandler into its localized displayed value
	-- "|H(.-):(.-)|h(.-)|h" = pattern for Linkhandlers
	-- Item : |H1:item:33753:25:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h = [Battaglir] in french -> Link to item 33753, etc
	-- Achievement |H1:achievement:33753|h|h etc (not searched a lot, was easy)
	-- DisplayName = |H1:display:Ayantir|h[@Ayantir]|h = [@Ayantir] -> link to DisplayName @Ayantir
	-- Book = |H1:book:186|h|h = [Climat de guerre] in french -> Link to book 186 .. GetLoreBookTitleFromLink()
	-- rChat = |H1:RCHAT_LINK:124:11|h[06:18]|h = [06:18] (here 0 is the line number reference and 11 is the chanCode) - URL handling : if chanCode = 97, it will popup a dialog to open internet browser
	-- Character = |H1:character:salhamandhil^Mx|h[salhamandhil]|h = text (is there anything which link Characters into a message ?) (here salhamandhil is with brackets volontary)
	-- Need to do quest_items too. |H1:quest_item:4275|h|h
	
	newtext = string.gsub(newtext, "|H(.-):(.-)|h(.-)|h", function (linkStyle, data, text)
		-- linkStyle = style (ignored by game, seems to be often 1)
		-- data = data saparated by ":"
		-- text = text displayed, used for Channels, DisplayName, Character, and some fake itemlinks (used by addons)
		
		-- linktype is : item, achievement, character, channel, book, display, rchatlink
		-- DOES NOT HANDLE ADDONS LINKTYPES
		
		-- for all types, only param1 is important
		local linkType, param1 = zo_strsplit(':', data)
		
		-- param1 : itemID
		-- Need to get
		if linkType == ITEM_LINK_TYPE or linkType == COLLECTIBLE_LINK_TYPE then
			-- Fakelink and GetItemLinkName
			return "[" .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H" .. linkStyle ..":" .. data .. "|h|h")) .. "]"
		-- param1 : achievementID
		elseif linkType == ACHIEVEMENT_LINK_TYPE then
			-- zo_strformat to avoid masculine/feminine problems
			return "[" .. zo_strformat(GetAchievementInfo(param1)) .. "]"
		-- SysMessages Links CharacterNames
		elseif linkType == CHARACTER_LINK_TYPE then
			return text
		elseif linkType == CHANNEL_LINK_TYPE then
			return text
		elseif linkType == BOOK_LINK_TYPE then
			return "[" .. GetLoreBookTitleFromLink(newtext) .. "]"
		-- SysMessages Links DysplayNames
		elseif linkType == DISPLAY_NAME_LINK_TYPE then
			-- No formatting here
			return "[@" .. param1 .. "]"
		-- Used for Sysmessages
		elseif linkType == "quest_item" then
			-- No formatting here
			return "[" .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetQuestItemNameFromLink(newtext)) .. "]"
		elseif linkType == RCHAT_LINK then
			-- No formatting here .. maybe yes ?..
			return text
		end
	end)

	return newtext
	
end

function automatedMessagesList:SetupEntry(control, data)
	
	control.data = data
	control.name = GetControl(control, "Name")
	control.message = GetControl(control, "Message")
	
	local messageTrunc = FormatRawText(data.message)
	if string.len(messageTrunc) > 53 then
		messageTrunc = string.sub(messageTrunc, 1, 53) .. " .."
	end
	
	control.name:SetText(data.name)
	control.message:SetText(messageTrunc)
	
	ZO_SortFilterList.SetupRow(self, control, data)
	
end

function automatedMessagesList:BuildMasterList()
	self.masterList = {}
	local messages = db.automatedMessages
	if messages then
		for k, v in ipairs(messages) do
			local data = v
			table.insert(self.masterList, data)
		end
	end
	
end

function automatedMessagesList:SortScrollList()
	local scrollData = ZO_ScrollList_GetDataList(self.list)
	table.sort(scrollData, self.sortFunction)
end

function automatedMessagesList:FilterScrollList()
	local scrollData = ZO_ScrollList_GetDataList(self.list)
	ZO_ClearNumericallyIndexedTable(scrollData)

	for i = 1, #self.masterList do
		local data = self.masterList[i]
		table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
	end
end

local function GetDataByNameInSavedAutomatedMessages(name)
	local dataList = db.automatedMessages
	for index, data in ipairs(dataList) do
		if(data.name == name) then
			return data, index
		end
	end
end

local function GetDataByNameInAutomatedMessages(name)
	local dataList = rChatData.automatedMessagesList.list.data
	for i = 1, #dataList do
		local data = dataList[i].data
		if(data.name == name) then
			return data, index
		end
	end
end

local function SaveAutomatedMessage(name, message, isNew)
	
	if db then
		
		local alreadyFav = false
		
		if isNew then
			for k, v in pairs(db.automatedMessages) do
				if "!" .. name == v.name then
					alreadyFav = true
				end
			end
		end
		
		if not alreadyFav then
			
			rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(true)
			rChatXMLAutoMsg:GetNamedChild("Warning"):SetText("")
			
			if string.len(name) > 12 then
				name = string.sub(name, 1, 12)
			end
			
			if string.len(message) > 351 then
				message = string.sub(message, 1, 351)
			end
			
			local entryList = ZO_ScrollList_GetDataList(rChatData.automatedMessagesList.list)
			
			if isNew then
				local data = {name = "!" .. name, message = message}
				local entry = ZO_ScrollList_CreateDataEntry(1, data)
				table.insert(entryList, entry)
				table.insert(db.automatedMessages, {name = "!" .. name, message = message}) -- "data" variable is modified by ZO_ScrollList_CreateDataEntry and will crash eso if saved to savedvars
			else
				
				local data = GetDataByNameInAutomatedMessages(name)
				local _, index = GetDataByNameInSavedAutomatedMessages(name)
				
				data.message = message
				db.automatedMessages[index].message = message
			end
			
			ZO_ScrollList_Commit(rChatData.automatedMessagesList.list)
			
		else
			rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(false)
			rChatXMLAutoMsg:GetNamedChild("Warning"):SetText(GetString(RCHAT_SAVMSGERRALREADYEXISTS))
			rChatXMLAutoMsg:GetNamedChild("Warning"):SetColor(1, 0, 0)
			zo_callLater(function() rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(true) end, 5000)
		end
		
	end

end

local function CleanAutomatedMessageListForDB()
	-- :RefreshData() adds dataEntry recursively, delete it to avoid overflow in SavedVars
	for k, v in ipairs(db.automatedMessages) do
		if v.dataEntry then
			v.dataEntry = nil
		end
	end
end

local function RemoveAutomatedMessage()

	local data = ZO_ScrollList_GetData(WINDOW_MANAGER:GetMouseOverControl())
	local _, index = GetDataByNameInSavedAutomatedMessages(data.name)
	table.remove(db.automatedMessages, index)
	rChatData.automatedMessagesList:RefreshData()
	CleanAutomatedMessageListForDB()

end

-- Init Automated messages, build the scene and handle array of automated strings
local function InitAutomatedMessages()
	
	-- Create Scene
	RCHAT_AUTOMSG_SCENE = ZO_Scene:New("rChatAutomatedMessagesScene", SCENE_MANAGER)	
	
	-- Mouse standard position and background
	RCHAT_AUTOMSG_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	RCHAT_AUTOMSG_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
	
	-- Background Right, it will set ZO_RightPanelFootPrint and its stuff.
	RCHAT_AUTOMSG_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
	
	-- The title fragment
	RCHAT_AUTOMSG_SCENE:AddFragment(TITLE_FRAGMENT)
	
	-- Set Title
	ZO_CreateStringId("SI_RCHAT_AUTOMSG_TITLE", ADDON_NAME)	
	RCHAT_AUTOMSG_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_RCHAT_AUTOMSG_TITLE)
	RCHAT_AUTOMSG_SCENE:AddFragment(RCHAT_AUTOMSG_TITLE_FRAGMENT)
	
	-- Add the XML to our scene
	RCHAT_AUTOMSG_SCENE_WINDOW = ZO_FadeSceneFragment:New(rChatXMLAutoMsg)
	RCHAT_AUTOMSG_SCENE:AddFragment(RCHAT_AUTOMSG_SCENE_WINDOW)
	
	-- Register Scenes and the group name
	SCENE_MANAGER:AddSceneGroup("rChatSceneGroup", ZO_SceneGroup:New("rChatAutomatedMessagesScene"))
	
	-- Its infos
	RCHAT_MAIN_MENU_CATEGORY_DATA =
	{
		binding = "RCHAT_SHOW_AUTO_MSG",
		categoryName = RCHAT_SHOW_AUTO_MSG,
		normal = "EsoUI/Art/MainMenu/menuBar_champion_up.dds",
		pressed = "EsoUI/Art/MainMenu/menuBar_champion_down.dds",
		highlight = "EsoUI/Art/MainMenu/menuBar_champion_over.dds",
	}
	
	MENU_CATEGORY_RCHAT = LMM:AddCategory(RCHAT_MAIN_MENU_CATEGORY_DATA)
	
	local iconData = {
		{
		categoryName = SI_BINDING_NAME_RCHAT_SHOW_AUTO_MSG,
		descriptor = "rChatAutomatedMessagesScene",
		normal = "EsoUI/Art/MainMenu/menuBar_champion_up.dds",
		pressed = "EsoUI/Art/MainMenu/menuBar_champion_down.dds",
		highlight = "EsoUI/Art/MainMenu/menuBar_champion_over.dds",
		},
	}
	
	-- Register the group and add the buttons (we cannot all AddRawScene, only AddSceneGroup, so we emulate both functions).
	LMM:AddSceneGroup(MENU_CATEGORY_RCHAT, "rChatSceneGroup", iconData)
	
	rChatData.autoMsgDescriptor = { 
		alignment = KEYBIND_STRIP_ALIGN_CENTER,
		{
			name = GetString(RCHAT_AUTOMSG_ADD_AUTO_MSG),
			keybind = "UI_SHORTCUT_PRIMARY",
			control = self,
			callback = function(descriptor) ZO_Dialogs_ShowDialog("RCHAT_AUTOMSG_SAVE_MSG", nil, {mainTextParams = {functionName}}) end, 
			visible = function(descriptor) return true end
		},
		{
			name = GetString(RCHAT_AUTOMSG_EDIT_AUTO_MSG),
			keybind = "UI_SHORTCUT_SECONDARY",
			control = self,
			callback = function(descriptor) ZO_Dialogs_ShowDialog("RCHAT_AUTOMSG_EDIT_MSG", nil, {mainTextParams = {functionName}}) end, 
			visible = function(descriptor)
				if rChatData.autoMessagesShowKeybind then
					return true
				else
					return false
				end
			end
		},
		{
			name = GetString(RCHAT_AUTOMSG_REMOVE_AUTO_MSG),
			keybind = "UI_SHORTCUT_NEGATIVE",
			control = self,
			callback = function(descriptor) RemoveAutomatedMessage() end, 
			visible = function(descriptor)
				if rChatData.autoMessagesShowKeybind then
					return true
				else
					return false
				end
			end
		},
	}
	
	rChatData.rChatAutomatedMessagesScene = SCENE_MANAGER:GetScene("rChatAutomatedMessagesScene")
	rChatData.rChatAutomatedMessagesScene:RegisterCallback("StateChange", function(oldState, newState)
		if newState == SCENE_SHOWING then
			KEYBIND_STRIP:AddKeybindButtonGroup(rChatData.autoMsgDescriptor)
		elseif newState == SCENE_HIDDEN then
			if KEYBIND_STRIP:HasKeybindButtonGroup(rChatData.autoMsgDescriptor) then
				KEYBIND_STRIP:RemoveKeybindButtonGroup(rChatData.autoMsgDescriptor) 
			end
		end
	end)
	
	if not db.automatedMessages then
		db.automatedMessages = {}
	end
	
	rChatData.automatedMessagesList = automatedMessagesList:New(rChatXMLAutoMsg)
	rChatData.automatedMessagesList:RefreshData()
	CleanAutomatedMessageListForDB()
	
	rChatData.automatedMessagesList.keybindStripDescriptor = rChatData.autoMsgDescriptor
	
end

-- Called by XML
function rChat_HoverRowOfAutomatedMessages(control)
	rChatData.autoMessagesShowKeybind = true
	rChatData.automatedMessagesList:Row_OnMouseEnter(control)
end

-- Called by XML
function rChat_ExitRowOfAutomatedMessages(control)
	rChatData.autoMessagesShowKeybind = false
	rChatData.automatedMessagesList:Row_OnMouseExit(control)
end

-- Called by XML
function rChat_BuildAutomatedMessagesDialog(control)

	local function AddDialogSetup(dialog, data)
		
		local name = GetControl(dialog, "NameEdit")
		local message = GetControl(dialog, "MessageEdit")
		
		name:SetText("")
		message:SetText("")
		name:SetEditEnabled(true)
		
	end

	ZO_Dialogs_RegisterCustomDialog("RCHAT_AUTOMSG_SAVE_MSG", 
	{
		customControl = control,
		setup = AddDialogSetup,
		title =
		{
			text = RCHAT_AUTOMSG_ADD_TITLE_HEADER,
		},
		buttons =
		{
			[1] =
			{
				control  = GetControl(control, "Request"),
				text	 = RCHAT_AUTOMSG_ADD_AUTO_MSG,
				callback = function(dialog)
					local name = GetControl(dialog, "NameEdit"):GetText()
					local message = GetControl(dialog, "MessageEdit"):GetText()
					if(name ~= "") and (message ~= "") then
						SaveAutomatedMessage(name, message, true)
					end
				end,
			},
			[2] =
			{
				control = GetControl(control, "Cancel"),
				text = SI_DIALOG_CANCEL,
			}
		}
	})
	
	local function EditDialogSetup(dialog)
		local data = ZO_ScrollList_GetData(WINDOW_MANAGER:GetMouseOverControl())
		local name = GetControl(dialog, "NameEdit")
		local edit = GetControl(dialog, "MessageEdit")
		
		
		name:SetText(data.name)
		name:SetEditEnabled(false)
		edit:SetText(data.message)
		edit:TakeFocus()
		
	end

	ZO_Dialogs_RegisterCustomDialog("RCHAT_AUTOMSG_EDIT_MSG", 
	{
		customControl = control,
		setup = EditDialogSetup,
		title =
		{
			text = RCHAT_AUTOMSG_EDIT_TITLE_HEADER,
		},
		buttons =
		{
			[1] =
			{
				control  = GetControl(control, "Request"),
				text	 = RCHAT_AUTOMSG_EDIT_AUTO_MSG,
				callback = function(dialog)
					local name = GetControl(dialog, "NameEdit"):GetText()
					local message = GetControl(dialog, "MessageEdit"):GetText()
					if(name ~= "") and (message ~= "") then
						SaveAutomatedMessage(name, message, false)
					end
				end,
			},
			[2] =
			{
				control = GetControl(control, "Cancel"),
				text = SI_DIALOG_CANCEL,
			}
		}
	})

end
-- **************************************************************************
-- Chat Tab Functions
-- **************************************************************************
local function getTabNames()
    local totalTabs = CHAT_SYSTEM.tabPool.m_Active
    if totalTabs ~= nil and #totalTabs >= 1 then
        tabNames = {}
        for idx, tmpTab in pairs(totalTabs) do
            local tabLabel = tmpTab:GetNamedChild("Text")
            local tmpTabName = tabLabel:GetText()
            if tmpTabName ~= nil and tmpTabName ~= "" then
                tabNames[idx] = tmpTabName
            end
        end
    end
end

local function getTabIdx (tabName)
	local tabIdx = 0
	local totalTabs = CHAT_SYSTEM.tabPool.m_Active
	for i = 1, #totalTabs do
		if tabNames[i] == tabName then
			tabIdx = i
		end
	end
	return tabIdx
end

-- Rewrite of a core function
function CHAT_SYSTEM.textEntry:AddCommandHistory(text)
	
	local currentChannel = CHAT_SYSTEM.currentChannel
	local currentTarget = CHAT_SYSTEM.currentTarget
	local rewritedText = text
	
	-- Don't add the switch when chat is restored
	if db.addChannelAndTargetToHistory and isAddonInitialized then
	
		local switch = CHAT_SYSTEM.switchLookup[0]
		
		-- It's a message
		switch = CHAT_SYSTEM.switchLookup[currentChannel]
		-- Below code suspected issue fix under comment - Bug ticket 2253 6/12/2018
		--[[
				rewritedText = string.format("%s ", switch)
		if currentTarget then
			rewritedText = string.format("%s%s ", rewritedText, currentTarget)
		end
		rewritedText = string.format("%s%s", rewritedText, text)
		]]--
		-- New code for bug ticket 2253 6/12/2018
		if switch ~= nil then
			rewritedText = string.format("%s ", switch)
			if currentTarget then
				rewritedText = string.format("%s%s ", rewritedText, currentTarget)
			end
			rewritedText = string.format("%s%s", rewritedText, text)
		end
	end
	
	CHAT_SYSTEM.textEntry.commandHistory:Add(rewritedText)
	CHAT_SYSTEM.textEntry.commandHistoryCursor = CHAT_SYSTEM.textEntry.commandHistory:Size() + 1
	
end

-- Rewrite of a core function
function CHAT_SYSTEM.textEntry:GetText()
	local text = self.editControl:GetText()
	
	if text ~= "" then
		if string.sub(text,1,1) == "!" then
			if string.len(text) <= 12 then
				
				local automatedMessage = true
				for k, v in ipairs(db.automatedMessages) do
					if v.name == text then
						text = db.automatedMessages[k].message
						automatedMessage = true
					end
				end
			
				if automatedMessage then
					
					if string.len(text) < 1 or string.len(text) > 351 then
						text = self.editControl:GetText()
					end
					
					if self.ignoreTextEntryChangedEvent then return end
					self.ignoreTextEntryChangedEvent = true
					
					local spaceStart, spaceEnd = zo_strfind(text, " ", 1, true)
					
					if spaceStart and spaceStart > 1 then
						local potentialSwitch = zo_strsub(text, 1, spaceStart - 1)
						local switch = CHAT_SYSTEM.switchLookup[potentialSwitch:lower()]

						local valid, switchArg, deferredError, spaceStartOverride = CHAT_SYSTEM:ValidateSwitch(switch, text, spaceStart)

						if valid then
							if(deferredError) then
								self.requirementErrorMessage = switch.requirementErrorMessage
								if self.requirementErrorMessage then
									if type(self.requirementErrorMessage) == "string" then
										CHAT_SYSTEM:AddMessage(self.requirementErrorMessage)
									elseif type(self.requirementErrorMessage) == "function" then
										CHAT_SYSTEM:AddMessage(self.requirementErrorMessage())
									end
								end
							else
								self.requirementErrorMessage = nil
							end

							CHAT_SYSTEM:SetChannel(switch.id, switchArg)
							local oldCursorPos = CHAT_SYSTEM.textEntry:GetCursorPosition()

							spaceStart = spaceStartOverride or spaceStart
							CHAT_SYSTEM.textEntry:SetText(zo_strsub(text, spaceStart + 1))
							text = zo_strsub(text, spaceStart + 1)
							CHAT_SYSTEM.textEntry:SetCursorPosition(oldCursorPos - spaceStart)
						end
					end
					
					self.ignoreTextEntryChangedEvent = false
					
				end
			end
		end
	end
	
	return text
	
end

-- Change ChatWindow Darkness by modifying its <Center> & <Edge>. Originally defined in virtual object ZO_ChatContainerTemplate in sharedchatsystem.xml
local function ChangeChatWindowDarkness(changeSetting)

	if dbWindowDarkness == 0 then 
		ZO_ChatWindowBg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
		ZO_ChatWindowBg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, 32)
	else
		ZO_ChatWindowBg:SetCenterColor(0, 0, 0, 1)
		ZO_ChatWindowBg:SetEdgeColor(0, 0, 0, 1)
		if db.windowDarkness == 11 and changeSetting then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_100.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_100.dds", 256, 256, 32)
		elseif db.windowDarkness == 10 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_90.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_90.dds", 256, 256, 32)
		elseif db.windowDarkness == 9 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_80.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_80.dds", 256, 256, 32)
		elseif db.windowDarkness == 8 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_70.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_70.dds", 256, 256, 32)
		elseif db.windowDarkness == 7 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_60.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_60.dds", 256, 256, 32)
		elseif db.windowDarkness == 6 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_50.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_50.dds", 256, 256, 32)
		elseif db.windowDarkness == 5 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_40.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_40.dds", 256, 256, 32)
		elseif db.windowDarkness == 4 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_30.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_30.dds", 256, 256, 32)
		elseif db.windowDarkness == 3 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_20.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_20.dds", 256, 256, 32)
		elseif db.windowDarkness == 2 then
			ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_10.dds")
			ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_10.dds", 256, 256, 32)
		elseif db.windowDarkness == 1 then
			ZO_ChatWindowBg:SetCenterColor(0, 0, 0, 0)
			ZO_ChatWindowBg:SetEdgeColor(0, 0, 0, 0)
		end
	end
end

-- Add IM label on XML Initialization, set anchor and set it hidden
function rChat_AddIMLabel(control)
	
	control:SetParent(CHAT_SYSTEM.control)
	control:ClearAnchors()
	control:SetAnchor(RIGHT, ZO_ChatWindowOptions, LEFT, -5, 32)
	CHAT_SYSTEM.IMLabel = control

end

-- Add IM label on XML Initialization, set anchor and set it hidden. Used for Chat Minibar
function rChat_AddIMLabelMin(control)
	
	control:SetParent(CHAT_SYSTEM.control)
	control:ClearAnchors()
	control:SetAnchor(BOTTOM, CHAT_SYSTEM.minBar.maxButton, TOP, 2, 0)
	CHAT_SYSTEM.IMLabelMin = control

end

-- Add IM close button on XML Initialization, set anchor and set it hidden
function rChat_AddIMButton(control)
	
	control:SetParent(CHAT_SYSTEM.control)
	control:ClearAnchors()
	control:SetAnchor(RIGHT, ZO_ChatWindowOptions, LEFT, 2, 35)
	CHAT_SYSTEM.IMbutton = control

end

-- Hide it
local function HideIMTooltip()
	ClearTooltip(InformationTooltip)
end

-- Show IM notification tooltip
local function ShowIMTooltip(self, lineNumber)

	if db.LineStrings[lineNumber] then

		local sender = db.LineStrings[lineNumber].rawFrom
		local text = db.LineStrings[lineNumber].rawMessage
		
		if (not IsDecoratedDisplayName(sender)) then
			sender = zo_strformat(SI_UNIT_NAME, sender)
		end
		
		InitializeTooltip(InformationTooltip, self, BOTTOMLEFT, 0, 0, TOPRIGHT)
		InformationTooltip:AddLine(sender, "ZoFontGame", 1, 1, 1, TOPLEFT, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)
		
		local r, g, b = ZO_NORMAL_TEXT:UnpackRGB()
		InformationTooltip:AddLine(text, "ZoFontGame", r, g, b, TOPLEFT, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)
		
	end

end

-- When an incoming Whisper is received
local function OnIMReceived(from, lineNumber)
	
	-- Display visual notification
	if db.notifyIM then
		
		-- If chat minimized, show the minified button
		if (CHAT_SYSTEM:IsMinimized()) then
			CHAT_SYSTEM.IMLabelMin:SetHandler("OnMouseEnter", function(self) ShowIMTooltip(self, lineNumber) end)
			CHAT_SYSTEM.IMLabelMin:SetHandler("OnMouseExit", HideIMTooltip)
			CHAT_SYSTEM.IMLabelMin:SetHidden(false)
		else
			-- Chat maximized
			local _, scrollMax = CHAT_SYSTEM.primaryContainer.scrollbar:GetMinMax()
			
			-- If whispers not show in the tab or we don't scroll at bottom
			if ((not IsChatContainerTabCategoryEnabled(1, rChatData.activeTab, CHAT_CATEGORY_WHISPER_INCOMING)) or (IsChatContainerTabCategoryEnabled(1, rChatData.activeTab, CHAT_CATEGORY_WHISPER_INCOMING) and CHAT_SYSTEM.primaryContainer.scrollbar:GetValue() < scrollMax)) then
				
				-- Undecorate (^F / ^M)
				if (not IsDecoratedDisplayName(from)) then
					from = zo_strformat(SI_UNIT_NAME, from)
				end
				
				-- Split if name too long
				local displayedFrom = from
				if string.len(displayedFrom) > 8 then
					displayedFrom = string.sub(from, 1, 7) .. ".."
				end
				
				-- Show
				CHAT_SYSTEM.IMLabel:SetText(displayedFrom)
				CHAT_SYSTEM.IMLabel:SetHidden(false)
				CHAT_SYSTEM.IMbutton:SetHidden(false)
				
				-- Add handler
				CHAT_SYSTEM.IMLabel:SetHandler("OnMouseEnter", function(self) ShowIMTooltip(self, lineNumber) end)
				CHAT_SYSTEM.IMLabel:SetHandler("OnMouseExit", function(self) HideIMTooltip() end)
			end
		end
		
	end

end

-- Hide IM notification when click on it. Can be Called by XML
function rChat_RemoveIMNotification()
	CHAT_SYSTEM.IMLabel:SetHidden(true)
	CHAT_SYSTEM.IMLabelMin:SetHidden(true)
	CHAT_SYSTEM.IMbutton:SetHidden(true)
end

-- Will try to display the notified IM. Called by XML
function rChat_TryToJumpToIm(isMinimized)
	
	-- Show chat first
	if isMinimized then
		CHAT_SYSTEM:Maximize()
		CHAT_SYSTEM.IMLabelMin:SetHidden(true)
	end
	
	-- Tab get IM, scroll
	if IsChatContainerTabCategoryEnabled(1, rChatData.activeTab, CHAT_CATEGORY_WHISPER_INCOMING) then
		ZO_ChatSystem_ScrollToBottom(CHAT_SYSTEM.control)
		rChat_RemoveIMNotification()
	else
		
		-- Tab don't have IM's, switch to next
		local numTabs = #CHAT_SYSTEM.primaryContainer.windows
		local actualTab = rChatData.activeTab + 1
		local oldActiveTab = rChatData.activeTab
		local PRESSED = 1
		local UNPRESSED = 2
		local hasSwitched = false
		local maxt = 1
		
		while actualTab <= numTabs and (not hasSwitched) do
			if IsChatContainerTabCategoryEnabled(1, actualTab, CHAT_CATEGORY_WHISPER_INCOMING) then
			
				CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[actualTab].tab)
				
				local tabText = GetControl("ZO_ChatWindowTabTemplate" .. actualTab .. "Text")
				tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
				tabText:GetParent().state = PRESSED
				local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. oldActiveTab .. "Text")
				oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
				oldTabText:GetParent().state = UNPRESSED
				ZO_ChatSystem_ScrollToBottom(CHAT_SYSTEM.control)
				
				hasSwitched = true
			else
				actualTab = actualTab + 1
			end
		end
			
		actualTab = 1
		
		-- If we were on tab #3 and IM are show on tab #2, need to restart from 1
		while actualTab < oldActiveTab and (not hasSwitched) do
			if IsChatContainerTabCategoryEnabled(1, actualTab, CHAT_CATEGORY_WHISPER_INCOMING) then
			
				CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[actualTab].tab)
				
				local tabText = GetControl("ZO_ChatWindowTabTemplate" .. actualTab .. "Text")
				tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
				tabText:GetParent().state = PRESSED
				local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. oldActiveTab .. "Text")
				oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
				oldTabText:GetParent().state = UNPRESSED
				ZO_ChatSystem_ScrollToBottom(CHAT_SYSTEM.control)
				
				hasSwitched = true
			else
				actualTab = actualTab + 1
			end
		end
		
	end
	
end

-- Rewrite of a core function, if user click on the scroll to bottom button, Hide IM notification
-- Todo: Hide IM when user manually scroll to the bottom
function ZO_ChatSystem_ScrollToBottom(control)

	CHAT_SYSTEM.IMbutton:SetHidden(true)
	CHAT_SYSTEM.IMLabel:SetHidden(true)
	control.container:ScrollToBottom()
	
end

-- Set copied text into text entry, if possible
local function CopyToTextEntry(message)

	-- Max of inputbox is 351 chars
	if string.len(message) < 351 then
		if CHAT_SYSTEM.textEntry:GetText() == "" then
			CHAT_SYSTEM.textEntry:Open(message)
			ZO_ChatWindowTextEntryEditBox:SelectAll()
		end
	end

end

-- Copy message (only message)
local function CopyMessage(numLine)
	-- Args are passed as string trought LinkHandlerSystem
	CopyToTextEntry(db.LineStrings[numLine].rawMessage)
end

--Copy line (including timestamp, from, channel, message, etc)
local function CopyLine(numLine)
	-- Args are passed as string trought LinkHandlerSystem
	CopyToTextEntry(db.LineStrings[numLine].rawLine)
end

-- Popup a dialog message with text to copy
local function ShowCopyDialog(message)

	-- Split text, courtesy of LibOrangUtils, modified to handle multibyte characters
	local function str_lensplit(text, maxChars)

		local ret					= {}
		local text_len				= string.len(text)
		local UTFAditionalBytes	= 0
		local fromWithUTFShift	= 0
		local doCut					= true
		
		if(text_len <= maxChars) then
			ret[#ret+1] = text
		else
		
			local splittedStart = 0
			local splittedEnd = splittedStart + maxChars - 1
		
			while doCut do
				
				if UTFAditionalBytes > 0 then
					fromWithUTFShift = UTFAditionalBytes
				else
					fromWithUTFShift = 0
				end
				
				local UTFAditionalBytes = 0
				
				splittedEnd = splittedStart + maxChars - 1
				
				if(splittedEnd >= text_len) then
					splittedEnd = text_len
					doCut = false
				elseif (string.byte(text, splittedEnd, splittedEnd)) > 128 then
					UTFAditionalBytes = 1
					
					local lastByte = string.byte(splittedString, -1)
					local beforeLastByte = string.byte(splittedString, -2, -2)
					
					if (lastByte < 128) then
						--
					elseif lastByte >= 128 and lastByte < 192 then
						
						if beforeLastByte >= 192 and beforeLastByte < 224 then
							--
						elseif beforeLastByte >= 128 and beforeLastByte < 192 then
							--
						elseif beforeLastByte >= 224 and beforeLastByte < 240 then
							UTFAditionalBytes = 1
						end
						
						splittedEnd = splittedEnd + UTFAditionalBytes
						splittedString = text:sub(splittedStart, splittedEnd)
						
					elseif lastByte >= 192 and lastByte < 224 then
						UTFAditionalBytes = 1
						splittedEnd = splittedEnd + UTFAditionalBytes
					elseif lastByte >= 224 and lastByte < 240 then
						UTFAditionalBytes = 2
						splittedEnd = splittedEnd + UTFAditionalBytes
					end
					
				end
				
				--ret = ret+1
				ret[#ret+1] = string.sub(text, splittedStart, splittedEnd)
				
				splittedStart = splittedEnd + 1
				
			end
		end
		
		return ret
		
	end
	
	local maxChars		= 20000
	
	-- editbox is 20000 chars max
	if string.len(message) < maxChars then
		rChatCopyDialogTLCTitle:SetText(GetString(RCHAT_COPYXMLTITLE))
		rChatCopyDialogTLCLabel:SetText(GetString(RCHAT_COPYXMLLABEL))
		rChatCopyDialogTLCNoteEdit:SetText(message)
		rChatCopyDialogTLCNoteNext:SetHidden(true)
		rChatCopyDialogTLC:SetHidden(false)
		rChatCopyDialogTLCNoteEdit:SetEditEnabled(false)
		rChatCopyDialogTLCNoteEdit:SelectAll()
	else
		
		rChatCopyDialogTLCTitle:SetText(GetString(RCHAT_COPYXMLTITLE))
		rChatCopyDialogTLCLabel:SetText(GetString(RCHAT_COPYXMLTOOLONG))
		
		rChatData.messageTableId = 1
		rChatData.messageTable = str_lensplit(message, maxChars)
		rChatCopyDialogTLCNoteNext:SetText(GetString(RCHAT_COPYXMLNEXT) .. " ( " .. rChatData.messageTableId .. " / " .. #rChatData.messageTable .. " )")
		rChatCopyDialogTLCNoteEdit:SetText(rChatData.messageTable[rChatData.messageTableId])
		rChatCopyDialogTLCNoteEdit:SetEditEnabled(false)
		rChatCopyDialogTLCNoteEdit:SelectAll()
		
		rChatCopyDialogTLC:SetHidden(false)
		rChatCopyDialogTLCNoteNext:SetHidden(false)
		
		rChatCopyDialogTLCNoteEdit:TakeFocus()
		
	end
	
end

-- Copy discussion
-- It will copy all text mark with the same chanCode
-- Todo : Whisps by person
local function CopyDiscussion(chanNumber, numLine)

	-- Args are passed as string trought LinkHandlerSystem
	local numChanCode = tonumber(chanNumber)
	-- Whispers sent and received together
	if numChanCode == CHAT_CHANNEL_WHISPER_SENT then
		numChanCode = CHAT_CHANNEL_WHISPER
	elseif numChanCode == RCHAT_URL_CHAN then
		numChanCode = db.LineStrings[numLine].channel
	end
	
	local stringToCopy = ""
	for k, data in ipairs(db.LineStrings) do
		if numChanCode == CHAT_CHANNEL_WHISPER or numChanCode == CHAT_CHANNEL_WHISPER_SENT then
			if data.channel == CHAT_CHANNEL_WHISPER or data.channel == CHAT_CHANNEL_WHISPER_SENT then
				if stringToCopy == "" then
					stringToCopy = db.LineStrings[k].rawLine
				else
					stringToCopy = stringToCopy .. "\r\n" .. db.LineStrings[k].rawLine
				end
			end
		elseif data.channel == numChanCode then
			if stringToCopy == "" then
				stringToCopy = db.LineStrings[k].rawLine
			else
				stringToCopy = stringToCopy .. "\r\n" .. db.LineStrings[k].rawLine
			end
		end
	end
	
	ShowCopyDialog(stringToCopy)
	
end

-- Copy Whole chat (not tab)
local function CopyWholeChat()

	local stringToCopy = ""
	for k, data in ipairs(db.LineStrings) do
		if stringToCopy == "" then
			stringToCopy = db.LineStrings[k].rawLine
		else
			stringToCopy = stringToCopy .. "\r\n" .. db.LineStrings[k].rawLine
		end
	end
	
	ShowCopyDialog(stringToCopy)
	
end

-- Show contextualMenu when clicking on a rChatLink
local function ShowContextMenuOnHandlers(numLine, chanNumber)
	
	ClearMenu()
	
	if not ZO_Dialogs_IsShowingDialog() then
		AddMenuItem(GetString(RCHAT_COPYMESSAGECT), function() CopyMessage(numLine) end)
		AddMenuItem(GetString(RCHAT_COPYLINECT), function() CopyLine(numLine) end)
		AddMenuItem(GetString(RCHAT_COPYDISCUSSIONCT), function() CopyDiscussion(chanNumber, numLine) end)
		AddMenuItem(GetString(RCHAT_ALLCT), CopyWholeChat)
	end
	
	ShowMenu()
		
end

-- Triggers when right clicking on a LinkHandler
local function OnLinkClicked(rawLink, mouseButton, linkText, color, linkType, lineNumber, chanCode)
	
	-- Only executed on LinkType = RCHAT_LINK
	if linkType == RCHAT_LINK then
		
		local chanNumber = tonumber(chanCode)
		local numLine = tonumber(lineNumber)
		-- RCHAT_LINK also handle a linkable channel feature for linkable channels
		
		-- Context Menu
		if chanCode and mouseButton == MOUSE_BUTTON_INDEX_LEFT then
		
			-- Only Linkable channel - TODO use .channelLinkable
			if chanNumber == CHAT_CHANNEL_SAY
			or chanNumber == CHAT_CHANNEL_YELL
			or chanNumber == CHAT_CHANNEL_PARTY
			or chanNumber == CHAT_CHANNEL_ZONE
			or chanNumber == CHAT_CHANNEL_ZONE_LANGUAGE_1
			or chanNumber == CHAT_CHANNEL_ZONE_LANGUAGE_2
			or chanNumber == CHAT_CHANNEL_ZONE_LANGUAGE_3
			or chanNumber == CHAT_CHANNEL_ZONE_LANGUAGE_4
			or (chanNumber >= CHAT_CHANNEL_GUILD_1 and chanNumber <= CHAT_CHANNEL_GUILD_5)
			or (chanNumber >= CHAT_CHANNEL_OFFICER_1 and chanNumber <= CHAT_CHANNEL_OFFICER_5) then
				IgnoreMouseDownEditFocusLoss()
				CHAT_SYSTEM:StartTextEntry(nil, chanNumber)
			elseif chanNumber == CHAT_CHANNEL_WHISPER then
				local target = zo_strformat(SI_UNIT_NAME, db.LineStrings[numLine].rawFrom)
				IgnoreMouseDownEditFocusLoss()
				CHAT_SYSTEM:StartTextEntry(nil, chanNumber, target)
			elseif chanNumber == RCHAT_URL_CHAN then
				RequestOpenUnsafeURL(linkText)
			end
			
		elseif mouseButton == MOUSE_BUTTON_INDEX_RIGHT then
			-- Right clic, copy System
			ShowContextMenuOnHandlers(numLine, chanNumber)
		end
		
		-- Don't execute LinkHandler code
		return true
	
	end
	
end

local function CopyToTextEntryText()
	if db.enablecopy then
		LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, OnLinkClicked)
		LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, OnLinkClicked)
	end
end

-- Called by XML
function rChat_ShowCopyDialogNext()
	
	rChatData.messageTableId = rChatData.messageTableId + 1
	
	-- Security
	if rChatData.messageTable[rChatData.messageTableId] then
		
		-- Build button
		rChatCopyDialogTLCNoteNext:SetText(GetString(RCHAT_COPYXMLNEXT) .. " ( " .. rChatData.messageTableId .. " / " .. #rChatData.messageTable .. " )")
		rChatCopyDialogTLCNoteEdit:SetText(rChatData.messageTable[rChatData.messageTableId])
		rChatCopyDialogTLCNoteEdit:SetEditEnabled(false)
		rChatCopyDialogTLCNoteEdit:SelectAll()
		
		-- Don't show next button if its the last
		if not rChatData.messageTable[rChatData.messageTableId + 1] then
			rChatCopyDialogTLCNoteNext:SetHidden(true)
		end
		
		rChatCopyDialogTLCNoteEdit:TakeFocus()
		
	end
	
end

-- Needed to bind Shift+Tab in SetSwitchToNextBinding
function KEYBINDING_MANAGER:IsChordingAlwaysEnabled()
	return true
end

local function SetSwitchToNextBinding()

	ZO_CreateStringId("SI_BINDING_NAME_RCHAT_SWITCH_TAB", GetString(RCHAT_SWITCHTONEXTTABBINDING))

	-- get SwitchTab Keybind params
	local layerIndex, categoryIndex, actionIndex = GetActionIndicesFromName("RCHAT_SWITCH_TAB")
	
	--If exists
	if layerIndex and categoryIndex and actionIndex then
		
		local key = GetActionBindingInfo(layerIndex, categoryIndex, actionIndex, 1)
		
		if key == KEY_INVALID then
			-- Unbind it
			if IsProtectedFunction("UnbindAllKeysFromAction") then
				CallSecureProtected("UnbindAllKeysFromAction", layerIndex, categoryIndex, actionIndex)
			else
				UnbindAllKeysFromAction(layerIndex, categoryIndex, actionIndex)
			end
			
			-- Set it to its default value
			if IsProtectedFunction("BindKeyToAction") then
				CallSecureProtected("BindKeyToAction", layerIndex, categoryIndex, actionIndex, 1, KEY_TAB, 0, 0, KEY_SHIFT, 0)
			else
				BindKeyToAction(layerIndex, categoryIndex, actionIndex, 1, KEY_TAB , 0, 0, KEY_SHIFT, 0)
			end
		end
		
	end
	
end

-- Can be called by Bindings
function rChat_SwitchToNextTab()
	
	local hasSwitched
	
	local PRESSED = 1
	local UNPRESSED = 2
	local numTabs = #CHAT_SYSTEM.primaryContainer.windows
	
	if numTabs > 1 then
		for numTab, container in ipairs (CHAT_SYSTEM.primaryContainer.windows) do
			
			if (not hasSwitched) then
				if rChatData.activeTab + 1 == numTab then
					CHAT_SYSTEM.primaryContainer:HandleTabClick(container.tab)
					
					local tabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab .. "Text")
					tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
					tabText:GetParent().state = PRESSED
					local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab - 1 .. "Text")
					oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
					oldTabText:GetParent().state = UNPRESSED
					
					hasSwitched = true
				end
			end
			
		end
		
		if (not hasSwitched) then
			CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[1].tab)
			local tabText = GetControl("ZO_ChatWindowTabTemplate1Text")
			tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
			tabText:GetParent().state = PRESSED
			local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. #CHAT_SYSTEM.primaryContainer.windows .. "Text")
			oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
			oldTabText:GetParent().state = UNPRESSED
		end
	end
	
end
--**** Issue
local function SetDefaultTab(tabToSet)
	
	-- Search in all tabs the good name
	for numTab in ipairs(CHAT_SYSTEM.primaryContainer.windows) do
		-- Not this one, try the next one, if tab is not found (newly added, removed), rChat_SwitchToNextTab() will go back to tab 1
		if tonumber(tabToSet) ~= numTab then
			rChat_SwitchToNextTab()
		else
			-- Found it, stop
			return
		end
	end
end

function rChat_ChangeTab(tabToSet)
	if type(tabToSet)~="number" then return end
	local container=CHAT_SYSTEM.primaryContainer if not container then return end
	if tabToSet<1 or tabToSet>#container.windows then return end
	if container.windows[tabToSet].tab==nil then return end
	container.tabGroup:SetClickedButton(container.windows[tabToSet].tab)
	if CHAT_SYSTEM:IsMinimized() then CHAT_SYSTEM:Maximize() end
	local container=CHAT_SYSTEM.primaryContainer
	if not container then return end
	local tabToSet=container.currentBuffer:GetParent().tab.tabToSet

end

local function StripLinesFromLineStrings(typeOfExit)

	local k = 1
	-- First loop is time based. If message is older than our limit, it will be stripped.
	while k <= #db.LineStrings do
	
		if db.LineStrings[k] then
			local channel = db.LineStrings[k].channel
			if channel == CHAT_CHANNEL_SYSTEM and (not db.restoreSystem) then
				table.remove(db.LineStrings, k)
				db.lineNumber = db.lineNumber - 1
				k = k-1
			elseif channel ~= CHAT_CHANNEL_SYSTEM and db.restoreSystemOnly then
				table.remove(db.LineStrings, k)
				db.lineNumber = db.lineNumber - 1
				k = k-1
			elseif (channel == CHAT_CHANNEL_WHISPER or channel == CHAT_CHANNEL_WHISPER_SENT) and (not db.restoreWhisps) then
				table.remove(db.LineStrings, k)
				db.lineNumber = db.lineNumber - 1
				k = k-1
			elseif typeOfExit ~= 1 then
				if db.LineStrings[k].rawTimestamp then
					if (GetTimeStamp() - db.LineStrings[k].rawTimestamp) > (db.timeBeforeRestore * 60 * 60) then
						table.remove(db.LineStrings, k)
						db.lineNumber = db.lineNumber - 1
						k = k-1
					elseif db.LineStrings[k].rawTimestamp > GetTimeStamp() then -- System clock of users computer badly set and msg received meanwhile.
						table.remove(db.LineStrings, k)
						db.lineNumber = db.lineNumber - 1
						k = k-1
					end
				end
			end
		end
		
		k = k + 1
	
	end
	
	-- 2nd loop is size based. If dump is too big, just delete old ones
	if k > 5000 then
		local linesToDelete = k - 5000
		for l=1, linesToDelete do
		
			if db.LineStrings[l] then
				table.remove(db.LineStrings, l)
				db.lineNumber = db.lineNumber - 1
			end
		
		end
	end
	
end

local function SaveChatHistory(typeOf)
	
	db.history = {}
	
	if (db.restoreOnReloadUI == true and typeOf == 1) or (db.restoreOnLogOut == true and typeOf == 2) or (db.restoreOnAFK == true) or (db.restoreOnQuit == true and typeOf == 3) then	
	
		if typeOf == 1 then
			
			db.lastWasReloadUI = true
			db.lastWasLogOut = false
			db.lastWasQuit = false
			db.lastWasAFK = false
			
			--Save actual channel
			db.history.currentChannel = CHAT_SYSTEM.currentChannel
			db.history.currentTarget = CHAT_SYSTEM.currentTarget
			
		elseif typeOf == 2 then
			db.lastWasReloadUI = false
			db.lastWasLogOut = true
			db.lastWasQuit = false
			db.lastWasAFK = false
		elseif typeOf == 3 then
			db.lastWasReloadUI = false
			db.lastWasLogOut = false
			db.lastWasQuit = true
			db.lastWasAFK = false
		end
		
		db.history.currentTab = rChatData.activeTab
		
		-- Save Chat History isn't needed, because it's saved in realtime, but we can strip some lines from the array to avoid big dumps
		StripLinesFromLineStrings(typeOf)
		
		--Save TextEntry history
		db.history.textEntry = {}
		if CHAT_SYSTEM.textEntry.commandHistory.entries then
			db.history.textEntry.entries = CHAT_SYSTEM.textEntry.commandHistory.entries
			db.history.textEntry.numEntries = CHAT_SYSTEM.textEntry.commandHistory.index
		else
			db.history.textEntry.entries = {}
			db.history.textEntry.numEntries = 0
		end
	else
		db.LineStrings = {}
		db.lineNumber = 1
	end
	
end

local function CreateNewChatTabPostHook()

	for tabIndex, tabObject in ipairs(CHAT_SYSTEM.primaryContainer.windows) do
		if db.augmentHistoryBuffer then
			tabObject.buffer:SetMaxHistoryLines(1000) -- 1000 = max of control
		end
		if db.alwaysShowChat then
			tabObject.buffer:SetLineFade(3600, 2)
		end
	end
	
end

local function ShowFadedLines()

	local origChatSystemCreateNewChatTab = CHAT_SYSTEM.CreateNewChatTab
	CHAT_SYSTEM.CreateNewChatTab = function(self, ...)
		origChatSystemCreateNewChatTab(self, ...)
		CreateNewChatTabPostHook()
	end
	
end

local function OnReticleTargetChanged()
	if IsUnitPlayer("reticleover") then
		targetToWhisp = GetUnitName("reticleover")
	end
end

local function BuildNicknames(lamCall)
	
	local function Explode(div, str)
		if (div=='') then return false end
		local pos,arr = 0,{}
		for st,sp in function() return string.find(str,div,pos,true) end do
			table.insert(arr,string.sub(str,pos,st-1))
			pos = sp + 1
		end
		table.insert(arr,string.sub(str,pos))
		return arr
	end
	
	rChatData.nicknames = {}
	
	if db.nicknames ~= "" then
		local lines = Explode("\n", db.nicknames)
		
		for lineIndex=#lines, 1, -1 do
			local oldName, newName = string.match(lines[lineIndex], "(@?[%w_-]+) ?= ?([%w- ]+)")
			if not (oldName and newName) then
				table.remove(lines, lineIndex)
			else
				rChatData.nicknames[oldName] = newName
			end
		end
		
		db.nicknames = table.concat(lines, "\n")
		
		if lamCall then
			CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", rChatData.LAMPanel)
		end
		
	end
	
end

-- Change font of chat
local function ChangeChatFont(change)

	local fontSize = GetChatFontSize()
	
	if db.fonts == "ESO Standard Font" or db.fonts == "Univers 57" then
		return
	else
	
		local fontPath = LMP:Fetch("font", db.fonts)
		
		-- Entry Box
		ZoFontEditChat:SetFont(fontPath .. "|".. fontSize .. "|shadow")
		
		-- Chat window
		ZoFontChat:SetFont(fontPath .. "|" .. fontSize .. "|soft-shadow-thin")
	
	end

end

-- Rewrite of a core function
function CHAT_SYSTEM:UpdateTextEntryChannel()
	
	local channelData = self.channelData[self.currentChannel]
	
	if channelData then
		self.textEntry:SetChannel(channelData, self.currentTarget)
		
		if isAddonLoaded then
			if not db.useESOcolors then
				
				local rChatcolor
				if db.allGuildsSameColour and (self.currentChannel >= CHAT_CHANNEL_GUILD_1 and self.currentChannel <= CHAT_CHANNEL_GUILD_5) then
					rChatcolor = db.colours[2*CHAT_CHANNEL_GUILD_1]
				elseif db.allGuildsSameColour and (self.currentChannel >= CHAT_CHANNEL_OFFICER_1 and self.currentChannel <= CHAT_CHANNEL_OFFICER_5) then
					rChatcolor = db.colours[2*CHAT_CHANNEL_OFFICER_1]
				elseif db.allZonesSameColour and (self.currentChannel >= CHAT_CHANNEL_ZONE_LANGUAGE_1 and self.currentChannel <= CHAT_CHANNEL_ZONE_LANGUAGE_4) then
					rChatcolor = db.colours[2*CHAT_CHANNEL_ZONE]
				else
					rChatcolor = db.colours[2*self.currentChannel]
				end
				
				if not rChatcolor then
					self.textEntry:SetColor(1, 1, 1, 1)
				else
					local r, g, b, a = ConvertHexToRGBA(rChatcolor)
					self.textEntry:SetColor(r, g, b, a)
				end
				
			else
				self.textEntry:SetColor(self:GetCategoryColorFromChannel(self.currentChannel))
			end
		else
			self.textEntry:SetColor(self:GetCategoryColorFromChannel(self.currentChannel))
		end
		
	end

end

-- Change guild channel names in entry box
local function UpdateCharCorrespondanceTableChannelNames()
	
	-- Each guild
	for i = 1, GetNumGuilds() do
		if db.showTagInEntry then
			
			-- Get saved string
			local tag = db.guildTags[GetGuildName(GetGuildId(i))]
			
			-- No SavedVar
			if not tag then
				tag = GetGuildName(GetGuildId(i))
			-- SavedVar, but no tag
			elseif tag == "" then
				tag = GetGuildName(GetGuildId(i))
			end
			
			-- Get saved string
			local officertag = db.officertag[GetGuildName(GetGuildId(i))]
			
			-- No SavedVar
			if not officertag then
				officertag = tag
			-- SavedVar, but no tag
			elseif officertag == "" then
				officertag = tag
			end			
			
			-- /g1 is 12 /g5 is 16, /o1=17, etc
			ChanInfoArray[CHAT_CHANNEL_GUILD_1 - 1 + i].name = tag
			ChanInfoArray[CHAT_CHANNEL_OFFICER_1 - 1 + i].name = officertag
			--Activating
			ChanInfoArray[CHAT_CHANNEL_GUILD_1 - 1 + i].dynamicName = false
			ChanInfoArray[CHAT_CHANNEL_OFFICER_1 - 1 + i].dynamicName = false
			
		else
			-- /g1 is 12 /g5 is 16, /o1=17, etc
			ChanInfoArray[CHAT_CHANNEL_GUILD_1 - 1 + i].name = GetGuildName(GetGuildId(i))
			ChanInfoArray[CHAT_CHANNEL_OFFICER_1 - 1 + i].name = GetGuildName(GetGuildId(i))
			--Deactivating
			ChanInfoArray[CHAT_CHANNEL_GUILD_1 - 1 + i].dynamicName = true
			ChanInfoArray[CHAT_CHANNEL_OFFICER_1 - 1 + i].dynamicName = true
		end
	end
	
	return
	
end

-- Split text with blocs of 100 chars (106 is max for LinkHandle) and add LinkHandle to them
-- WARNING : See FormatSysMessage()
local function SplitTextForLinkHandler(text, numLine, chanCode)

	local newText = ""
	local textLen = string.len(text)
	local MAX_LEN = 100
	
	-- LinkHandle does not handle text > 106 chars, so we need to split
	if textLen > MAX_LEN then
	
		local splittedStart = 1
		local splits = 1
		local needToSplit = true
		
		while needToSplit do
			
			local splittedString = ""
			local UTFAditionalBytes = 0
				
			if textLen > (splits * MAX_LEN) then
				
				local splittedEnd = splittedStart + MAX_LEN
				splittedString = text:sub(splittedStart, splittedEnd) -- We can "cut" characters by doing this
				
				local lastByte = string.byte(splittedString, -1)
				local beforeLastByte = string.byte(splittedString, -2, -2)
				
				-- Characters can be into 1, 2 or 3 bytes. Lua don't support UTF natively. We only handle 3 bytes chars.
				-- http://www.utf8-chartable.de/unicode-utf8-table.pl
				
				if (lastByte < 128) then -- any ansi character (ex : a	97	LATIN SMALL LETTER A) (cut was well made)
					--
				elseif lastByte >= 128 and lastByte < 192 then -- any non ansi character ends with last byte = 128-191  (cut was well made) or 2nd byte of a 3 Byte character. We take 1 byte more.  (cut was incorrect)
					
					if beforeLastByte >= 192 and beforeLastByte < 224 then -- "2 latin characters" ex: 195 169	LATIN SMALL LETTER E WITH ACUTE ; е	208 181	CYRILLIC SMALL LETTER IE
						--
					elseif beforeLastByte >= 128 and beforeLastByte < 192 then -- "3 Bytes Cyrillic & Japaneese" ex U+3057	し	227 129 151	HIRAGANA LETTER SI
						--
					elseif beforeLastByte >= 224 and beforeLastByte < 240 then -- 2nd byte of a 3 Byte character. We take 1 byte more.  (cut was incorrect)
						UTFAditionalBytes = 1
					end
					
					splittedEnd = splittedEnd + UTFAditionalBytes
					splittedString = text:sub(splittedStart, splittedEnd)
					
				elseif lastByte >= 192 and lastByte < 224 then -- last byte = 1st byte of a 2 Byte character. We take 1 byte more.  (cut was incorrect)
					UTFAditionalBytes = 1
					splittedEnd = splittedEnd + UTFAditionalBytes
					splittedString = text:sub(splittedStart, splittedEnd)
				elseif lastByte >= 224 and lastByte < 240 then -- last byte = 1st byte of a 3 Byte character. We take 2 byte more.  (cut was incorrect)
					UTFAditionalBytes = 2
					splittedEnd = splittedEnd + UTFAditionalBytes
					splittedString = text:sub(splittedStart, splittedEnd)
				end
				
				splittedStart = splittedEnd + 1
				newText = newText .. string.format("|H1:%s:%s:%s|h%s|h", RCHAT_LINK, numLine, chanCode, splittedString)
				splits = splits + 1
				
			else
				splittedString = text:sub(splittedStart)
				local textSplittedlen = splittedString:len()
				if textSplittedlen > 0 then
					newText = newText .. string.format("|H1:%s:%s:%s|h%s|h", RCHAT_LINK, numLine, chanCode, splittedString)
				end
				needToSplit = false
			end
			
		end
	else
		-- When dumping back, the "from" section is sent here. It will add handler to spaces. prevent it to avoid an uneeded increase of the message.
		if not (text == " " or text == ": ") then
			newText = string.format("|H1:%s:%s:%s|h%s|h", RCHAT_LINK, numLine, chanCode, text)
		else
			newText = text
		end
	end
	
	return newText
	
end

-- Sub function of addLinkHandlerToString
-- WARNING : See FormatSysMessage()
-- Get a string without |cXXXXXX and without |t as parameter
local function AddLinkHandlerToStringWithoutDDS(textToCheck, numLine, chanCode)

	local stillToParse = true
	local noColorlen = textToCheck:len()
	
	-- this var seems to get some rework
	local startNoColor = 1
	local textLinked = ""
	local preventLoopsCol = 0
	local handledText = ""
	
	while stillToParse do
	
		-- Prevent infinit loops while its still in beta
		if preventLoopsCol > 10 then
			stillToParse = false
			CHAT_SYSTEM:Zo_AddMessage("rChat triggered an infinite LinkHandling loop in its copy system with last message : " .. textToCheck .. " -- rChat")
		else
			preventLoopsCol = preventLoopsCol + 1
		end
		
		noColorlen = textToCheck:len()
		
		local startpos, endpos = string.find(textToCheck, "|H(.-):(.-)|h(.-)|h", 1)
		-- LinkHandler not found
		if not startpos then
			-- If nil, then we won't have new link after startposition = startNoColor , so add ours util the end
			
			-- Some addons use table.insert() and chat convert to a CRLF
			-- First, drop the final CRLF if we are at the end of the text
			if string.sub(textToCheck, -2) == "\r\n" then
				textToCheck = string.sub(textToCheck, 1, -2)
			end
			-- MultiCRLF is handled in .addLinkHandler()
			
			textLinked = SplitTextForLinkHandler(textToCheck, numLine, chanCode)
			handledText = handledText .. textLinked
			
			-- No need to parse after
			stillToParse = false
			
		else
			
			-- Link is at the begginning of the string
			if startpos == 1 then
				-- New text is (only handler because its at the pos 1)
				handledText = handledText .. textToCheck:sub(startpos, endpos)
				
				-- Do we need to continue ?
				if endpos == noColorlen then
					-- We're at the end
					stillToParse = false
				else
					-- Still to parse
					startNoColor = endpos
					-- textToCheck is next to our string
					textToCheck = textToCheck:sub(startNoColor + 1)
				end
				
			else
			
				-- We Handle string from startNoColor of the message up to the Handle link
				local textToHandle = textToCheck:sub(1, startpos - 1)
				
				-- Add ours
				-- Maybe we need a split due to 106 chars restriction
				textLinked = SplitTextForLinkHandler(textToHandle, numLine, chanCode)
				
				-- New text is handledText + (textLinked .. LinkHandler)
				handledText = handledText .. textLinked
				handledText = handledText .. textToCheck:sub(startpos, endpos)
				
				-- Do we need to continue ?
				if endpos == noColorlen then
					-- We're at the end
					stillToParse = false
				else
					-- Still to parse
					startNoColor = endpos
					-- textToCheck is next to our string
					textToCheck = textToCheck:sub(startNoColor + 1)
				end
				
			end
		end
	end

	return handledText

end

-- Sub function of addLinkHandlerToLine, Handling DDS textures in chat
-- WARNING : See FormatSysMessage()
-- Get a string without |cXXXXXX as parameter
local function AddLinkHandlerToString(textToCheck, numLine, chanCode)

	local stillToParseDDS = true
	local noDDSlen = textToCheck:len()
	
	-- this var seems to get some rework
	local startNoDDS = 1
	local textLinked = ""
	local preventLoopsDDS = 0
	local textTReformated = ""
	
	-- Seems the "|" are truncated from the link when send to chatsystem (they're needed for build link, but the output does not include them)

	while stillToParseDDS do
	
		-- Prevent infinit loops while its still in beta
		if preventLoopsDDS > 20 then
			stillToParseDDS = false
			CHAT_SYSTEM:Zo_AddMessage("rChat triggered an infinite DDS loop in its copy system with last message : " .. textToCheck .. " -- rChat")
		else
			preventLoopsDDS = preventLoopsDDS + 1
		end
	
		noDDSlen = textToCheck:len()
		
		local startpos, endpos = string.find(textToCheck, "|t%-?%d+%%?:%-?%d+%%?:.-|t", 1)
		-- DDS not found
		if startpos == nil then
			-- If nil, then we won't have new link after startposition = startNoDDS , so add ours until the end
			
			textLinked = AddLinkHandlerToStringWithoutDDS(textToCheck, numLine, chanCode)
			
			textTReformated = textTReformated .. textLinked
			
			-- No need to parse after
			stillToParseDDS = false
			
		else
			
			-- DDS is at the begginning of the string
			if startpos == 1 then
				-- New text is (only DDS because its at the pos 1)
				textTReformated = textTReformated .. textToCheck:sub(startpos, endpos)
				
				-- Do we need to continue ?
				if endpos == noDDSlen then
					-- We're at the end
					stillToParseDDS = false
				else
					-- Still to parse
					startNoDDS = endpos
					-- textToCheck is next to our string
					textToCheck = textToCheck:sub(startNoDDS + 1)
				end
				
			else
			
				-- We Handle string from startNoDDS of the message up to the Handle link
				local textToHandle = textToCheck:sub(1, startpos - 1)
				
				-- Add ours
				textLinked = AddLinkHandlerToStringWithoutDDS(textToHandle, numLine, chanCode)
				
				-- New text is formattedText + (textLinked .. DDS)
				textTReformated = textTReformated .. textLinked
				
				textTReformated = textTReformated .. textToCheck:sub(startpos, endpos)
				
				-- Do we need to continue ?
				if endpos == noDDSlen then
					-- We're at the end
					stillToParseDDS = false
				else
					-- Still to parse
					startNoDDS = endpos
					-- textToCheck is next to our string
					textToCheck = textToCheck:sub(startNoDDS + 1)
				end
				
			end
		end
	end

	return textTReformated

end

-- Reformat Colored Sysmessages to the correct format
-- Bad format = |[cC]XXXXXXblablabla[,|[cC]XXXXXXblablabla,(...)] with facultative |r
-- Good format : "|c%x%x%x%x%x%x(.-)|r"
-- WARNING : See FormatSysMessage()
-- TODO : Handle LinkHandler + Malformatted strings , such as : "|c87B7CC|c87B7CCUpdated: |H0:achievement:68:5252:0|h|h (Artisanat)."
local function ReformatSysMessages(text)

	local rawSys = text
	local startColSys, endColSys
	local lastTag, lastR, findC, findR
	local count, countR
	local firstIsR
	
	rawSys = rawSys:gsub("||([Cc])", "%1") -- | is the escape char for |, so if an user type |c it will be sent as ||c by the game which will lead to an infinite loading screen because xxxxx||xxxxxx is a lua pattern operator and few gsub will broke the code
	
	--Search for Color tags
	startColSys, endColSys = string.find(rawSys, "|[cC]%x%x%x%x%x%x", 1)
	_, count = string.gsub(rawSys, "|[cC]%x%x%x%x%x%x", "")
	
	-- No color tags in the SysMessage
	if startColSys then
		-- Found X tag
		-- Searching for |r after tag color
		
		-- First destroy tags with nothing inside
		rawSys = string.gsub(rawSys, "|[cC]%x%x%x%x%x%x|[rR]", "")
		
		_, countR = string.gsub(rawSys, "|[cC]%x%x%x%x%x%x(.-)|[rR]", "")
		
		-- Start tag found but end tag ~= start tag
		if count ~= countR then
			
			-- Add |r before the tag
			rawSys = string.gsub(rawSys, "|[cC]%x%x%x%x%x%x", "|r%1")
			firstIsR = string.find(rawSys, "|[cC]%x%x%x%x%x%x")
			
			--No |r tag at the start of the text if start was |cXXXXXX
			if firstIsR == 3 then
				rawSys = string.sub(rawSys, 3)
			end
			
			-- Replace
			rawSys = string.gsub(rawSys, "|r|r", "|r")
			rawSys = string.gsub(rawSys, "|r |r", " |r")
			
			lastTag = string.match(rawSys, "^.*()|[cC]%x%x%x%x%x%x")
			lastR = string.match(rawSys, "^.*()|r")
			
			-- |r tag found
			if lastR ~= nil then
				if lastTag > lastR then
					rawSys = rawSys .. "|r"
				end
			else
				-- Got X tags and 0 |r, happens only when we got 1 tag and 0 |r because we added |r to every tags just before
				-- So add last "|r"
				rawSys = rawSys .. "|r"
			end
			
			-- Double check
			
			findC = string.find(rawSys, "|[cC]%x%x%x%x%x%x")
			findR = string.find(rawSys, "|[rR]")
			
			while findR ~= nil and findC ~= nil do
				
				if findC then
					if findR < findC then
						rawSys = string.sub(rawSys, 1, findR - 1) .. string.sub(rawSys, findR + 2)
					end
					
					findC = string.find(rawSys, "|[cC]%x%x%x%x%x%x", findR)
					findR = string.find(rawSys, "|[rR]", findR + 2)
				end
				
			end
			
		end
		
	end
	-- Added |u search
	startColSys, endColSys = string.find(rawSys, "|u%-?%d+%%?:%-?%d+%%?:.-:|u",1)
	-- if found
	if startColSys then
		rawSys = string.gsub(rawSys,"|u%-?%d+%%?:%-?%d+%%?:.-:|u","")
	end
	
	return rawSys
	
end

-- Add rChatLinks Handlers on the whole text except LinkHandlers already here
-- WARNING : See FormatSysMessage()
local function AddLinkHandlerToLine(text, chanCode, numLine)
	
	local rawText = ReformatSysMessages(text) -- FUCK YOU
	
	local start = 1
	local rawTextlen = string.len(rawText)
	local stillToParseCol = true
	local formattedText
	local noColorText = ""
	local textToCheck = ""
	
	local startColortag = ""
	
	local preventLoops = 0
	local colorizedText = true
	local newText = ""
	
	while stillToParseCol do
		
		-- Prevent infinite loops while its still in beta
		if preventLoops > 10 then
			stillToParseCol = false
		else
			preventLoops = preventLoops + 1
		end
		
		-- Handling Colors, search for color tag
		local startcol, endcol = string.find(rawText, "|[cC]%x%x%x%x%x%x(.-)|r", start)
		
		-- Not Found
		if startcol == nil then
			startColortag = ""
			textToCheck = string.sub(rawText, start)
			stillToParseCol = false
			newText = newText .. AddLinkHandlerToString(textToCheck, numLine, chanCode)
		else
			startColortag = string.sub(rawText, startcol, startcol + 7)
			-- rChat format all strings
			if start == startcol then
				-- textToCheck is only (.-)
				textToCheck = string.sub(rawText, (startcol + 8), (endcol - 2))
				-- Change our start -> pos of (.-)
				start = endcol + 1
				newText = newText .. startColortag .. AddLinkHandlerToString(textToCheck, numLine, chanCode) .. "|r"
				
				-- Do we need to continue ?
				if endcol == rawTextlen then
					-- We're at the end
					stillToParseCol = false
				end
				
			else
				-- We will check colorized text at next loop
				textToCheck = string.sub(rawText, start, startcol-1)
				start = startcol
				-- Tag color found but need to check some strings before
				newText = newText .. AddLinkHandlerToString(textToCheck, numLine, chanCode)
			end
		end
		
	end
	
	return newText
	
end

-- Split lines using CRLF for function addLinkHandlerToLine
-- WARNING : See FormatSysMessage()
local function AddLinkHandler(text, chanCode, numLine)
	
	-- Some Addons output multiple lines into a message
	-- Split the entire string with CRLF, cause LinkHandler don't support CRLF
	
	-- Init
	local formattedText = ""
	
	-- Recheck setting if copy is disabled for chat dump
	if db.enablecopy then
	
		-- No CRLF
		-- ESO LUA Messages output \n instead of \r\n
		local crtext = string.gsub(text, "\r\n", "\n")
		-- Find multilines
		local cr = string.find(crtext, "\n")
		
		if not cr then
			formattedText = AddLinkHandlerToLine(text, chanCode, numLine)
		else
			local lines = {zo_strsplit("\n", crtext)}
			local first = true
			local strippedLine
			local nunmRows = 0
			
			for _, line in pairs(lines) do
				
				-- Only if there something to display
				if string.len(line) > 0 then
				
					if first then
						formattedText = AddLinkHandlerToLine(line, chanCode, numLine)
						first = false
					else
						formattedText = formattedText .. "\n" .. AddLinkHandlerToLine(line, chanCode, numLine)
					end
					
					if nunmRows > 10 then
						CHAT_SYSTEM:Zo_AddMessage("rChat has triggered 10 packed lines with text=" .. text .. "-- rChat - Message truncated")
						return
					else
						nunmRows = nunmRows + 1
					end
					
				end
			
			end
		
		end
	else
		formattedText = text
	end
	
	return formattedText

end

-- Can cause infinite loads (why?)
local function RestoreChatMessagesFromHistory(wasReloadUI)

	-- Restore Chat
	local lastInsertionWas = 0

	if db.LineStrings then
		
		local historyIndex = 1
		local categories = ZO_ChatSystem_GetEventCategoryMappings()
		
		while historyIndex <= #db.LineStrings do
			if db.LineStrings[historyIndex] then
				local channelToRestore = db.LineStrings[historyIndex].channel
				if channelToRestore == RCHAT_CHANNEL_SAY then channelToRestore = 0 end
				
				if channelToRestore == CHAT_CHANNEL_SYSTEM and not db.restoreSystem then
					table.remove(db.LineStrings, historyIndex)
					db.lineNumber = db.lineNumber - 1
					historyIndex = historyIndex - 1
				elseif channelToRestore ~= CHAT_CHANNEL_SYSTEM and db.restoreSystemOnly then
					table.remove(db.LineStrings, historyIndex)
					db.lineNumber = db.lineNumber - 1
					historyIndex = historyIndex - 1
				elseif (channelToRestore == CHAT_CHANNEL_WHISPER or channelToRestore == CHAT_CHANNEL_WHISPER_SENT) and not db.restoreWhisps then
					table.remove(db.LineStrings, historyIndex)
					db.lineNumber = db.lineNumber - 1
					historyIndex = historyIndex - 1
				else
					
					local category = categories[EVENT_CHAT_MESSAGE_CHANNEL][channelToRestore]
					
					if GetTimeStamp() - db.LineStrings[historyIndex].rawTimestamp < db.timeBeforeRestore * 60 * 60 and db.LineStrings[historyIndex].rawTimestamp < GetTimeStamp() then
						lastInsertionWas = math.max(lastInsertionWas, db.LineStrings[historyIndex].rawTimestamp)
						for containerIndex=1, #CHAT_SYSTEM.containers do
						
							for tabIndex=1, #CHAT_SYSTEM.containers[containerIndex].windows do
								if IsChatContainerTabCategoryEnabled(CHAT_SYSTEM.containers[containerIndex].id, tabIndex, category) then
									if not db.chatConfSync[rChatData.localPlayer].tabs[tabIndex].notBefore or db.LineStrings[historyIndex].rawTimestamp > db.chatConfSync[rChatData.localPlayer].tabs[tabIndex].notBefore then
										CHAT_SYSTEM.containers[containerIndex]:AddEventMessageToWindow(CHAT_SYSTEM.containers[containerIndex].windows[tabIndex], AddLinkHandler(db.LineStrings[historyIndex].rawValue, channelToRestore, historyIndex), category)
									end
								end
							end
							
						end
					else
						table.remove(db.LineStrings, historyIndex)
						db.lineNumber = db.lineNumber - 1
						historyIndex = historyIndex - 1
					end
					
				end
			end
			historyIndex = historyIndex + 1
		end
		
		
		local PRESSED = 1
		local UNPRESSED = 2
		local numTabs = #CHAT_SYSTEM.primaryContainer.windows
		
		for numTab, container in ipairs (CHAT_SYSTEM.primaryContainer.windows) do
			if numTab > 1 then
				CHAT_SYSTEM.primaryContainer:HandleTabClick(container.tab)
				local tabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab .. "Text")
				tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
				tabText:GetParent().state = PRESSED
				local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab - 1 .. "Text")
				oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
				oldTabText:GetParent().state = UNPRESSED
			end
		end
		
		if numTabs > 1 then
			CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[1].tab)
			local tabText = GetControl("ZO_ChatWindowTabTemplate1Text")
			tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
			tabText:GetParent().state = PRESSED
			local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. #CHAT_SYSTEM.primaryContainer.windows .. "Text")
			oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
			oldTabText:GetParent().state = UNPRESSED
		end
		
	end
	
	-- Restore TextEntry History
	if (wasReloadUI or db.restoreTextEntryHistoryAtLogOutQuit) and db.history.textEntry then
	
		if db.history.textEntry.entries then
			
			if lastInsertionWas and ((GetTimeStamp() - lastInsertionWas) < (db.timeBeforeRestore * 60 * 60)) then
				for _, text in ipairs(db.history.textEntry.entries) do
					CHAT_SYSTEM.textEntry:AddCommandHistory(text)
				end
				
				CHAT_SYSTEM.textEntry.commandHistory.index = db.history.textEntry.numEntries
			end
		
		end
		
	end
	
end

-- Restore History from SavedVars
local function RestoreChatHistory()

	-- Set default tab at login
	SetDefaultTab(db.defaultTab)
	-- Restore History
	if db.history then
		
		if db.lastWasReloadUI and db.restoreOnReloadUI then
			
			-- RestoreChannel
			if db.defaultchannel ~= RCHAT_CHANNEL_NONE then
				CHAT_SYSTEM:SetChannel(db.history.currentChannel, db.history.currentTarget)
			end
			
			-- restore TextEntry and Chat
			RestoreChatMessagesFromHistory(true)
			
			-- Restore tab when ReloadUI
			--** blocking for now
			--SetDefaultTab(db.history.currentTab)
			
		elseif (db.lastWasLogOut and db.restoreOnLogOut) or (db.lastWasAFK and db.restoreOnAFK) or (db.lastWasQuit and db.restoreOnQuit) then
			-- restore TextEntry and Chat
			RestoreChatMessagesFromHistory(false)
		end
		
		rChatData.messagesHaveBeenRestorated = true
		
		local indexMessages = #rChatData.cachedMessages
		if indexMessages > 0 then
			for index=1, indexMessages do
				CHAT_SYSTEM:AddMessage(rChatData.cachedMessages[index])
			end
		end
		
		db.lastWasReloadUI = false
		db.lastWasLogOut = false
		db.lastWasQuit = false
		db.lastWasAFK = true
	else
		rChatData.messagesHaveBeenRestorated = true
	end

end

-- Store line number
-- Create an array for the copy functions, spam functions and revert history functions
-- WARNING : See FormatSysMessage()
local function StorelineNumber(rawTimestamp, rawFrom, text, chanCode, originalFrom)
	
	-- Strip DDS tag from Copy text
	local function StripDDStags(text)
		return text:gsub("|t(.-)|t", "")
	end
	
	local formattedMessage = ""
	local rawText = text
	
	-- SysMessages does not have a from
	if chanCode ~= CHAT_CHANNEL_SYSTEM then
	
		-- Timestamp cannot be nil anymore with SpamFilter, so use the option itself
		if db.showTimestamp then
			-- Format for Copy
			formattedMessage = "[" .. CreateTimestamp(GetTimeString()) .. "] "
		end
		
		-- Strip DDS tags for GM
		rawFrom = StripDDStags(rawFrom)
		
		-- Needed for SpamFilter
		db.LineStrings[db.lineNumber].rawFrom = originalFrom
		
		-- formattedMessage is only rawFrom for now
		formattedMessage = formattedMessage .. rawFrom
		
		if db.carriageReturn then
			formattedMessage = formattedMessage .. "\n"
		end
		
	end
	
	-- Needed for SpamFilter & Restoration, UNIX timestamp
	db.LineStrings[db.lineNumber].rawTimestamp = rawTimestamp
	
	-- Store CopyMessage / Used for SpamFiltering. Due to lua 0 == nil in arrays, set value to 98
	if chanCode == CHAT_CHANNEL_SAY then
		db.LineStrings[db.lineNumber].channel = RCHAT_CHANNEL_SAY
	else
		db.LineStrings[db.lineNumber].channel = chanCode
	end
	
	-- Store CopyMessage
	db.LineStrings[db.lineNumber].rawText = rawText
	
	-- Store CopyMessage
	--db.LineStrings[db.lineNumber].rawValue = text
	
	-- Strip DDS tags
	rawText = StripDDStags(rawText)
	
	-- Used to translate LinkHandlers
	rawText = FormatRawText(rawText)
	
	-- Store CopyMessage
	db.LineStrings[db.lineNumber].rawMessage = rawText
	
	-- Store CopyLine
	db.LineStrings[db.lineNumber].rawLine = formattedMessage .. rawText
	
	--Increment at each message handled
	db.lineNumber = db.lineNumber + 1
	
end

-- WARNING : Since AddMessage is bypassed, this function and all its subfunctions DOES NOT MUST CALL d() / Emitmessage() / AddMessage() or it will result an infinite loop and crash the game
-- Debug must call CHAT_SYSTEM:Zo_AddMessage() wich is backuped copy of CHAT_SYSTEM.AddMessage
local function FormatSysMessage(statusMessage)

	-- Display Timestamp if needed
	local function ShowTimestamp()

		local timestamp = ""

		-- Add timestamp
		if db.showTimestamp then
		
			-- Timestamp formatted
			timestamp = CreateTimestamp(GetTimeString())
			
			local timecol
			-- Timestamp color is chanCode so no coloring
			if db.timestampcolorislcol then
				 -- Show Message
				timestamp = string.format("[%s] ", timestamp)
			else
				-- Timestamp color is our setting color
				timecol = db.colours.timestamp
				
				-- Show Message
				timestamp = string.format("%s[%s] |r", timecol, timestamp)
			end
		else
			timestamp = ""
		end
		
		return timestamp
		
	end

	-- Only if statusMessage is set
	if statusMessage then
		
		-- Only if there something to display
		if string.len(statusMessage) > 0 then
		
			local sysMessage
			
			-- Some addons are quicker than rChat
			if db then
			
				-- Show Message
				statusMessage = ShowTimestamp() .. statusMessage
				
				if not db.lineNumber then
					db.lineNumber = 1
				end
				
				--	for CopySystem
				db.LineStrings[db.lineNumber] = {}
				
				-- Make it Linkable
				
				if db.enablecopy then
					sysMessage = AddLinkHandler(statusMessage, CHAT_CHANNEL_SYSTEM, db.lineNumber)
				else
					sysMessage = statusMessage
				end
				
				if not db.LineStrings[db.lineNumber].rawFrom then db.LineStrings[db.lineNumber].rawFrom = "" end
				if not db.LineStrings[db.lineNumber].rawMessage then db.LineStrings[db.lineNumber].rawMessage = "" end
				if not db.LineStrings[db.lineNumber].rawLine then db.LineStrings[db.lineNumber].rawLine = "" end
				if not db.LineStrings[db.lineNumber].rawValue then db.LineStrings[db.lineNumber].rawValue = statusMessage end
				if not db.LineStrings[db.lineNumber].rawDisplayed then db.LineStrings[db.lineNumber].rawDisplayed = sysMessage end
				
				-- No From, rawTimestamp is in statusMessage, sent as arg for SpamFiltering even if SysMessages are not filtered
				StorelineNumber(GetTimeStamp(), nil, statusMessage, CHAT_CHANNEL_SYSTEM, nil)
				
			end
			
			-- Show Message
			return sysMessage
		
		end
		
	end

end

-- Add a rChat handler for URL's
local function AddURLHandling(text)

	-- handle complex URLs and do
	for pos, url, prot, subd, tld, colon, port, slash, path in text:gmatch("()(([%w_.~!*:@&+$/?%%#-]-)(%w[-.%w]*%.)(%w+)(:?)(%d*)(/?)([%w_.~!*:@&+$/?%#=-]*))") do
		if rChatData.protocols[prot:lower()] == (1 - #slash) * #path
		and (colon == "" or port ~= "" and port + 0 < 65536)
		and (rChatData.tlds[tld:lower()] or tld:find("^%d+$") and subd:find("^%d+%.%d+%.%d+%.$") and math.max(tld, subd:match("^(%d+)%.(%d+)%.(%d+)%.$")) < 256)
		and not subd:find("%W%W")
		then
			local urlHandled = string.format("|H1:%s:%s:%s|h%s|h", RCHAT_LINK, db.lineNumber, RCHAT_URL_CHAN, url)
			url = url:gsub("([?+-])", "%%%1") -- don't understand why, 1st arg of gsub must be escaped and 2nd not.
			text, count = text:gsub(url, urlHandled)
		end
	end
	
	return text

end

local function InitializeURLHandling()

	-- cTLD + most used (> 0.1%)
	local domains = 
	[[
	.ac.ad.ae.af.ag.ai.al.am.an.ao.aq.ar.as.at.au.aw.ax.az.ba.bb.bd.be.bf.bg.bh.bi.bj.bl.bm.bn.bo.bq
	.br.bs.bt.bv.bw.by.bz.ca.cc.cd.cf.cg.ch.ci.ck.cl.cm.cn.co.cr.cu.cv.cw.cx.cy.cz.de.dj.dk.dm.do.dz
	.ec.ee.eg.eh.er.es.et.eu.fi.fj.fk.fm.fo.fr.ga.gb.gd.ge.gf.gg.gh.gi.gl.gm.gn.gp.gq.gr.gs.gt.gu.gw
	.gy.hk.hm.hn.hr.ht.hu.id.ie.il.im.in.io.iq.ir.is.it.je.jm.jo.jp.ke.kg.kh.ki.km.kn.kp.kr.kw.ky.kz
	.la.lb.lc.li.lk.lr.ls.lt.lu.lv.ly.ma.mc.md.me.mf.mg.mh.mk.ml.mm.mn.mo.mp.mq.mr.ms.mt.mu.mv.mw.mx
	.my.mz.na.nc.ne.nf.ng.ni.nl.no.np.nr.nu.nz.om.pa.pe.pf.pg.ph.pk.pl.pm.pn.pr.ps.pt.pw.py.qa.re.ro
	.rs.ru.rw.sa.sb.sc.sd.se.sg.sh.si.sj.sk.sl.sm.sn.so.sr.ss.st.su.sv.sx.sy.sz.tc.td.tf.tg.th.tj.tk
	.tl.tm.tn.to.tp.tr.tt.tv.tw.tz.ua.ug.uk.um.us.uy.uz.va.vc.ve.vg.vi.vn.vu.wf.ws.ye.yt.za.zm.zw
	.biz.com.coop.edu.gov.int.mil.mobi.info.net.org.xyz.top.club.pro.asia
	]]
	
	-- wxx.yy.zz
	rChatData.tlds = {}
	for tld in domains:gmatch('%w+') do
		rChatData.tlds[tld] = true
	end
	
	-- protos : only http/https
	rChatData.protocols = {['http://'] = 0, ['https://'] = 0}
	
end

local function GetChannelColors(channel, from)

	 -- Substract XX to a color (darker)
	local function FirstColorFromESOSettings(r, g, b)
		-- Scale is from 0-100 so divide per 300 will maximise difference at 0.33 (*2)
		r = math.max(r - (db.diffforESOcolors / 300 ),0)
		g = math.max(g - (db.diffforESOcolors / 300 ),0)
		b = math.max(b - (db.diffforESOcolors / 300 ),0)
		return r,g,b
	end
	
	 -- Add XX to a color (brighter)
	local function SecondColorFromESOSettings(r, g, b)
		r = math.min(r + (db.diffforESOcolors / 300 ),1)
		g = math.min(g + (db.diffforESOcolors / 300 ),1)
		b = math.min(b + (db.diffforESOcolors / 300 ),1)
		return r,g,b
	end

	if db.useESOcolors then
		
		-- ESO actual color, return r,g,b
		local rESO, gESO, bESO
		-- Handle the same-colour options.
		if db.allNPCSameColour and (channel == CHAT_CHANNEL_MONSTER_SAY or channel == CHAT_CHANNEL_MONSTER_YELL or channel == CHAT_CHANNEL_MONSTER_WHISPER) then
			rESO, gESO, bESO = CHAT_SYSTEM:GetCategoryColorFromChannel(CHAT_CHANNEL_MONSTER_SAY)
		elseif db.allGuildsSameColour and (channel >= CHAT_CHANNEL_GUILD_1 and channel <= CHAT_CHANNEL_GUILD_5) then
			rESO, gESO, bESO = CHAT_SYSTEM:GetCategoryColorFromChannel(CHAT_CHANNEL_GUILD_1)
		elseif db.allGuildsSameColour and (channel >= CHAT_CHANNEL_OFFICER_1 and channel <= CHAT_CHANNEL_OFFICER_5) then
			rESO, gESO, bESO = CHAT_SYSTEM:GetCategoryColorFromChannel(CHAT_CHANNEL_OFFICER_1)
		elseif db.allZonesSameColour and (channel >= CHAT_CHANNEL_ZONE_LANGUAGE_1 and channel <= CHAT_CHANNEL_ZONE_LANGUAGE_4) then
			rESO, gESO, bESO = CHAT_SYSTEM:GetCategoryColorFromChannel(CHAT_CHANNEL_ZONE_LANGUAGE_1)
		elseif channel == CHAT_CHANNEL_PARTY and from and db.groupLeader and zo_strformat(SI_UNIT_NAME, from) == GetUnitName(GetGroupLeaderUnitTag()) then
			rESO, gESO, bESO = ConvertHexToRGBA(db.colours["groupleader"])
		else
			rESO, gESO, bESO = CHAT_SYSTEM:GetCategoryColorFromChannel(channel)
		end
		
		-- Set right colour to left colour - cause ESO colors are rewrited, if onecolor, no rewriting
		if db.oneColour then
			lcol = ConvertRGBToHex(rESO, gESO, bESO)
			rcol = lcol
		else
			lcol = ConvertRGBToHex(FirstColorFromESOSettings(rESO,gESO,bESO))
			rcol = ConvertRGBToHex(SecondColorFromESOSettings(rESO,gESO,bESO))
		end

	else
		-- rChat Colors
		-- Handle the same-colour options.
		if db.allNPCSameColour and (channel == CHAT_CHANNEL_MONSTER_SAY or channel == CHAT_CHANNEL_MONSTER_YELL or channel == CHAT_CHANNEL_MONSTER_WHISPER) then
			lcol = db.colours[2*CHAT_CHANNEL_MONSTER_SAY]
			rcol = db.colours[2*CHAT_CHANNEL_MONSTER_SAY + 1]
		elseif db.allGuildsSameColour and (channel >= CHAT_CHANNEL_GUILD_1 and channel <= CHAT_CHANNEL_GUILD_5) then
			lcol = db.colours[2*CHAT_CHANNEL_GUILD_1]
			rcol = db.colours[2*CHAT_CHANNEL_GUILD_1 + 1]
		elseif db.allGuildsSameColour and (channel >= CHAT_CHANNEL_OFFICER_1 and channel <= CHAT_CHANNEL_OFFICER_5) then
			lcol = db.colours[2*CHAT_CHANNEL_OFFICER_1]
			rcol = db.colours[2*CHAT_CHANNEL_OFFICER_1 + 1]
		elseif db.allZonesSameColour and (channel >= CHAT_CHANNEL_ZONE_LANGUAGE_1 and channel <= CHAT_CHANNEL_ZONE_LANGUAGE_4) then
			lcol = db.colours[2*CHAT_CHANNEL_ZONE]
			rcol = db.colours[2*CHAT_CHANNEL_ZONE + 1]
		elseif channel == CHAT_CHANNEL_PARTY and from and db.groupLeader and zo_strformat(SI_UNIT_NAME, from) == GetUnitName(GetGroupLeaderUnitTag()) then
			lcol = db.colours["groupleader"]
			rcol = db.colours["groupleader1"]
		else
			lcol = db.colours[2*channel]
			rcol = db.colours[2*channel + 1]
		end
		
		-- Set right colour to left colour
		if db.oneColour then
			rcol = lcol
		end
		
	end
	
	return lcol, rcol

end

-- Executed when EVENT_CHAT_MESSAGE_CHANNEL triggers
-- Formats the message
local function FormatMessage(chanCode, from, text, isCS, fromDisplayName, originalFrom, originalText, DDSBeforeAll, TextBeforeAll, DDSBeforeSender, TextBeforeSender, TextAfterSender, DDSAfterSender, DDSBeforeText, TextBeforeText, TextAfterText, DDSAfterText)

	-- Will calculate if this message is a spam
	local isSpam = SpamFilter(chanCode, from, text, isCS)
	
	-- A spam, drop everything
	if isSpam then return end
	
	local info = ChanInfoArray[chanCode]
	
	-- Init message with other addons stuff
	local message = DDSBeforeAll .. TextBeforeAll
	
	-- Init text with other addons stuff. Note : text can also be modified by other addons. Only originalText is the string the game has receive
	text = DDSBeforeText .. TextBeforeText .. text .. TextAfterText .. DDSAfterText
	
	if db.disableBrackets then
		chatStrings["copystandard"] = "%s: " -- standard format: say, yell, group, npc, npc yell, npc whisper, zone
		chatStrings["copyesostandard"] = "%s %s: " -- standard format: say, yell, group, npc, npc yell, npc whisper, zone with tag (except for monsters)
		chatStrings["copyesoparty"] = "[%s]%s: " -- standard format: party
		chatStrings["copytellIn"] = "%s: " -- tell in
		chatStrings["copytellOut"] = "-> %s: " -- tell out
		chatStrings["copyguild"] = "[%s] %s: " -- guild
		chatStrings["copylanguage"] = "[%s] %s: " -- language zones
	else
		chatStrings["copystandard"] = "[%s]: " -- standard format: say, yell, group, npc, npc yell, npc whisper, zone
		chatStrings["copyesostandard"] = "[%s] %s: " -- standard format: say, yell, group, npc, npc yell, npc whisper, zone with tag (except for monsters)
		chatStrings["copyesoparty"] = "[%s]%s: " -- standard format: party
		chatStrings["copytellIn"] = "[%s]: " -- tell in
		chatStrings["copytellOut"] = "-> [%s]: " -- tell out
		chatStrings["copyguild"] = "[%s] [%s]: " -- guild
		chatStrings["copylanguage"] = "[%s] %s: " -- language zones
	end
	
	--	for CopySystem
	db.LineStrings[db.lineNumber] = {}
	if not db.LineStrings[db.lineNumber].rawFrom then db.LineStrings[db.lineNumber].rawFrom = from end
	if not db.LineStrings[db.lineNumber].rawValue then db.LineStrings[db.lineNumber].rawValue = text end
	if not db.LineStrings[db.lineNumber].rawMessage then db.LineStrings[db.lineNumber].rawMessage = text end
	if not db.LineStrings[db.lineNumber].rawLine then db.LineStrings[db.lineNumber].rawLine = text end
	if not db.LineStrings[db.lineNumber].rawDisplayed then db.LineStrings[db.lineNumber].rawDisplayed = text end
	
	local new_from = ConvertName(chanCode, from, isCS, fromDisplayName)
	local displayedFrom = db.LineStrings[db.lineNumber].rawFrom
	
	-- Add other addons stuff related to sender
	new_from = DDSBeforeSender .. TextBeforeSender .. new_from .. TextAfterSender .. DDSAfterSender
	
	-- Guild tag
	local tag
	if (chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_GUILD_5) then
		local guild_number = chanCode - CHAT_CHANNEL_GUILD_1 + 1
		local guild_name = GetGuildName(GetGuildId(guild_number))
		tag = db.guildTags[guild_name]
		if tag and tag ~= "" then
			tag = tag
		else
			tag = guild_name
		end
	elseif (chanCode >= CHAT_CHANNEL_OFFICER_1 and chanCode <= CHAT_CHANNEL_OFFICER_5) then
		local guild_number = chanCode - CHAT_CHANNEL_OFFICER_1 + 1
		local guild_name = GetGuildName(GetGuildId(guild_number))
		local officertag = db.officertag[guild_name]
		if officertag and officertag ~= "" then
			tag = officertag
		else
			tag = guild_name
		end
	end
	
	-- Initialise colours
	local lcol, rcol = GetChannelColors(chanCode, from)
	
	-- Add timestamp
	if db.showTimestamp then
	
		-- Initialise timstamp color
		local timecol = db.colours.timestamp
		
		-- Timestamp color is lcol
		if db.timestampcolorislcol then
			timecol = lcol
		else
			-- Timestamp color is timestamp color
			timecol = db.colours.timestamp
		end
		
		-- Message is timestamp for now
		-- Add RCHAT_HANDLER for display
		local timestamp = ZO_LinkHandler_CreateLink(CreateTimestamp(GetTimeString()), nil, RCHAT_LINK, db.lineNumber .. ":" .. chanCode) .. " "
		
		-- Timestamp color
		message = message .. string.format("%s%s|r", timecol, timestamp)
		db.LineStrings[db.lineNumber].rawValue = string.format("%s[%s] |r", timecol, CreateTimestamp(GetTimeString()))
		
	end
	
	local linkedText = text
	
	-- Add URL Handling
	if db.urlHandling then
		text = AddURLHandling(text)
	end
	
	if db.enablecopy then
		linkedText = AddLinkHandler(text, chanCode, db.lineNumber)
	end
	
	local carriageReturn = ""
	if db.carriageReturn then
		carriageReturn = "\n"
	end
	
	-- Standard format
	if chanCode == CHAT_CHANNEL_SAY or chanCode == CHAT_CHANNEL_YELL or chanCode == CHAT_CHANNEL_PARTY or chanCode == CHAT_CHANNEL_ZONE then
		-- Remove zone tags
		if db.delzonetags then
		
			-- Used for Copy
			db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copystandard, db.LineStrings[db.lineNumber].rawFrom)
		
			message = message .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, linkedText)
			db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, text)
		-- Keep them
		else
			-- Init zonetag to keep the channel tag
			local zonetag
			-- Pattern for party is [Party]
			if chanCode == CHAT_CHANNEL_PARTY then
				zonetag = GetString(RCHAT_ZONETAGPARTY)
				
				-- Used for Copy
				db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyesoparty, zonetag, db.LineStrings[db.lineNumber].rawFrom)
				
				-- PartyHandler
				zonetag = ZO_LinkHandler_CreateLink(zonetag, nil, CHANNEL_LINK_TYPE, chanCode)
				
				message = message .. string.format(chatStrings.esoparty, lcol, zonetag, new_from, carriageReturn, rcol, linkedText)
				db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.esoparty, lcol, zonetag, new_from, carriageReturn, rcol, text)
			else
				-- Pattern for say/yell/zone is "player says:" ..
				if chanCode == CHAT_CHANNEL_SAY then zonetag = GetString(RCHAT_ZONETAGSAY)
				elseif chanCode == CHAT_CHANNEL_YELL then zonetag = GetString(RCHAT_ZONETAGYELL)
				elseif chanCode == CHAT_CHANNEL_ZONE then zonetag = GetString(RCHAT_ZONETAGZONE)
				end
				
				-- Used for Copy
				db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyesostandard, db.LineStrings[db.lineNumber].rawFrom, zonetag)
				
				-- rChat Handler
				zonetag = string.format("|H1:p:%s|h%s|h", chanCode, zonetag)
				
				message = message .. string.format(chatStrings.esostandart, lcol, new_from, zonetag, carriageReturn, rcol, linkedText)
				db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.esostandart, lcol, new_from, zonetag, carriageReturn, rcol, text)
			end
		end
	
	-- NPC speech
	elseif chanCode == CHAT_CHANNEL_MONSTER_SAY or chanCode == CHAT_CHANNEL_MONSTER_YELL or chanCode == CHAT_CHANNEL_MONSTER_WHISPER then
		
		-- Used for Copy
		db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copynpc, db.LineStrings[db.lineNumber].rawFrom)
		
		message = message .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, linkedText)
		db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, text)
	
	-- Incoming whispers
	elseif chanCode == CHAT_CHANNEL_WHISPER then
	
		--PlaySound
		if db.soundforincwhisps then
			PlaySound(db.soundforincwhisps)
		end
	
		-- Used for Copy
		db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copytellIn, db.LineStrings[db.lineNumber].rawFrom)
	
		message = message .. string.format(chatStrings.tellIn, lcol, new_from, carriageReturn, rcol, linkedText)
		db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.tellIn, lcol, new_from, carriageReturn, rcol, text)
	
	-- Outgoing whispers
	elseif chanCode == CHAT_CHANNEL_WHISPER_SENT then
		
		-- Used for Copy
		db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copytellOut, db.LineStrings[db.lineNumber].rawFrom)
		
		message = message .. string.format(chatStrings.tellOut, lcol, new_from, carriageReturn, rcol, linkedText)
		db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.tellOut, lcol, new_from, carriageReturn, rcol, text)
	
	-- Guild chat
	elseif chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_GUILD_5 then
		
		local gtag = tag
		if db.showGuildNumbers then
			gtag = (chanCode - CHAT_CHANNEL_GUILD_1 + 1) .. "-" .. tag
			
			-- Used for Copy
			db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyguild, gtag, db.LineStrings[db.lineNumber].rawFrom)
			
			-- GuildHandler
			gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)
			message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
			db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, text)
			
		else
			
			-- Used for Copy
			db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyguild, gtag, db.LineStrings[db.lineNumber].rawFrom)
			
			-- GuildHandler
			gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)
			
			message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
			db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, text)
			
		end
	
	-- Officer chat
	elseif chanCode >= CHAT_CHANNEL_OFFICER_1 and chanCode <= CHAT_CHANNEL_OFFICER_5 then
		
		local gtag = tag
		if db.showGuildNumbers then
			gtag = (chanCode - CHAT_CHANNEL_OFFICER_1 + 1) .. "-" .. tag
			
			-- Used for Copy
			db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyguild, gtag, db.LineStrings[db.lineNumber].rawFrom)
			
			-- GuildHandler
			gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)
			
			message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
			db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, text)
		else
			
			-- Used for Copy
			db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyguild, gtag, db.LineStrings[db.lineNumber].rawFrom)
			
			-- GuildHandler
			gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)
			
			message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
			db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, text)
		end
	
	-- Player emotes
	elseif chanCode == CHAT_CHANNEL_EMOTE then
	
		db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyemote, db.LineStrings[db.lineNumber].rawFrom)
		message = message .. string.format(chatStrings.emote, lcol, new_from, rcol, linkedText)
		db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.emote, lcol, new_from, rcol, text)
	
	-- NPC emotes
	elseif chanCode == CHAT_CHANNEL_MONSTER_EMOTE then
	
		-- Used for Copy
		db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copyemote, db.LineStrings[db.lineNumber].rawFrom)
	
		message = message .. string.format(chatStrings.emote, lcol, new_from, rcol, linkedText)
		db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.emote, lcol, new_from, rcol, text)
	
	-- Language zones
	elseif chanCode >= CHAT_CHANNEL_ZONE_LANGUAGE_1 and chanCode <= CHAT_CHANNEL_ZONE_LANGUAGE_4 then
		local lang
		if chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_1 then lang = "EN"
		elseif chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_2 then lang = "FR"
		elseif chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_3 then lang = "DE"
		elseif chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_4 then lang = "JP"
		end
		
		-- Used for Copy
		db.LineStrings[db.lineNumber].rawFrom = string.format(chatStrings.copylanguage, lang, db.LineStrings[db.lineNumber].rawFrom)
		
		message = message .. string.format(chatStrings.language, lcol, lang, new_from, carriageReturn, rcol, linkedText)
		db.LineStrings[db.lineNumber].rawValue = db.LineStrings[db.lineNumber].rawValue .. string.format(chatStrings.language, lcol, lang, new_from, carriageReturn, rcol, text)
	
	-- Unknown messages - just pass it through, no changes.
	else
		local notHandled = true
		message = text
	end
	
	db.LineStrings[db.lineNumber].rawDisplayed = message
	
	-- Only if handled by rChat
	
	if not notHandled then
		-- Store message and params into an array for copy system and SpamFiltering
		StorelineNumber(GetTimeStamp(), db.LineStrings[db.lineNumber].rawFrom, text, chanCode, originalFrom)
	end
	
	-- Needs to be after .storelineNumber()
	if chanCode == CHAT_CHANNEL_WHISPER then
		OnIMReceived(displayedFrom, db.lineNumber - 1)
	end
	
	return message
	
end

-- Rewrite of core function
function CHAT_SYSTEM:AddMessage(text)

	-- Overwrite CHAT_SYSTEM:AddMessage() function to format it	
	-- Overwrite SharedChatContainer:AddDebugMessage(formattedEventText) in order to display system message in specific tabs
	-- CHAT_SYSTEM:Zo_AddMessage() can be used in order to use old function
	-- Store the message in rChatData.cachedMessages if this one is sent before CHAT_SYSTEM.primaryContainer goes up (before 1st EVENT_PLAYER_ACTIVATED)
	
	if CHAT_SYSTEM.primaryContainer and rChatData.messagesHaveBeenRestorated then
		for k in ipairs(CHAT_SYSTEM.containers) do
			CHAT_SYSTEM.containers[k]:OnChatEvent(nil, FormatSysMessage(text), CHAT_CATEGORY_SYSTEM)
		end
	else
		table.insert(rChatData.cachedMessages, text)
	end
	
end

local function EmitMessage(text)
	if CHAT_SYSTEM and CHAT_SYSTEM.primaryContainer and rChatData.messagesHaveBeenRestorated then
		if text == "" then
			text = "[Empty String]"
		end
		CHAT_SYSTEM:AddMessage(text)
	else
		table.insert(rChatData.cachedMessages, text)
	end
end

local function EmitTable(t, indent, tableHistory)
	indent		  = indent or "."
	tableHistory	= tableHistory or {}
	
	for k, v in pairs(t)
	do
		local vType = type(v)

		EmitMessage(indent.."("..vType.."): "..tostring(k).." = "..tostring(v))
		
		if(vType == "table")
		then
			if(tableHistory[v])
			then
				EmitMessage(indent.."Avoiding cycle on table...")
			else
				tableHistory[v] = true
				EmitTable(v, indent.."  ", tableHistory)
			end
		end
	end	
end

-- Rewrite of a core function
function d(...)
	for i = 1, select("#", ...) do
		local value = select(i, ...)
		if(type(value) == "table")
		then
			EmitTable(value)
		else
			EmitMessage(tostring (value))
		end
	end
end

-- Rewrite of core function
function ZO_TabButton_Text_SetTextColor(self, color)
	
	local r, g, b, a = ConvertHexToRGBA(db.colours.tabwarning)
	
	if(self.allowLabelColorChanges) then
		local label = GetControl(self, "Text")
		label:SetColor(r, g, b, a)
	end
	
end

-- Rewrite of (local) core function
local function GetOfficerChannelErrorFunction(guildIndex)
	return function()
		if(GetNumGuilds() < guildIndex) then
			return zo_strformat(SI_CANT_GUILD_CHAT_NOT_IN_GUILD, guildIndex)
		else
			return zo_strformat(SI_CANT_OFFICER_CHAT_NO_PERMISSION, GetGuildName(guildIndex))
		end
	end
end

-- Rewrite of (local) core function
local function GetGuildChannelErrorFunction(guildIndex)
	return function()
		if(GetNumGuilds() < guildIndex) then
			return zo_strformat(SI_CANT_GUILD_CHAT_NOT_IN_GUILD, guildIndex)
		else
			return zo_strformat(SI_CANT_GUILD_CHAT_NO_PERMISSION, GetGuildName(guildIndex))
		end
	end
end

local FILTERS_PER_ROW = 2

-- defines the ordering of the filter categories
local CHANNEL_ORDERING_WEIGHT = {
	[CHAT_CATEGORY_SAY] = 10,
	[CHAT_CATEGORY_YELL] = 20,

	[CHAT_CATEGORY_WHISPER_INCOMING] = 30,
	[CHAT_CATEGORY_PARTY] = 40,

	[CHAT_CATEGORY_EMOTE] = 50,
	[CHAT_CATEGORY_MONSTER_SAY] = 60,

	[CHAT_CATEGORY_ZONE] = 80,
	[CHAT_CATEGORY_ZONE_ENGLISH] = 90,

	[CHAT_CATEGORY_ZONE_FRENCH] = 100,
	[CHAT_CATEGORY_ZONE_GERMAN] = 110,

	[CHAT_CATEGORY_ZONE_JAPANESE] = 120,
	[CHAT_CATEGORY_SYSTEM] = 130,
}

local function FilterComparator(left, right)
	local leftPrimaryCategory = left.channels[1]
	local rightPrimaryCategory = right.channels[1]

	local leftWeight = CHANNEL_ORDERING_WEIGHT[leftPrimaryCategory]
	local rightWeight = CHANNEL_ORDERING_WEIGHT[rightPrimaryCategory]

	if leftWeight and rightWeight then
		return leftWeight < rightWeight
	elseif not leftWeight and not rightWeight then
		return false
	elseif leftWeight then
		return true
	end

	return false
end

local SKIP_CHANNELS = {
	-- [CHAT_CATEGORY_SYSTEM] = true,
	[CHAT_CATEGORY_GUILD_1] = true,
	[CHAT_CATEGORY_GUILD_2] = true,
	[CHAT_CATEGORY_GUILD_3] = true,
	[CHAT_CATEGORY_GUILD_4] = true,
	[CHAT_CATEGORY_GUILD_5] = true,
	[CHAT_CATEGORY_OFFICER_1] = true,
	[CHAT_CATEGORY_OFFICER_2] = true,
	[CHAT_CATEGORY_OFFICER_3] = true,
	[CHAT_CATEGORY_OFFICER_4] = true,
	[CHAT_CATEGORY_OFFICER_5] = true,
}

local FILTER_PAD_X = 90
local FILTER_PAD_Y = 0
local FILTER_WIDTH = 150
local FILTER_HEIGHT = 27
local INITIAL_XOFFS = 0
local INITIAL_YOFFS = 0

-- Rewrite of a core data
local COMBINED_CHANNELS = {
	[CHAT_CATEGORY_WHISPER_INCOMING] = {parentChannel = CHAT_CATEGORY_WHISPER_INCOMING, name = SI_CHAT_CHANNEL_NAME_WHISPER},
	[CHAT_CATEGORY_WHISPER_OUTGOING] = {parentChannel = CHAT_CATEGORY_WHISPER_INCOMING, name = SI_CHAT_CHANNEL_NAME_WHISPER},

	[CHAT_CATEGORY_MONSTER_SAY] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
	[CHAT_CATEGORY_MONSTER_YELL] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
	[CHAT_CATEGORY_MONSTER_WHISPER] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
	[CHAT_CATEGORY_MONSTER_EMOTE] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
}

-- Rewrite of a core function. Nothing is changed except in SKIP_CHANNELS set a above
function CHAT_OPTIONS:InitializeFilterButtons(dialogControl)
	--generate a table of entry data from the chat category header information
	local entryData = {}
	local lastEntry = CHAT_CATEGORY_HEADER_COMBAT - 1

	for i = CHAT_CATEGORY_HEADER_CHANNELS, lastEntry do
		if(SKIP_CHANNELS[i] == nil and GetString("SI_CHATCHANNELCATEGORIES", i) ~= "") then

			if(COMBINED_CHANNELS[i] == nil) then
				entryData[i] = 
				{
					channels = { i },
					name = GetString("SI_CHATCHANNELCATEGORIES", i),
				}
			else
				--create the entry for those with combined channels just once
				local parentChannel = COMBINED_CHANNELS[i].parentChannel

				if(not entryData[parentChannel]) then
					entryData[parentChannel] = 
					{
						channels = { },
						name = GetString(COMBINED_CHANNELS[i].name),
					}
				end

				table.insert(entryData[parentChannel].channels, i)
			end
		end
	end

	--now generate and anchor buttons
	local filterAnchor = ZO_Anchor:New(TOPLEFT, self.filterSection, TOPLEFT, 0, 0)
	local count = 0

	local sortedEntries = {}
	for _, entry in pairs(entryData) do
		sortedEntries[#sortedEntries + 1] = entry
	end

	table.sort(sortedEntries, FilterComparator)

	for _, entry in ipairs(sortedEntries) do
		local filter, key = self.filterPool:AcquireObject()
		filter.key = key

		local button = filter:GetNamedChild("Check")
		button.channels = entry.channels
		table.insert(self.filterButtons, button)

		local label = filter:GetNamedChild("Label")
		label:SetText(entry.name)

		ZO_Anchor_BoxLayout(filterAnchor, filter, count, FILTERS_PER_ROW, FILTER_PAD_X, FILTER_PAD_Y, FILTER_WIDTH, FILTER_HEIGHT, INITIAL_XOFFS, INITIAL_YOFFS)
		count = count + 1
	end
end

-- Rewrite of core data
-- Added "id" key with raw values here because of partial overwriting
local channelInfo =
{
	[CHAT_CHANNEL_SAY] = {
		format = SI_CHAT_MESSAGE_SAY,
		name = GetString(SI_CHAT_CHANNEL_NAME_SAY),
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_SAY),
		id = CHAT_CHANNEL_SAY
	},
	[CHAT_CHANNEL_YELL] =
	{
		format = SI_CHAT_MESSAGE_YELL,
		name = GetString(SI_CHAT_CHANNEL_NAME_YELL),
		playerLinkable = true,
		channelLinkable = true, -- Modified
		switches = GetString(SI_CHANNEL_SWITCH_YELL),
		id = CHAT_CHANNEL_YELL
	},
	[CHAT_CHANNEL_ZONE] =
	{
		format = SI_CHAT_MESSAGE_ZONE,
		name = GetString(SI_CHAT_CHANNEL_NAME_ZONE),
		playerLinkable = true,
		channelLinkable = true, -- Modified
		switches = GetString(SI_CHANNEL_SWITCH_ZONE),
		id = CHAT_CHANNEL_ZONE
	},
	[CHAT_CHANNEL_ZONE_LANGUAGE_1] =
	{
		format = SI_CHAT_MESSAGE_ZONE_ENGLISH,
		name = GetString(SI_CHAT_CHANNEL_NAME_ZONE_ENGLISH),
		playerLinkable = true,
		channelLinkable = true, -- Modified
		switches = GetString(SI_CHANNEL_SWITCH_ZONE_ENGLISH),
		id = CHAT_CHANNEL_ZONE_LANGUAGE_1
	},
	[CHAT_CHANNEL_ZONE_LANGUAGE_2] =
	{
		format = SI_CHAT_MESSAGE_ZONE_FRENCH,
		name = GetString(SI_CHAT_CHANNEL_NAME_ZONE_FRENCH),
		playerLinkable = true,
		channelLinkable = true, -- Modified
		switches = GetString(SI_CHANNEL_SWITCH_ZONE_FRENCH),
		id = CHAT_CHANNEL_ZONE_LANGUAGE_2
	},
	[CHAT_CHANNEL_ZONE_LANGUAGE_3] =
	{
		format = SI_CHAT_MESSAGE_ZONE_GERMAN,
		name = GetString(SI_CHAT_CHANNEL_NAME_ZONE_GERMAN),
		playerLinkable = true,
		channelLinkable = true, -- Modified
		switches = GetString(SI_CHANNEL_SWITCH_ZONE_GERMAN),
		id = CHAT_CHANNEL_ZONE_LANGUAGE_3
	},
	[CHAT_CHANNEL_ZONE_LANGUAGE_4] =
	{
		format = SI_CHAT_MESSAGE_ZONE_JAPANESE,
		name = GetString(SI_CHAT_CHANNEL_NAME_ZONE_JAPANESE),
		playerLinkable = true,
		channelLinkable = true, -- Modified
		switches = GetString(SI_CHANNEL_SWITCH_ZONE_JAPANESE),
		id = CHAT_CHANNEL_ZONE_LANGUAGE_4
	},
	[CHAT_CHANNEL_PARTY] =
	{
		format = SI_CHAT_MESSAGE_PARTY,
		name = GetString(SI_CHAT_CHANNEL_NAME_PARTY),
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_PARTY),
		requires = function()
			return IsUnitGrouped("player")
		end,
		deferRequirement = true,
		requirementErrorMessage = GetString(SI_GROUP_NOTIFICATION_YOU_ARE_NOT_IN_A_GROUP),
		id = CHAT_CHANNEL_PARTY
	},
	[CHAT_CHANNEL_WHISPER] =
	{
		format = SI_CHAT_MESSAGE_WHISPER,
		name = GetString(SI_CHAT_CHANNEL_NAME_WHISPER),
		playerLinkable = true,
		channelLinkable = false,
		switches = GetString(SI_CHANNEL_SWITCH_WHISPER),
		target = true,
		saveTarget = CHAT_CHANNEL_WHISPER,
		targetSwitches = GetString(SI_CHANNEL_SWITCH_WHISPER_REPLY),
		id = CHAT_CHANNEL_WHISPER
	},
	[CHAT_CHANNEL_WHISPER_SENT] =
	{
		format = SI_CHAT_MESSAGE_WHISPER_SENT,
		playerLinkable = true,
		channelLinkable = false,
		id = CHAT_CHANNEL_WHISPER_SENT
	},
	[CHAT_CHANNEL_EMOTE] =
	{
		format = SI_CHAT_EMOTE,
		name = GetString(SI_CHAT_CHANNEL_NAME_EMOTE),
		playerLinkable = true,
		channelLinkable = false,
		switches = GetString(SI_CHANNEL_SWITCH_EMOTE),
		id = CHAT_CHANNEL_EMOTE
	},
	[CHAT_CHANNEL_MONSTER_SAY] =
	{
		format = SI_CHAT_MONSTER_MESSAGE_SAY,
		playerLinkable = false,
		channelLinkable = false,
		id = CHAT_CHANNEL_MONSTER_SAY
	},
	[CHAT_CHANNEL_MONSTER_YELL] =
	{
		format = SI_CHAT_MONSTER_MESSAGE_YELL,
		playerLinkable = false,
		channelLinkable = false,
		id = CHAT_CHANNEL_MONSTER_YELL
	},
	[CHAT_CHANNEL_MONSTER_WHISPER] =
	{
		format = SI_CHAT_MONSTER_MESSAGE_WHISPER,
		playerLinkable = false,
		channelLinkable = false,
		id = CHAT_CHANNEL_MONSTER_WHISPER
	},
	[CHAT_CHANNEL_MONSTER_EMOTE] =
	{
		format = SI_CHAT_MONSTER_EMOTE,
		playerLinkable = false,
		channelLinkable = false,
		id = CHAT_CHANNEL_MONSTER_EMOTE
	},
	[CHAT_CHANNEL_SYSTEM] =
	{
		format = SI_CHAT_MESSAGE_SYSTEM,
		playerLinkable = false,
		channelLinkable = false,
		id = CHAT_CHANNEL_SYSTEM
	},
	[CHAT_CHANNEL_GUILD_1] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_GUILD_1),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetGuildChannelErrorFunction(1),
		deferRequirement = true,
		id = CHAT_CHANNEL_GUILD_1
	},
	[CHAT_CHANNEL_GUILD_2] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_GUILD_2),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetGuildChannelErrorFunction(2),
		deferRequirement = true,
		id = CHAT_CHANNEL_GUILD_2
	},
	[CHAT_CHANNEL_GUILD_3] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_GUILD_3),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetGuildChannelErrorFunction(3),
		deferRequirement = true,
		id = CHAT_CHANNEL_GUILD_3
	},
	[CHAT_CHANNEL_GUILD_4] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_GUILD_4),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetGuildChannelErrorFunction(4),
		deferRequirement = true,
		id = CHAT_CHANNEL_GUILD_4
	},
	[CHAT_CHANNEL_GUILD_5] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_GUILD_5),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetGuildChannelErrorFunction(5),
		deferRequirement = true,
		id = CHAT_CHANNEL_GUILD_5
	},
	[CHAT_CHANNEL_OFFICER_1] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_OFFICER_1),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetOfficerChannelErrorFunction(1),
		deferRequirement = true,
		id = CHAT_CHANNEL_OFFICER_1
	},
	[CHAT_CHANNEL_OFFICER_2] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_OFFICER_2),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetOfficerChannelErrorFunction(2),
		deferRequirement = true,
		id = CHAT_CHANNEL_OFFICER_2
	},
	[CHAT_CHANNEL_OFFICER_3] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_OFFICER_3),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetOfficerChannelErrorFunction(3),
		deferRequirement = true,
		id = CHAT_CHANNEL_OFFICER_3
	},
	[CHAT_CHANNEL_OFFICER_4] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_OFFICER_4),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetOfficerChannelErrorFunction(4),
		deferRequirement = true,
		id = CHAT_CHANNEL_OFFICER_4
	},
	[CHAT_CHANNEL_OFFICER_5] =
	{
		format = SI_CHAT_MESSAGE_GUILD,
		dynamicName = true,
		playerLinkable = true,
		channelLinkable = true,
		switches = GetString(SI_CHANNEL_SWITCH_OFFICER_5),
		requires = CanWriteGuildChannel,
		requirementErrorMessage = GetOfficerChannelErrorFunction(5),
		deferRequirement = true,
		id = CHAT_CHANNEL_OFFICER_5
	},
}

-- Rewrite of core function
function ZO_ChatSystem_GetChannelInfo()
	return channelInfo
end

-- Save chat configuration
local function SaveChatConfig()
	
	if not rChatData.tabNotBefore then
		rChatData.tabNotBefore = {} -- Init here or in SyncChatConfig depending if the "Clear Tab" has been used
	end
	
	if isAddonLoaded and CHAT_SYSTEM and CHAT_SYSTEM.primaryContainer then -- Some addons calls SetCVar before
	
		-- Rewrite the whole char tab
		db.chatConfSync[rChatData.localPlayer] = {}
		
		-- Save Chat positions
		db.chatConfSync[rChatData.localPlayer].relPoint = CHAT_SYSTEM.primaryContainer.settings.relPoint
		db.chatConfSync[rChatData.localPlayer].x = CHAT_SYSTEM.primaryContainer.settings.x
		db.chatConfSync[rChatData.localPlayer].y = CHAT_SYSTEM.primaryContainer.settings.y
		db.chatConfSync[rChatData.localPlayer].height = CHAT_SYSTEM.primaryContainer.settings.height
		db.chatConfSync[rChatData.localPlayer].width = CHAT_SYSTEM.primaryContainer.settings.width
		db.chatConfSync[rChatData.localPlayer].point = CHAT_SYSTEM.primaryContainer.settings.point
		
		--db.chatConfSync[rChatData.localPlayer].textEntryDocked = true
		
		-- Don't overflow screen, remove 10px.
		if CHAT_SYSTEM.primaryContainer.settings.height >= ( CHAT_SYSTEM.maxContainerHeight - 15 ) then
			db.chatConfSync[rChatData.localPlayer].height = ( CHAT_SYSTEM.maxContainerHeight - 15 )
		else
			db.chatConfSync[rChatData.localPlayer].height = CHAT_SYSTEM.primaryContainer.settings.height
		end
		
		-- Same
		if CHAT_SYSTEM.primaryContainer.settings.width >= ( CHAT_SYSTEM.maxContainerWidth - 15 ) then
			db.chatConfSync[rChatData.localPlayer].width = ( CHAT_SYSTEM.maxContainerWidth - 15 )
		else
			db.chatConfSync[rChatData.localPlayer].width = CHAT_SYSTEM.primaryContainer.settings.width
		end
		
		-- Save Colors
		db.chatConfSync[rChatData.localPlayer].colors = {}
		
		for _, category in ipairs (rChatData.chatCategories) do
			local r, g, b = GetChatCategoryColor(category)
			db.chatConfSync[rChatData.localPlayer].colors[category] = { red = r, green = g, blue = b }
		end
		
		-- Save Font Size
		db.chatConfSync[rChatData.localPlayer].fontSize = GetChatFontSize()
		
		-- Save Tabs
		db.chatConfSync[rChatData.localPlayer].tabs = {}
		
		-- GetNumChatContainerTabs(1) don't refresh its number before a ReloadUI
		-- for numTab = 1, GetNumChatContainerTabs(1) do
		for numTab in ipairs (CHAT_SYSTEM.primaryContainer.windows) do
			
			db.chatConfSync[rChatData.localPlayer].tabs[numTab] = {}
			
			-- Save "Clear Tab" flag
			if rChatData.tabNotBefore[numTab] then
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].notBefore = rChatData.tabNotBefore[numTab]
			end
			
			-- No.. need a ReloadUI		local name, isLocked, isInteractable, isCombatLog, areTimestampsEnabled = GetChatContainerTabInfo(1, numTab)
			-- IsLocked
			if CHAT_SYSTEM.primaryContainer:IsLocked(numTab) then
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].isLocked = true
			else
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].isLocked = false
			end
			
			-- IsInteractive
			if CHAT_SYSTEM.primaryContainer:IsInteractive(numTab) then
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].isInteractable = true
			else
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].isInteractable = false
			end
			
			-- IsCombatLog
			if CHAT_SYSTEM.primaryContainer:IsCombatLog(numTab) then
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].isCombatLog = true
				-- AreTimestampsEnabled
				if CHAT_SYSTEM.primaryContainer:AreTimestampsEnabled(numTab) then
					db.chatConfSync[rChatData.localPlayer].tabs[numTab].areTimestampsEnabled = true
				else
					db.chatConfSync[rChatData.localPlayer].tabs[numTab].areTimestampsEnabled = false
				end
			else
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].isCombatLog = false
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].areTimestampsEnabled = false
			end
			
			-- GetTabName
			db.chatConfSync[rChatData.localPlayer].tabs[numTab].name = CHAT_SYSTEM.primaryContainer:GetTabName(numTab)
			
			-- Enabled categories
			db.chatConfSync[rChatData.localPlayer].tabs[numTab].enabledCategories = {}
			
			for _, category in ipairs (rChatData.chatCategories) do
				local isEnabled = IsChatContainerTabCategoryEnabled(1, numTab, category)
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].enabledCategories[category] = isEnabled
			end
			
		end
		
		db.chatConfSync.lastChar = db.chatConfSync[rChatData.localPlayer]
		
	end
	
end

-- Save Chat Tabs config when user changes it
local function SaveTabsCategories()
	
	for numTab in ipairs (CHAT_SYSTEM.primaryContainer.windows) do
		
		for _, category in ipairs (rChatData.guildCategories) do
			local isEnabled = IsChatContainerTabCategoryEnabled(1, numTab, category)
			if db.chatConfSync[rChatData.localPlayer].tabs[numTab] then
				db.chatConfSync[rChatData.localPlayer].tabs[numTab].enabledCategories[category] = isEnabled
			else
				SaveChatConfig()
			end
		end
		
	end
	
end

-- Function for Minimizing chat at launch
local function MinimizeChatAtLaunch()
	if db.chatMinimizedAtLaunch then
		CHAT_SYSTEM:Minimize()
	end
end

local function MinimizeChatInMenus()

	-- RegisterCallback for Maximize/Minimize chat when entering/leaving scenes
	-- "hud" is base scene (with "hudui")
	local hudScene = SCENE_MANAGER:GetScene("hud")
	hudScene:RegisterCallback("StateChange", function(oldState, newState)

		if db.chatMinimizedInMenus then
			if newState == SCENE_HIDDEN and SCENE_MANAGER:GetNextScene():GetName() ~= "hudui" then
				CHAT_SYSTEM:Minimize()
			end
		end
		
		if db.chatMaximizedAfterMenus then
			if newState == SCENE_SHOWING then
				CHAT_SYSTEM:Maximize()
			end
		end
		
	end)
	
end

-- Set the chat config from rChat settings
local function SyncChatConfig(shouldSync, whichChar)

	if shouldSync then
		if db.chatConfSync then
			if db.chatConfSync[whichChar] then
				
				-- Position and width/height
				CHAT_SYSTEM.control:SetAnchor(db.chatConfSync[whichChar].point, GuiRoot, db.chatConfSync[whichChar].relPoint, db.chatConfSync[whichChar].x, db.chatConfSync[whichChar].y)
				-- Height / Width
				CHAT_SYSTEM.control:SetDimensions(db.chatConfSync[whichChar].width, db.chatConfSync[whichChar].height)
				
				-- Save settings immediatly (to check, maybe call function which do this)
				CHAT_SYSTEM.primaryContainer.settings.height = db.chatConfSync[whichChar].height
				CHAT_SYSTEM.primaryContainer.settings.point = db.chatConfSync[whichChar].point
				CHAT_SYSTEM.primaryContainer.settings.relPoint = db.chatConfSync[whichChar].relPoint
				CHAT_SYSTEM.primaryContainer.settings.width = db.chatConfSync[whichChar].width
				CHAT_SYSTEM.primaryContainer.settings.x = db.chatConfSync[whichChar].x
				CHAT_SYSTEM.primaryContainer.settings.y = db.chatConfSync[whichChar].y
				
				--[[
				-- Don't overflow screen, remove 15px.
				if db.chatConfSync[whichChar].height >= (CHAT_SYSTEM.maxContainerHeight - 15 ) then
					CHAT_SYSTEM.control:SetHeight((CHAT_SYSTEM.maxContainerHeight - 15 ))
					d("Overflow height " .. db.chatConfSync[whichChar].height .. " -+- " .. (CHAT_SYSTEM.maxContainerHeight - 15))
					d(CHAT_SYSTEM.control:GetHeight())
				else
					-- Don't set good values ?! SetHeight(674) = GetHeight(524) ? same with Width and resizing is buggy
					--CHAT_SYSTEM.control:SetHeight(db.chatConfSync[whichChar].height)
					CHAT_SYSTEM.control:SetDimensions(settings.width, settings.height)
					d("height " .. db.chatConfSync[whichChar].height .. " -+- " .. CHAT_SYSTEM.control:GetHeight())
				end
				
				-- Same
				if db.chatConfSync[whichChar].width >= (CHAT_SYSTEM.maxContainerWidth - 15 ) then
					CHAT_SYSTEM.control:SetWidth((CHAT_SYSTEM.maxContainerWidth - 15 ))
					d("Overflow width " .. db.chatConfSync[whichChar].width .. " -+- " .. (CHAT_SYSTEM.maxContainerWidth - 15))
					d(CHAT_SYSTEM.control:GetWidth())
				else
					CHAT_SYSTEM.control:SetHeight(db.chatConfSync[whichChar].width)
					d("width " .. db.chatConfSync[whichChar].width .. " -+- " .. CHAT_SYSTEM.control:GetWidth())
				end
				]]--
				
				-- Colors
				for _, category in ipairs (rChatData.chatCategories) do
					if not db.chatConfSync[whichChar].colors[category] then
						local r, g, b = GetChatCategoryColor(category)
						db.chatConfSync[whichChar].colors[category] = { red = r, green = g, blue = b }
					end
					SetChatCategoryColor(category, db.chatConfSync[whichChar].colors[category].red, db.chatConfSync[whichChar].colors[category].green, db.chatConfSync[whichChar].colors[category].blue) 
				end
				
				-- Font Size
				-- Not in Realtime SetChatFontSize(db.chatConfSync[whichChar].fontSize), need to add CHAT_SYSTEM:SetFontSize for Realtimed
				
				-- ?!? Need to go by a local?..
				local fontSize = db.chatConfSync[whichChar].fontSize
				CHAT_SYSTEM:SetFontSize(fontSize)
				SetChatFontSize(db.chatConfSync[whichChar].fontSize)
				local chatSyncNumTab = 1
				
				for numTab in ipairs(db.chatConfSync[whichChar].tabs) do
					
					--Create a Tab if nessesary
					if (GetNumChatContainerTabs(1) < numTab) then
						-- AddChatContainerTab(1, , db.chatConfSync[whichChar].tabs[numTab].isCombatLog) No ! Require a ReloadUI
						CHAT_SYSTEM.primaryContainer:AddWindow(db.chatConfSync[whichChar].tabs[numTab].name)
					end
					
					if db.chatConfSync[whichChar].tabs[numTab] and db.chatConfSync[whichChar].tabs[numTab].notBefore then
					
						if not rChatData.tabNotBefore then
							rChatData.tabNotBefore = {} -- Used for tab restoration, init here.
						end
						
						rChatData.tabNotBefore[numTab] = db.chatConfSync[whichChar].tabs[numTab].notBefore
						
					end
					
					-- Set Tab options
					-- Not in realtime : SetChatContainerTabInfo(1, numTab, db.chatConfSync[whichChar].tabs[numTab].name, db.chatConfSync[whichChar].tabs[numTab].isLocked, db.chatConfSync[whichChar].tabs[numTab].isInteractable, db.chatConfSync[whichChar].tabs[numTab].areTimestampsEnabled)
					
					CHAT_SYSTEM.primaryContainer:SetTabName(numTab, db.chatConfSync[whichChar].tabs[numTab].name)
					CHAT_SYSTEM.primaryContainer:SetLocked(numTab, db.chatConfSync[whichChar].tabs[numTab].isLocked)
					CHAT_SYSTEM.primaryContainer:SetInteractivity(numTab, db.chatConfSync[whichChar].tabs[numTab].isInteractable)
					CHAT_SYSTEM.primaryContainer:SetTimestampsEnabled(numTab, db.chatConfSync[whichChar].tabs[numTab].areTimestampsEnabled)
					
					-- Set Channel per tab configuration
					for _, category in ipairs (rChatData.chatCategories) do
						if db.chatConfSync[whichChar].tabs[numTab].enabledCategories[category] == nil then -- Cal be false
							db.chatConfSync[whichChar].tabs[numTab].enabledCategories[category] = IsChatContainerTabCategoryEnabled(1, numTab, category)
						end
						SetChatContainerTabCategoryEnabled(1, numTab, category, db.chatConfSync[whichChar].tabs[numTab].enabledCategories[category])
					end
					
					chatSyncNumTab = numTab
					
				end
				
				-- If they're was too many tabs before, drop them
				local removeTabs = true
				while removeTabs do
					-- Too many tabs, deleting one
					if GetNumChatContainerTabs(1) > chatSyncNumTab then
						-- Not in realtime : RemoveChatContainerTab(1, chatSyncNumTab + 1)
						CHAT_SYSTEM.primaryContainer:RemoveWindow(chatSyncNumTab + 1, nil)
					else
						removeTabs = false
					end
				end
			
			end
		end
	end

end

-- When creating a char, try to import settings
local function AutoSyncSettingsForNewPlayer()
	
	-- New chars get automaticaly last char config
	if GetIsNewCharacter() then
		SyncChatConfig(true, "lastChar")
	end
	
end

-- Set channel to the default one
local function SetToDefaultChannel()
	if db.defaultchannel ~= RCHAT_CHANNEL_NONE then
		CHAT_SYSTEM:SetChannel(db.defaultchannel)
	end
end

local function SaveGuildIndexes()

	rChatData.guildIndexes = {}
	
	for guild = 1, GetNumGuilds() do
		
		-- Guildname
		local guildId = GetGuildId(guild)
		local guildName = GetGuildName(guildId)
		
		-- Occurs sometimes
		if(not guildName or (guildName):len() < 1) then
			guildName = "Guild " .. guildId
		end
		
		rChatData.guildIndexes[guildName] = guild
	
	end
	
end

-- Executed when EVENT_IGNORE_ADDED triggers
local function OnIgnoreAdded(displayName)
	
	-- DisplayName is linkable
	local displayNameLink = ZO_LinkHandler_CreateDisplayNameLink(displayName)
	local statusMessage = zo_strformat(SI_FRIENDS_LIST_IGNORE_ADDED, displayNameLink)
	
	-- Only if statusMessage is set
	if statusMessage then
		return FormatSysMessage(statusMessage)
	end
	
end

-- Executed when EVENT_IGNORE_REMOVED triggers
local function OnIgnoreRemoved(displayName)
	
	-- DisplayName is linkable
	local displayNameLink = ZO_LinkHandler_CreateDisplayNameLink(displayName)
	local statusMessage = zo_strformat(SI_FRIENDS_LIST_IGNORE_REMOVED, displayNameLink)
	
	-- Only if statusMessage is set
	if statusMessage then
		return FormatSysMessage(statusMessage)
	end
	
end

-- triggers when EVENT_FRIEND_PLAYER_STATUS_CHANGED
local function OnFriendPlayerStatusChanged(displayName, characterName, oldStatus, newStatus)

	local statusMessage
	
	-- DisplayName is linkable
	local displayNameLink = ZO_LinkHandler_CreateDisplayNameLink(displayName)
	-- CharacterName is linkable
	local characterNameLink = ZO_LinkHandler_CreateCharacterLink(characterName)
	
	local wasOnline = oldStatus ~= PLAYER_STATUS_OFFLINE
	local isOnline = newStatus ~= PLAYER_STATUS_OFFLINE
	
	-- Not connected before and Connected now (no messages for Away/Busy)
	if not wasOnline and isOnline then
		-- Return
		statusMessage = zo_strformat(SI_FRIENDS_LIST_FRIEND_CHARACTER_LOGGED_ON, displayNameLink, characterNameLink)
	-- Connected before and Offline now
	elseif wasOnline and not isOnline then
		statusMessage = zo_strformat(SI_FRIENDS_LIST_FRIEND_CHARACTER_LOGGED_OFF, displayNameLink, characterNameLink)
	end
	
	-- Only if statusMessage is set
	if statusMessage then
		return FormatSysMessage(statusMessage)
	end

end

-- Executed when EVENT_GROUP_TYPE_CHANGED triggers
local function OnGroupTypeChanged(largeGroup)
	
	if largeGroup then
		return FormatSysMessage(GetString(SI_CHAT_ANNOUNCEMENT_IN_LARGE_GROUP))
	else
		return FormatSysMessage(GetString(SI_CHAT_ANNOUNCEMENT_IN_SMALL_GROUP))
	end

end

local function OnGroupMemberLeft(_, reason, isLocalPlayer, _, _, actionRequiredVote)
	if reason == GROUP_LEAVE_REASON_KICKED and isLocalPlayer and actionRequiredVote then
		return GetString(SI_GROUP_ELECTION_KICK_PLAYER_PASSED)
	end
end

local function UpdateCharCorrespondanceTableSwitchs()

	-- Each guild
	for i = 1, GetNumGuilds() do
			
		-- Get saved string
		local switch = db.switchFor[GetGuildName(GetGuildId(i))]
		
		if switch and switch ~= "" then
			switch = GetString(SI_CHANNEL_SWITCH_GUILD_1 - 1 + i) .. " " .. switch
		else
			switch = GetString(SI_CHANNEL_SWITCH_GUILD_1 - 1 + i)
		end
		
		ChanInfoArray[CHAT_CHANNEL_GUILD_1 - 1 + i].switches = switch
		
		-- Get saved string
		local officerSwitch = db.officerSwitchFor[GetGuildName(GetGuildId(i))]
		
		-- No SavedVar
		if officerSwitch and officerSwitch ~= "" then
			officerSwitch = GetString(SI_CHANNEL_SWITCH_OFFICER_1 - 1 + i)  .. " " .. officerSwitch
		else
			officerSwitch = GetString(SI_CHANNEL_SWITCH_OFFICER_1 - 1 + i)
		end
		
		ChanInfoArray[CHAT_CHANNEL_OFFICER_1 - 1 + i].switches = officerSwitch
		
	end

end

-- *********************************************************************************
-- * Section: LAM Outside Functions : used in LAM but function resides outside LAM
-- *********************************************************************************
-- Character Sync
local function SyncCharacterSelectChoices()
	-- Sync Character Select
	rChatData.chatConfSyncChoices = {}
	if db.chatConfSync then
		for names, tagada in pairs (db.chatConfSync) do
			if names ~= "lastChar" then
				table.insert(rChatData.chatConfSyncChoices, names)
			end
		end
	else
		table.insert(rChatData.chatConfSyncChoices, rChatData.localPlayer)
	end
end


-- *********************************************************************************
-- * Section: Settings Start (LAM)
-- *********************************************************************************
-- Build LAM Option Table, used when AddonLoads or when a player join/leave a guild
local function BuildLAMPanel()

	-- Used to reset colors to default value, lam need a formatted array
	-- LAM Message Settings
	
	local fontsDefined = LMP:List('font')
	
	local function ConvertHexToRGBAPacked(colourString)
		local r, g, b, a = ConvertHexToRGBA(colourString)
		return {r = r, g = g, b = b, a = a}
	end
		-- Sync Character Select
	rChatData.chatConfSyncChoices = {}
	if db.chatConfSync then
		for names, tagada in pairs (db.chatConfSync) do
			if names ~= "lastChar" then
				table.insert(rChatData.chatConfSyncChoices, names)
			end
		end
	else
		table.insert(rChatData.chatConfSyncChoices, rChatData.localPlayer)
	end
	
	-- CHAT_SYSTEM.primaryContainer.windows doesn't exists yet at OnAddonLoaded. So using the rChat reference.
	local arrayTab = {}
	if db.chatConfSync and db.chatConfSync[rChatData.localPlayer] and db.chatConfSync[rChatData.localPlayer].tabs then
		for numTab, data in pairs (db.chatConfSync[rChatData.localPlayer].tabs) do
			table.insert(arrayTab, numTab)
		end
	else
		table.insert(arrayTab, 1)
	end
	
	getTabNames()

	local optionsData = {}

	-- Messages Settings
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_OPTIONSH),
		controls = {
			{-- LAM Option Show Guild Numbers
				type = "checkbox",
				name = GetString(RCHAT_GUILDNUMBERS),
				tooltip = GetString(RCHAT_GUILDNUMBERSTT),
				getFunc = function() return db.showGuildNumbers end,
				setFunc = function(newValue)
					db.showGuildNumbers = newValue
				end,
				width = "full",
				default = defaults.showGuildNumbers,
			},
			{-- LAM Option Use Same Color for all Guilds
				type = "checkbox",
				name = GetString(RCHAT_ALLGUILDSSAMECOLOUR),
				tooltip = GetString(RCHAT_ALLGUILDSSAMECOLOURTT),
				getFunc = function() return db.allGuildsSameColour end,
				setFunc = function(newValue) db.allGuildsSameColour = newValue end,
				width = "full",
				default = defaults.allGuildsSameColour,
			},
			{-- LAM Option Use same color for all zone chats
				type = "checkbox",
				name = GetString(RCHAT_ALLZONESSAMECOLOUR),
				tooltip = GetString(RCHAT_ALLZONESSAMECOLOURTT),
				getFunc = function() return db.allZonesSameColour end,
				setFunc = function(newValue) db.allZonesSameColour = newValue end,
				width = "full",
				default = defaults.allZonesSameColour,
			},
			{-- LAM Option Use same color for all NPC
				type = "checkbox",
				name = GetString(RCHAT_ALLNPCSAMECOLOUR),
				tooltip = GetString(RCHAT_ALLNPCSAMECOLOURTT),
				getFunc = function() return db.allNPCSameColour end,
				setFunc = function(newValue) db.allNPCSameColour = newValue end,
				width = "full",
				default = defaults.allNPCSameColour,
			},
			{-- LAM Option Remove Zone Tags
				type = "checkbox",
				name = GetString(RCHAT_DELZONETAGS),
				tooltip = GetString(RCHAT_DELZONETAGSTT),
				getFunc = function() return db.delzonetags end,
				setFunc = function(newValue) db.delzonetags = newValue end,
				width = "full",
				default = defaults.delzonetags,
			},
			{-- LAM Option Newline between name and message
				type = "checkbox",
				name = GetString(RCHAT_CARRIAGERETURN),
				tooltip = GetString(RCHAT_CARRIAGERETURNTT),
				getFunc = function() return db.carriageReturn end,
				setFunc = function(newValue) db.carriageReturn = newValue end,
				width = "full",
				default = defaults.carriageReturn,
			},
			{-- LAM Option Use ESO Colors
				type = "checkbox",
				name = GetString(RCHAT_USEESOCOLORS),
				tooltip = GetString(RCHAT_USEESOCOLORSTT),
				getFunc = function() return db.useESOcolors end,
				setFunc = function(newValue) db.useESOcolors = newValue end,
				width = "full",
				default = defaults.useESOcolors,
			},
			{-- LAM Option Difference Between ESO Colors
				type = "slider",
				name = GetString(RCHAT_DIFFFORESOCOLORS),
				tooltip = GetString(RCHAT_DIFFFORESOCOLORSTT),
				min = 0,
				max = 100,
				step = 1,
				getFunc = function() return db.diffforESOcolors end,
				setFunc = function(newValue) db.diffforESOcolors = newValue end,
				width = "full",
				default = defaults.diffforESOcolors,
				disabled = function() return not db.useESOcolors end,
			},
			{-- LAM Option Prevent Chat Fading
				type = "checkbox",
				name = GetString(RCHAT_PREVENTCHATTEXTFADING),
				tooltip = GetString(RCHAT_PREVENTCHATTEXTFADINGTT),
				getFunc = function() return db.alwaysShowChat end,
				setFunc = function(newValue) db.alwaysShowChat = newValue end,
				width = "full",
				default = defaults.alwaysShowChat,
			},
			{-- Augment lines of chat
				type = "checkbox",
				name = GetString(RCHAT_AUGMENTHISTORYBUFFER),
				tooltip = GetString(RCHAT_AUGMENTHISTORYBUFFERTT),
				getFunc = function() return db.augmentHistoryBuffer end,
				setFunc = function(newValue) db.augmentHistoryBuffer = newValue end,
				width = "full",
				default = defaults.augmentHistoryBuffer,
			},
			{-- LAM Option Use one color for lines
				type = "checkbox",
				name = GetString(RCHAT_USEONECOLORFORLINES),
				tooltip = GetString(RCHAT_USEONECOLORFORLINESTT),
				getFunc = function() return db.oneColour end,
				setFunc = function(newValue) db.oneColour = newValue end,
				width = "full",
				default = defaults.oneColour,
			},
			{-- LAM Option Guild Tags next to entry box
				type = "checkbox",
				name = GetString(RCHAT_GUILDTAGSNEXTTOENTRYBOX),
				tooltip = GetString(RCHAT_GUILDTAGSNEXTTOENTRYBOXTT),
				width = "full",
				default = defaults.showTagInEntry,
				getFunc = function() return db.showTagInEntry end,
				setFunc = function(newValue)
							db.showTagInEntry = newValue
							UpdateCharCorrespondanceTableChannelNames()
						end
			},
			{-- LAM Option Names Format
				type = "dropdown",
				name = GetString(RCHAT_GEOCHANNELSFORMAT),
				tooltip = GetString(RCHAT_GEOCHANNELSFORMATTT),
				choices = {GetString("RCHAT_GROUPNAMESCHOICE", 1), GetString("RCHAT_GROUPNAMESCHOICE", 2), GetString("RCHAT_GROUPNAMESCHOICE", 3)}, -- Same as group.
				width = "full",
				default = defaults.geoChannelsFormat,
				getFunc = function() return GetString("RCHAT_GROUPNAMESCHOICE", db.geoChannelsFormat) end,
				setFunc = function(choice)
					if choice == GetString("RCHAT_GROUPNAMESCHOICE", 1) then
						db.geoChannelsFormat = 1
					elseif choice == GetString("RCHAT_GROUPNAMESCHOICE", 2) then
						db.geoChannelsFormat = 2
					elseif choice == GetString("RCHAT_GROUPNAMESCHOICE", 3) then
						db.geoChannelsFormat = 3
					else
						-- When clicking on LAM default button
						db.geoChannelsFormat = defaults.geoChannelsFormat
					end
					
				end,
			},
			{-- Disable Brackets
				type = "checkbox",
				name = GetString(RCHAT_DISABLEBRACKETS),
				tooltip = GetString(RCHAT_DISABLEBRACKETSTT),
				getFunc = function() return db.disableBrackets end,
				setFunc = function(newValue) db.disableBrackets = newValue end,
				width = "full",
				default = defaults.disableBrackets,
			},
			{--Traget Histoyr
				type = "checkbox",
				name = GetString(RCHAT_ADDCHANNELANDTARGETTOHISTORY),
				tooltip = GetString(RCHAT_ADDCHANNELANDTARGETTOHISTORYTT),
				getFunc = function() return db.addChannelAndTargetToHistory end,
				setFunc = function(newValue) db.addChannelAndTargetToHistory = newValue end,
				width = "full",
				default = defaults.addChannelAndTargetToHistory,
			},
			{-- URL is clickable		
				type = "checkbox",
				name = GetString(RCHAT_URLHANDLING),
				tooltip = GetString(RCHAT_URLHANDLINGTT),
				getFunc = function() return db.urlHandling end,
				setFunc = function(newValue) db.urlHandling = newValue end,
				width = "full",
				default = defaults.urlHandling,
			},
			{-- Copy Chat
				type = "checkbox",
				name = GetString(RCHAT_ENABLECOPY),
				tooltip = GetString(RCHAT_ENABLECOPYTT),
				getFunc = function() return db.enablecopy end,
				setFunc = function(newValue) db.enablecopy = newValue end,
				width = "full",
				default = defaults.enablecopy,
			},--
		},
	} -- Chat Tabs
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_CHATTABH),
		controls = {
			{-- Enable chat channel memory
				type = "checkbox",
				name = GetString(RCHAT_enableChatTabChannel),
				tooltip = GetString(RCHAT_enableChatTabChannelT),
				getFunc = function() return db.enableChatTabChannel end,
				setFunc = function(newValue) db.enableChatTabChannel = newValue end,
				width = "full",
				default = defaults.enableChatTabChannel,
			},
			{-- TODO : optimize
				type = "dropdown",
				name = GetString(RCHAT_DEFAULTCHANNEL),
				tooltip = GetString(RCHAT_DEFAULTCHANNELTT),
				--choices = chatTabNames,
				choices = {
					GetString("RCHAT_DEFAULTCHANNELCHOICE", RCHAT_CHANNEL_NONE),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_ZONE),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_SAY),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_1),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_2),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_3),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_4),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_5),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_1),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_2),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_3),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_4),
					GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_5)
				},
				width = "full",
				default = defaults.defaultchannel,
				getFunc = function() return GetString("RCHAT_DEFAULTCHANNELCHOICE", db.defaultchannel) end,
				setFunc = function(choice)
					if choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_ZONE) then
						db.defaultchannel = CHAT_CHANNEL_ZONE
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_SAY) then
						db.defaultchannel = CHAT_CHANNEL_SAY
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_1) then
						db.defaultchannel = CHAT_CHANNEL_GUILD_1
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_2) then
						db.defaultchannel = CHAT_CHANNEL_GUILD_2
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_3) then
						db.defaultchannel = CHAT_CHANNEL_GUILD_3
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_4) then
						db.defaultchannel = CHAT_CHANNEL_GUILD_4
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_5) then
						db.defaultchannel = CHAT_CHANNEL_GUILD_5
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_1) then
						db.defaultchannel = CHAT_CHANNEL_OFFICER_1
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_2) then
						db.defaultchannel = CHAT_CHANNEL_OFFICER_2
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_3) then
						db.defaultchannel = CHAT_CHANNEL_OFFICER_3
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_4) then
						db.defaultchannel = CHAT_CHANNEL_OFFICER_4
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_5) then
						db.defaultchannel = CHAT_CHANNEL_OFFICER_5
					elseif choice == GetString("RCHAT_DEFAULTCHANNELCHOICE", RCHAT_CHANNEL_NONE) then
						db.defaultchannel = RCHAT_CHANNEL_NONE
					else
						-- When user click on LAM reinit button
						db.defaultchannel = defaults.defaultchannel
					end
					
				end,
			},
			{-- CHAT_SYSTEM.primaryContainer.windows doesn't exists yet at OnAddonLoaded. So using the rChat reference.
				type = "dropdown",
				name = GetString(RCHAT_DEFAULTTAB),
				tooltip = GetString(RCHAT_DEFAULTTABTT),
				choices = tabNames,
				width = "full",
				getFunc = function() return db.defaultTabName end,
				setFunc = 	function(choice) 
								db.defaultTabName = choice
								--d(choice)
								--d(db.defaultTabName)
								db.defaultTab = getTabIdx(choice)
								--d(db.defaultTab)
							end,
			},
			--[[{-- CHAT_SYSTEM.primaryContainer.windows doesn't exists yet at OnAddonLoaded. So using the rChat reference.
				type = "dropdown",
				name = GetString(RCHAT_DEFAULTTAB),
				tooltip = GetString(RCHAT_DEFAULTTABTT),
				choices = arrayTab,
				width = "full",
				default = defaults.defaultTab,
				getFunc = function() return db.defaultTab end,
				setFunc = function(choice) db.defaultTab = choice end,
			},]]--
			--[[{-- Enable whisper redirect
				type = "checkbox",
				name = GetString(RCHAT_enableWhisperTab),
				tooltip = GetString(RCHAT_enableWhisperTabT),
				getFunc = function() return db.enableWhisperTab end,
				setFunc = function(newValue) db.enableWhisperTab = newValue end,
				width = "full",
				default = defaults.enableWhisperTab,
			},]]--
			-- !!!!!need code for specific tab here
		},
	} -- Group Submenu
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_GROUPH),
		controls = {
			{-- Enable Party Switch
				type = "checkbox",
				name = GetString(RCHAT_ENABLEPARTYSWITCH),
				tooltip = GetString(RCHAT_ENABLEPARTYSWITCHTT),
				getFunc = function() return db.enablepartyswitch end,
				setFunc = function(newValue) db.enablepartyswitch = newValue end,
				width = "full",
				default = defaults.enablepartyswitch,
			},
			{-- Group Leader
				type = "checkbox",
				name = GetString(RCHAT_GROUPLEADER),
				tooltip = GetString(RCHAT_GROUPLEADERTT),
				getFunc = function() return db.groupLeader end,
				setFunc = function(newValue) db.groupLeader = newValue end,
				width = "full",
				default = defaults.groupLeader,
			},
			{-- Group Leader Color
				type = "colorpicker",
				name = GetString(RCHAT_GROUPLEADERCOLOR),
				tooltip = GetString(RCHAT_GROUPLEADERCOLORTT),
				getFunc = function() return ConvertHexToRGBA(db.colours["groupleader"]) end,
				setFunc = function(r, g, b) db.colours["groupleader"] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours["groupleader"]),
				disabled = function() return not db.groupLeader end,
			},
			{-- Group Leader Coor 2
				type = "colorpicker",
				name = GetString(RCHAT_GROUPLEADERCOLOR1),
				tooltip = GetString(RCHAT_GROUPLEADERCOLOR1TT),
				getFunc = function() return ConvertHexToRGBA(db.colours["groupleader1"]) end,
				setFunc = function(r, g, b) db.colours["groupleader1"] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours["groupleader1"]),
				disabled = function()
						if not db.groupLeader then
							return true
						elseif db.useESOcolors then
							return true
						else
							return false
						end
					end,
			},
			{-- Group Names
				type = "dropdown",
				name = GetString(RCHAT_GROUPNAMES),
				tooltip = GetString(RCHAT_GROUPNAMESTT),
				choices = {GetString("RCHAT_GROUPNAMESCHOICE", 1), GetString("RCHAT_GROUPNAMESCHOICE", 2), GetString("RCHAT_GROUPNAMESCHOICE", 3)},
				width = "full",
				default = defaults.groupNames,
				getFunc = function() return GetString("RCHAT_GROUPNAMESCHOICE", db.groupNames) end,
				setFunc = function(choice)
					if choice == GetString("RCHAT_GROUPNAMESCHOICE", 1) then
						db.groupNames = 1
					elseif choice == GetString("RCHAT_GROUPNAMESCHOICE", 2) then
						db.groupNames = 2
					elseif choice == GetString("RCHAT_GROUPNAMESCHOICE", 3) then
						db.groupNames = 3
					else
						-- When clicking on LAM default button
						db.groupNames = defaults.groupNames
					end
					
				end,
			},
		},
	} -- Sync Settings Header
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_SYNCH),
		controls = {
			{-- Sync ON
				type = "checkbox",
				name = GetString(RCHAT_CHATSYNCCONFIG),
				tooltip = GetString(RCHAT_CHATSYNCCONFIGTT),
				getFunc = function() return db.chatSyncConfig end,
				setFunc = function(newValue) db.chatSyncConfig = newValue end,
				width = "full",
				default = defaults.chatSyncConfig,
			},
			{-- Config Import From
				type = "dropdown",
				name = GetString(RCHAT_CHATSYNCCONFIGIMPORTFROM),
				tooltip = GetString(RCHAT_CHATSYNCCONFIGIMPORTFROMTT),
				choices = rChatData.chatConfSyncChoices,
				width = "full",
				getFunc = function() return rChatData.localPlayer end,
				setFunc = function(choice)
					SyncChatConfig(true, choice)
				end,
			},
		},
	} -- Mouse
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_APPARENCEMH),
		controls = {
			{--	New Message Color
				type = "colorpicker",
				name = GetString(RCHAT_TABWARNING),
				tooltip = GetString(RCHAT_TABWARNINGTT),
				getFunc = function() return ConvertHexToRGBA(db.colours["tabwarning"]) end,
				setFunc = function(r, g, b) db.colours["tabwarning"] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours["tabwarning"]),
			},
			{-- Chat Window Transparency
				type = "slider",
				name = GetString(RCHAT_WINDOWDARKNESS),
				tooltip = GetString(RCHAT_WINDOWDARKNESSTT),
				min = 0,
				max = 11,
				step = 1,
				getFunc = function() return db.windowDarkness end,
				setFunc = function(newValue)
					db.windowDarkness = newValue
					ChangeChatWindowDarkness(true)
					CHAT_SYSTEM:Maximize()
				end,
				width = "full",
				default = defaults.windowDarkness,
			},
			{-- Minimize at luanch
				type = "checkbox",
				name = GetString(RCHAT_CHATMINIMIZEDATLAUNCH),
				tooltip = GetString(RCHAT_CHATMINIMIZEDATLAUNCHTT),
				getFunc = function() return db.chatMinimizedAtLaunch end,
				setFunc = function(newValue) db.chatMinimizedAtLaunch = newValue end,
				width = "full",
				default = defaults.chatMinimizedAtLaunch,
			},
			{-- Minimize Menues
				type = "checkbox",
				name = GetString(RCHAT_CHATMINIMIZEDINMENUS),
				tooltip = GetString(RCHAT_CHATMINIMIZEDINMENUSTT),
				getFunc = function() return db.chatMinimizedInMenus end,
				setFunc = function(newValue) db.chatMinimizedInMenus = newValue end,
				width = "full",
				default = defaults.chatMinimizedInMenus,
			},
			{ -- Mximize After Menus
				type = "checkbox",
				name = GetString(RCHAT_CHATMAXIMIZEDAFTERMENUS),
				tooltip = GetString(RCHAT_CHATMAXIMIZEDAFTERMENUSTT),
				getFunc = function() return db.chatMaximizedAfterMenus end,
				setFunc = function(newValue) db.chatMaximizedAfterMenus = newValue end,
				width = "full",
				default = defaults.chatMaximizedAfterMenus,
			},
			{ -- Fonts
				type = "dropdown",
				name = GetString(RCHAT_FONTCHANGE),
				tooltip = GetString(RCHAT_FONTCHANGETT),
				choices = fontsDefined,
				width = "full",
				getFunc = function() return db.fonts end,
				setFunc = function(choice)
					db.fonts = choice
					ChangeChatFont(true)
					ReloadUI()
				end,
				default = defaults.fontChange,
				warning = "ReloadUI"
			},
		},
	} -- LAM Menu Whispers
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_IMH),
		controls = {
			{-- LAM Option Whispers: Sound
				type = "dropdown",
				name = GetString(RCHAT_SOUNDFORINCWHISPS),
				tooltip = GetString(RCHAT_SOUNDFORINCWHISPSTT),
				choices = {
					GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 1),
					GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 2),
					GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 3),
					GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 4),
					},
				width = "full",
				default = defaults.soundforincwhisps, --> SOUNDS.NEW_NOTIFICATION
				getFunc = function() 
					if db.soundforincwhisps == SOUNDS.NONE then
						return GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 1)
					elseif db.soundforincwhisps == SOUNDS.NEW_NOTIFICATION then
						return GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 2)
					elseif db.soundforincwhisps == SOUNDS.DEFAULT_CLICK then
						return GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 3)
					elseif db.soundforincwhisps == SOUNDS.EDIT_CLICK then
						return GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 4)
					else
						return GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 2)
					end
				end,
				setFunc = function(choice)
					if choice == GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 1) then
						db.soundforincwhisps = SOUNDS.NONE
						PlaySound(SOUNDS.NONE)
					elseif choice == GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 2) then
						db.soundforincwhisps = SOUNDS.NEW_NOTIFICATION
						PlaySound(SOUNDS.NEW_NOTIFICATION)
					elseif choice == GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 3) then
						db.soundforincwhisps = SOUNDS.DEFAULT_CLICK
						PlaySound(SOUNDS.DEFAULT_CLICK)
					elseif choice == GetString("RCHAT_SOUNDFORINCWHISPSCHOICE", 4) then
						db.soundforincwhisps = SOUNDS.EDIT_CLICK
						PlaySound(SOUNDS.EDIT_CLICK)
					else
						-- When clicking on LAM default button
						db.soundforincwhisps = defaults.soundforincwhisps
					end
					
				end,
			},
			{-- -- LAM Option Whisper: Visual Notification
				type = "checkbox",
				name = GetString(RCHAT_NOTIFYIM),
				tooltip = GetString(RCHAT_NOTIFYIMTT),
				getFunc = function() return db.notifyIM end,
				setFunc = function(newValue) db.notifyIM = newValue end,
				width = "full",
				default = defaults.notifyIM,
			},
		},
	}-- LAM Menu Restore Chat
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_RESTORECHATH),
		controls = {
			{-- LAM Option Restore: After ReloadUI
				type = "checkbox",
				name = GetString(RCHAT_RESTOREONRELOADUI),
				tooltip = GetString(RCHAT_RESTOREONRELOADUITT),
				getFunc = function() return db.restoreOnReloadUI end,
				setFunc = function(newValue) db.restoreOnReloadUI = newValue end,
				width = "full",
				default = defaults.restoreOnReloadUI,
			},
			{-- LAM Option Restore: Logout
				type = "checkbox",
				name = GetString(RCHAT_RESTOREONLOGOUT),
				tooltip = GetString(RCHAT_RESTOREONLOGOUTTT),
				getFunc = function() return db.restoreOnLogOut end,
				setFunc = function(newValue) db.restoreOnLogOut = newValue end,
				width = "full",
				default = defaults.restoreOnLogOut,
			},
			{-- LAM Option Restore: Kicked
				type = "checkbox",
				name = GetString(RCHAT_RESTOREONAFK),
				tooltip = GetString(RCHAT_RESTOREONAFKTT),
				getFunc = function() return db.restoreOnAFK end,
				setFunc = function(newValue) db.restoreOnAFK = newValue end,
				width = "full",
				default = defaults.restoreOnAFK,
			},
			{-- LAM Option Restore: Hours  
				type = "slider",
				name = GetString(RCHAT_TIMEBEFORERESTORE),
				tooltip = GetString(RCHAT_TIMEBEFORERESTORETT),
				min = 1,
				max = 24,
				step = 1,
				getFunc = function() return db.timeBeforeRestore end,
				setFunc = function(newValue) db.timeBeforeRestore = newValue end,
				width = "full",
				default = defaults.timeBeforeRestore,
			},
			{-- LAM Option Restore: Leave
				type = "checkbox",
				name = GetString(RCHAT_RESTOREONQUIT),
				tooltip = GetString(RCHAT_RESTOREONQUITTT),
				getFunc = function() return db.restoreOnQuit end,
				setFunc = function(newValue) db.restoreOnQuit = newValue end,
				width = "full",
				default = defaults.restoreOnQuit,
			},
			{-- LAM Option Restore: System Messages
				type = "checkbox",
				name = GetString(RCHAT_RESTORESYSTEM),
				tooltip = GetString(RCHAT_RESTORESYSTEMTT),
				getFunc = function() return db.restoreSystem end,
				setFunc = function(newValue) db.restoreSystem = newValue end,
				width = "full",
				default = defaults.restoreSystem,
			},
			{-- LAM Option Restore: System Only Messages
				type = "checkbox",
				name = GetString(RCHAT_RESTORESYSTEMONLY),
				tooltip = GetString(RCHAT_RESTORESYSTEMONLYTT),
				getFunc = function() return db.restoreSystemOnly end,
				setFunc = function(newValue) db.restoreSystemOnly = newValue end,
				width = "full",
				default = defaults.restoreSystemOnly,
			},
			{-- LAM Option Restore: Whispers
				type = "checkbox",
				name = GetString(RCHAT_RESTOREWHISPS),
				tooltip = GetString(RCHAT_RESTOREWHISPSTT),
				getFunc = function() return db.restoreWhisps end,
				setFunc = function(newValue) db.restoreWhisps = newValue end,
				width = "full",
				default = defaults.restoreWhisps,
			},
			{-- LAM Option Restore: Text entry history
				type = "checkbox",
				name = GetString(RCHAT_RESTORETEXTENTRYHISTORYATLOGOUTQUIT),
				tooltip = GetString(RCHAT_RESTORETEXTENTRYHISTORYATLOGOUTQUITTT),
				getFunc = function() return db.restoreTextEntryHistoryAtLogOutQuit end,
				setFunc = function(newValue) db.restoreTextEntryHistoryAtLogOutQuit = newValue end,
				width = "full",
				default = defaults.restoreTextEntryHistoryAtLogOutQuit,
			},
		},
	} -- Anti-Spam   Timestamp options
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_ANTISPAMH),
		controls = {
			{-- flood protect
				type = "checkbox",
				name = GetString(RCHAT_FLOODPROTECT),
				tooltip = GetString(RCHAT_FLOODPROTECTTT),
				getFunc = function() return db.floodProtect end,
				setFunc = function(newValue) db.floodProtect = newValue end,
				width = "full",
				default = defaults.floodProtect,
			}, --Anti spam  grace period
			{
				type = "slider",
				name = GetString(RCHAT_FLOODGRACEPERIOD),
				tooltip = GetString(RCHAT_FLOODGRACEPERIODTT),
				min = 0,
				max = 180,
				step = 1,
				getFunc = function() return db.floodGracePeriod end,
				setFunc = function(newValue) db.floodGracePeriod = newValue end,
				width = "full",
				default = defaults.floodGracePeriod,
				disabled = function() return not db.floodProtect end,
			},
			{
				type = "checkbox",
				name = GetString(RCHAT_LOOKINGFORPROTECT),
				tooltip = GetString(RCHAT_LOOKINGFORPROTECTTT),
				getFunc = function() return db.lookingForProtect end,
				setFunc = function(newValue) db.lookingForProtect = newValue end,
				width = "full",
				default = defaults.lookingForProtect,
			},
			{
			type = "checkbox",
				name = GetString(RCHAT_WANTTOPROTECT),
				tooltip = GetString(RCHAT_WANTTOPROTECTTT),
				getFunc = function() return db.wantToProtect end,
				setFunc = function(newValue) db.wantToProtect = newValue end,
				width = "full",
				default = defaults.wantToProtect,
			},
			{	
				type = "slider",
				name = GetString(RCHAT_SPAMGRACEPERIOD),
				tooltip = GetString(RCHAT_SPAMGRACEPERIODTT),
				min = 0,
				max = 10,
				step = 1,
				getFunc = function() return db.spamGracePeriod end,
				setFunc = function(newValue) db.spamGracePeriod = newValue end,
				width = "full",
				default = defaults.spamGracePeriod,
			},
			{
				type = "editbox",
				name = GetString(RCHAT_NICKNAMES),
				tooltip = GetString(RCHAT_NICKNAMESTT),
				isMultiline = true,
				isExtraWide = true,
				getFunc = function() return db.nicknames end,
				setFunc = function(newValue)
					db.nicknames = newValue
					BuildNicknames(true) -- Rebuild the control if data is invalid
				end,
				width = "full",
				default = defaults.nicknames,
			},
		},
	} -- Timestamp options
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_TIMESTAMPH),
		controls = {
			{
				type = "checkbox",
				name = GetString(RCHAT_ENABLETIMESTAMP),
				tooltip = GetString(RCHAT_ENABLETIMESTAMPTT),
				getFunc = function() return db.showTimestamp end,
				setFunc = function(newValue) db.showTimestamp = newValue end,
				width = "full",
				default = defaults.showTimestamp,
			},
			{
				type = "checkbox",
				name = GetString(RCHAT_TIMESTAMPCOLORISLCOL),
				tooltip = GetString(RCHAT_TIMESTAMPCOLORISLCOLTT),
				getFunc = function() return db.timestampcolorislcol end,
				setFunc = function(newValue) db.timestampcolorislcol = newValue end,
				width = "full",
				default = defaults.timestampcolorislcol,
				disabled = function() return not db.showTimestamp end,
			},
			{	
				type = "editbox",
				name = GetString(RCHAT_TIMESTAMPFORMAT),
				tooltip = GetString(RCHAT_TIMESTAMPFORMATTT),
				getFunc = function() return db.timestampFormat end,
				setFunc = function(newValue) db.timestampFormat = newValue end,
				width = "full",
				default = defaults.timestampFormat,
				disabled = function() return not db.showTimestamp end,
			},
			{
				type = "colorpicker",
				name = GetString(RCHAT_TIMESTAMP),
				tooltip = GetString(RCHAT_TIMESTAMPTT),
				getFunc = function() return ConvertHexToRGBA(db.colours.timestamp) end,
				setFunc = function(r, g, b) db.colours.timestamp = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours.timestamp),
				disabled = function() return not db.showTimestamp end,
			},
		},
	}
		-- Addon Menu Other Colors
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_CHATCOLORSH),
		controls = {
			{-- Say players
				type = "colorpicker",
				name = GetString(RCHAT_SAY),
				tooltip = GetString(RCHAT_SAYTT),
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_SAY]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_SAY] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_SAY]),
				disabled = function() return db.useESOcolors end,
			},
			{--Say Chat Color
				type = "colorpicker",
				name = GetString(RCHAT_SAYCHAT),
				tooltip = GetString(RCHAT_SAYCHATTT),
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_SAY + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_SAY + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_SAY + 1]),
				disabled = function() return db.useESOcolors end,
			},
			{-- Zone Player
				type = "colorpicker",
				name = GetString(RCHAT_ZONE),
				tooltip = GetString(RCHAT_ZONETT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE]),
				disabled = function() return db.useESOcolors end,
			},
			{
				type = "colorpicker",
				name = GetString(RCHAT_ZONECHAT),
				tooltip = GetString(RCHAT_ZONECHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE + 1]),
				disabled = function() return db.useESOcolors end,
			},
			{-- Yell Player
				type = "colorpicker",
				name = GetString(RCHAT_YELL),
				tooltip = GetString(RCHAT_YELLTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_YELL]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_YELL] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_YELL]),
				disabled = function() return db.useESOcolors end,
			},
			{--Yell Chat
				type = "colorpicker",
				name = GetString(RCHAT_YELLCHAT),
				tooltip = GetString(RCHAT_YELLCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_YELL + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_YELL + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_YELL + 1]),
				disabled = function() return db.useESOcolors end,
			},	
			{--
				type = "colorpicker",
				name = GetString(RCHAT_INCOMINGWHISPERS),
				tooltip = GetString(RCHAT_INCOMINGWHISPERSTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_WHISPER]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_WHISPER] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_WHISPER]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_INCOMINGWHISPERSCHAT),
				tooltip = GetString(RCHAT_INCOMINGWHISPERSCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_WHISPER + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_WHISPER + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_WHISPER + 1]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_OUTGOINGWHISPERS),
				tooltip = GetString(RCHAT_OUTGOINGWHISPERSTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_WHISPER_SENT]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_WHISPER_SENT] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_WHISPER_SENT]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_OUTGOINGWHISPERSCHAT),
				tooltip = GetString(RCHAT_OUTGOINGWHISPERSCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_WHISPER_SENT + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_WHISPER_SENT + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_WHISPER_SENT + 1]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_GROUP),
				tooltip = GetString(RCHAT_GROUPTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_PARTY]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_PARTY] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_PARTY]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_GROURCHAT),
				tooltip = GetString(RCHAT_GROURCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_PARTY + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_PARTY + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_PARTY + 1]),
				disabled = function() return db.useESOcolors end,
			},
		},
	}--Other Colors
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = GetString(RCHAT_OTHERCOLORSH),
		controls = {
			{
				type = "colorpicker",
				name = GetString(RCHAT_EMOTES),
				tooltip = GetString(RCHAT_EMOTESTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_EMOTE]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_EMOTE] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_EMOTE]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_EMOTESCHAT),
				tooltip = GetString(RCHAT_EMOTESCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_EMOTE + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_EMOTE + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_EMOTE + 1]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_NPCSAY),
				tooltip = GetString(RCHAT_NPCSAYTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_SAY]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_SAY] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_SAY]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_NPCSAYCHAT),
				tooltip = GetString(RCHAT_NPCSAYCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_SAY + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_SAY + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_SAY + 1]),
				disabled = function() return db.useESOcolors end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_NPCYELL),
				tooltip = GetString(RCHAT_NPCYELLTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_YELL]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_YELL] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_YELL]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allNPCSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_NPCYELLCHAT),
				tooltip = GetString(RCHAT_NPCYELLCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_YELL + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_YELL + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_YELL + 1]),
				disabled = function()
							if db.useESOcolors then
								return true
							else
								return db.allNPCSameColour
							end
							end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_NPCWHISPER),
				tooltip = GetString(RCHAT_NPCWHISPERTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_WHISPER]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_WHISPER] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_WHISPER]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allNPCSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_NPCWHISPERCHAT),
				tooltip = GetString(RCHAT_NPCWHISPERCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_WHISPER + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_WHISPER + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_WHISPER + 1]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allNPCSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_NPCEMOTES),
				tooltip = GetString(RCHAT_NPCEMOTESTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_EMOTE]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_EMOTE] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_EMOTE]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allNPCSameColour
					end
				end,
			},
			{--	
				type = "colorpicker",
				name = GetString(RCHAT_NPCEMOTESCHAT),
				tooltip = GetString(RCHAT_NPCEMOTESCHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_MONSTER_EMOTE + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_MONSTER_EMOTE + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_MONSTER_EMOTE + 1]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allNPCSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_ENZONE),
				tooltip = GetString(RCHAT_ENZONETT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_1]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_ENZONECHAT),
				tooltip = GetString(RCHAT_ENZONECHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_1 + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_1 + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_1 + 1]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_FRZONE),
				tooltip = GetString(RCHAT_FRZONETT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_2]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_2] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_2]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_FRZONECHAT),
				tooltip = GetString(RCHAT_FRZONECHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_2 + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_2 + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_2 + 1]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_DEZONE),
				tooltip = GetString(RCHAT_DEZONETT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_3]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_3] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_3]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_DEZONECHAT),
				tooltip = GetString(RCHAT_DEZONECHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_3 + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_3 + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_3 + 1]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_JPZONE),
				tooltip = GetString(RCHAT_JPZONETT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_4]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_4] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_4]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
			{--
				type = "colorpicker",
				name = GetString(RCHAT_JPZONECHAT),
				tooltip = GetString(RCHAT_JPZONECHATTT), 
				getFunc = function() return ConvertHexToRGBA(db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_4 + 1]) end,
				setFunc = function(r, g, b) db.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_4 + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*CHAT_CHANNEL_ZONE_LANGUAGE_4 + 1]),
				disabled = function()
					if db.useESOcolors then
						return true
					else
						return db.allZonesSameColour
					end
				end,
			},
		},
	}
-- Guilds
	
--  Guild Stuff
--
	for guild = 1, GetNumGuilds() do
		
		-- Guildname
		local guildId = GetGuildId(guild)
		local guildName = GetGuildName(guildId)
		
		-- Occurs sometimes
		if(not guildName or (guildName):len() < 1) then
			guildName = "Guild " .. guildId
		end
		
		-- If recently added to a new guild and never go in menu db.formatguild[guildName] won't exist
		if not (db.formatguild[guildName]) then
			-- 2 is default value
			db.formatguild[guildName] = 2
		end
		optionsData[#optionsData + 1] = {
		type = "submenu",
		name = guildName,
		controls = {
			{
				type = "editbox",
				name = GetString(RCHAT_NICKNAMEFOR),
				tooltip = GetString(RCHAT_NICKNAMEFORTT) .. " " .. guildName,
				getFunc = function() return db.guildTags[guildName] end,
				setFunc = function(newValue)
					db.guildTags[guildName] = newValue
					UpdateCharCorrespondanceTableChannelNames()
				end,
				width = "full",
				default = "",
			},
			{
				type = "editbox",
				name = GetString(RCHAT_OFFICERTAG),
				tooltip = GetString(RCHAT_OFFICERTAGTT),
				width = "full",
				default = "",
				getFunc = function() return db.officertag[guildName] end,
				setFunc = function(newValue)
					db.officertag[guildName] = newValue
					UpdateCharCorrespondanceTableChannelNames()
				end
			},
			{
				type = "editbox",
				name = GetString(RCHAT_SWITCHFOR),
				tooltip = GetString(RCHAT_SWITCHFORTT),
				getFunc = function() return db.switchFor[guildName] end,
				setFunc = function(newValue)
					db.switchFor[guildName] = newValue
					UpdateCharCorrespondanceTableSwitchs()
					CHAT_SYSTEM:CreateChannelData()
				end,
				width = "full",
				default = "",
			},
			{
				type = "editbox",
				name = GetString(RCHAT_OFFICERSWITCHFOR),
				tooltip = GetString(RCHAT_OFFICERSWITCHFORTT),
				width = "full",
				default = "",
				getFunc = function() return db.officerSwitchFor[guildName] end,
				setFunc = function(newValue)
					db.officerSwitchFor[guildName] = newValue
					UpdateCharCorrespondanceTableSwitchs()
					CHAT_SYSTEM:CreateChannelData()
				end
			},
		-- Config store 1/2/3 to avoid language switchs
		-- TODO : Optimize
			{
				type = "dropdown",
				name = GetString(RCHAT_NAMEFORMAT),
				tooltip = GetString(RCHAT_NAMEFORMATTT),
				choices = {GetString(RCHAT_FORMATCHOICE1), GetString(RCHAT_FORMATCHOICE2), GetString(RCHAT_FORMATCHOICE3)},
				getFunc = function()
					-- Config per guild
					if db.formatguild[guildName] == 1 then
						return GetString(RCHAT_FORMATCHOICE1)
					elseif db.formatguild[guildName] == 2 then
						return GetString(RCHAT_FORMATCHOICE2)
					elseif db.formatguild[guildName] == 3 then
						return GetString(RCHAT_FORMATCHOICE3)
					else
						-- When user click on LAM reinit button
						return GetString(RCHAT_FORMATCHOICE2)
					end
				end,
				setFunc = function(choice)
					if choice == GetString(RCHAT_FORMATCHOICE1) then
						db.formatguild[guildName] = 1
					elseif choice == GetString(RCHAT_FORMATCHOICE2) then
						db.formatguild[guildName] = 2
					elseif choice == GetString(RCHAT_FORMATCHOICE3) then
						db.formatguild[guildName] = 3
					else
						-- When user click on LAM reinit button
						db.formatguild[guildName] = 2
					end				
				end,
				width = "full",
				default = defaults.formatguild[0],
			},
			{
				type = "colorpicker",
				name = zo_strformat(RCHAT_MEMBERS, guildName),
				tooltip = zo_strformat(RCHAT_SETCOLORSFORTT, guildName),
				getFunc = function() return ConvertHexToRGBA(db.colours[2*(CHAT_CHANNEL_GUILD_1 + guild - 1)]) end,
				setFunc = function(r, g, b) db.colours[2*(CHAT_CHANNEL_GUILD_1 + guild - 1)] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*(CHAT_CHANNEL_GUILD_1 + guild - 1)]),
				disabled = function() return db.useESOcolors end,
			},
			{
				type = "colorpicker",
				name = zo_strformat(RCHAT_CHAT, guildName),
				tooltip = zo_strformat(RCHAT_SETCOLORSFORCHATTT, guildName),
				getFunc = function() return ConvertHexToRGBA(db.colours[2*(CHAT_CHANNEL_GUILD_1 + guild - 1) + 1]) end,
				setFunc = function(r, g, b) db.colours[2*(CHAT_CHANNEL_GUILD_1 + guild - 1) + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*(CHAT_CHANNEL_GUILD_1 + guild - 1) + 1]),
				disabled = function() return db.useESOcolors end,	
			},
			{
				type = "colorpicker",
				name = guildName .. GetString(RCHAT_OFFICERSTT) .. GetString(RCHAT_MEMBERS),
				tooltip = zo_strformat(RCHAT_SETCOLORSFOROFFICIERSTT, guildName),
				getFunc = function() return ConvertHexToRGBA(db.colours[2*(CHAT_CHANNEL_OFFICER_1 + guild - 1)]) end,
				setFunc = function(r, g, b) db.colours[2*(CHAT_CHANNEL_OFFICER_1 + guild - 1)] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*(CHAT_CHANNEL_OFFICER_1 + guild - 1)]),
				disabled = function() return db.useESOcolors end,
			},
			{
				type = "colorpicker",
				name = guildName .. GetString(RCHAT_OFFICERSTT) .. GetString(RCHAT_CHAT),
				tooltip = zo_strformat(RCHAT_SETCOLORSFOROFFICIERSCHATTT, guildName),
				getFunc = function() return ConvertHexToRGBA(db.colours[2*(CHAT_CHANNEL_OFFICER_1 + guild - 1) + 1]) end,
				setFunc = function(r, g, b) db.colours[2*(CHAT_CHANNEL_OFFICER_1 + guild - 1) + 1] = ConvertRGBToHex(r, g, b) end,
				default = ConvertHexToRGBAPacked(defaults.colours[2*(CHAT_CHANNEL_OFFICER_1 + guild - 1) + 1]),
				disabled = function() return db.useESOcolors end,
			},
		},
	}
	end
	

	
	
	--[[
	index = index + 1
	optionsTable[index] = {
			type = "header",
			name = GetString(RCHAT_DEBUGH),
			width = "full",
	}
	
	index = index + 1
	optionsTable[index] = {
			type = "checkbox",
			name = GetString(RCHAT_DEBUG),
			tooltip = GetString(RCHAT_DEBUGTT),
			getFunc = function() return db.debug end,
			setFunc = function(newValue) db.debug = newValue end,
			width = "full",
			default = defaults.debug,
	},
	]]--
	
	LAM:RegisterOptionControls("rChatOptions", optionsData)
	
end

-- Initialises the settings and settings menu
local function GetDBAndBuildLAM()
	
	db = ZO_SavedVars:NewAccountWide(rChat.savedvar, rChat.sv_version, nil, defaults)
	
	local panelData = {
		type = "panel",
		name = ADDON_NAME,
		displayName = ZO_HIGHLIGHT_TEXT:Colorize("rChat"),
		author = ADDON_AUTHOR,
		version = ADDON_VERSION,
		slashCommand = "/rchat",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	rChatData.LAMPanel = LAM:RegisterAddonPanel("rChatOptions", panelData)

	-- Build OptionTable. In a separate func in order to rebuild it in case of Guild Reorg.
	SyncCharacterSelectChoices()
	BuildLAMPanel()
	
end
--**Settings End
-- Triggered by EVENT_GUILD_SELF_JOINED_GUILD
local function OnSelfJoinedGuild(_, _, guildName)

	-- It will rebuild optionsTable and recreate tables if user didn't went in this section before
	BuildLAMPanel()
	
	-- If recently added to a new guild and never go in menu db.formatguild[guildName] won't exist, it won't create the value if joining an known guild
	if not db.formatguild[guildName] then
		-- 2 is default value
		db.formatguild[guildName] = 2
	end
	
	-- Save Guild indexes for guild reorganization
	SaveGuildIndexes()
	
end

-- Revert category settings
local function RevertCategories(guildName)

	-- Old GuildId
	local oldIndex = rChatData.guildIndexes[guildName]
	-- old Total Guilds
	local totGuilds = GetNumGuilds() + 1
	
	if oldIndex and oldIndex < totGuilds then
	
		-- If our guild was not the last one, need to revert colors
		--d("rChat will revert starting from " .. oldIndex .. " to " .. totGuilds)
		
		-- Does not need to reset chat settings for first guild if the 2nd has been left, same for 1-2/3 and 1-2-3/4
		for iGuilds=oldIndex, (totGuilds - 1) do
			
			-- If default channel was g1, keep it g1
			if not (db.defaultchannel == CHAT_CATEGORY_GUILD_1 or db.defaultchannel == CHAT_CATEGORY_OFFICER_1) then
				
				if db.defaultchannel == (CHAT_CATEGORY_GUILD_1 + iGuilds) then
					db.defaultchannel = (CHAT_CATEGORY_GUILD_1 + iGuilds - 1)
				elseif db.defaultchannel == (CHAT_CATEGORY_OFFICER_1 + iGuilds) then
					db.defaultchannel = (CHAT_CATEGORY_OFFICER_1 + iGuilds - 1)
				end
				
			end
			
			-- New Guild color for Guild #X is the old #X+1
			SetChatCategoryColor(CHAT_CATEGORY_GUILD_1 + iGuilds - 1, db.chatConfSync[rChatData.localPlayer].colors[CHAT_CATEGORY_GUILD_1 + iGuilds].red, db.chatConfSync[rChatData.localPlayer].colors[CHAT_CATEGORY_GUILD_1 + iGuilds].green, db.chatConfSync[rChatData.localPlayer].colors[CHAT_CATEGORY_GUILD_1 + iGuilds].blue) 
			-- New Officer color for Guild #X is the old #X+1
			SetChatCategoryColor(CHAT_CATEGORY_OFFICER_1 + iGuilds - 1, db.chatConfSync[rChatData.localPlayer].colors[CHAT_CATEGORY_OFFICER_1 + iGuilds].red, db.chatConfSync[rChatData.localPlayer].colors[CHAT_CATEGORY_OFFICER_1 + iGuilds].green, db.chatConfSync[rChatData.localPlayer].colors[CHAT_CATEGORY_OFFICER_1 + iGuilds].blue)
			
			-- Restore tab config previously set.
			for numTab in ipairs (CHAT_SYSTEM.primaryContainer.windows) do
				if db.chatConfSync[rChatData.localPlayer].tabs[numTab] then
					SetChatContainerTabCategoryEnabled(1, numTab, (CHAT_CATEGORY_GUILD_1 + iGuilds - 1), db.chatConfSync[rChatData.localPlayer].tabs[numTab].enabledCategories[CHAT_CATEGORY_GUILD_1 + iGuilds])
					SetChatContainerTabCategoryEnabled(1, numTab, (CHAT_CATEGORY_OFFICER_1 + iGuilds - 1), db.chatConfSync[rChatData.localPlayer].tabs[numTab].enabledCategories[CHAT_CATEGORY_OFFICER_1 + iGuilds])
				end
			end
			
		end
	end
	
end

-- Registers the formatMessage function with the libChat to handle chat formatting.
-- Unregisters itself from the player activation event with the event manager.
local function OnPlayerActivated()
	
	rChatData.sceneFirst = false
	
	if isAddonLoaded then
		
		rChatData.activeTab = 1
		
		
		ZO_PreHook(CHAT_SYSTEM, "ValidateChatChannel", function(self)
                if (db.enableChatTabChannel  == true) and (self.currentChannel ~= CHAT_CHANNEL_WHISPER) then
                    local tabIndex = self.primaryContainer.currentBuffer:GetParent().tab.index
                    db.chatTabChannel[tabIndex] = db.chatTabChannel[tabIndex] or {}
                    db.chatTabChannel[tabIndex].channel = self.currentChannel
                    db.chatTabChannel[tabIndex].target  = self.currentTarget
                end
            end)
		
		ZO_PreHook(CHAT_SYSTEM.primaryContainer, "HandleTabClick", function(self, tab) 
                rChatData.activeTab = tab.index
                if (db.enableChatTabChannel == true) then
                    local tabIndex = tab.index
                    if db.chatTabChannel[tabIndex] then
                        CHAT_SYSTEM:SetChannel(db.chatTabChannel[tabIndex].channel, db.chatTabChannel[tabIndex].target)
                    end
                end
                --ZO_TabButton_Text_RestoreDefaultColors(tab)
            end)

		
		-- Visual Notification PreHook
		ZO_PreHook(CHAT_SYSTEM, "Maximize", function(self) 
			CHAT_SYSTEM.IMLabelMin:SetHidden(true)			
		end)
		
		--local fontPath = ZoFontChat:GetFontInfo()
		--CHAT_SYSTEM:AddMessage(fontPath)
		--CHAT_SYSTEM:AddMessage("|C3AF24BLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.|r")
		--CHAT_SYSTEM:AddMessage("Characters below should be well displayed :")
		--CHAT_SYSTEM:AddMessage("!\"#$%&'()*+,-./0123456789:;<=>?@ ABCDEFGHIJKLMNOPQRSTUVWXYZ [\]^_`abcdefghijklmnopqrstuvwxyz{|} ~¡£¤¥¦§©«-®°²³´µ¶·»½¿ ÀÁÂÄÆÇÈÉÊËÌÍÎÏÑÒÓÔÖ×ÙÚÛÜßàáâäæçèéêëìíîïñòóôöùúûüÿŸŒœ")
		
		-- AntiSpam
		rChatData.spamLookingForEnabled = true
		rChatData.spamWantToEnabled = true
		rChatData.spamGuildRecruitEnabled = true
		
		-- Show 1000 lines instead of 200 & Change fade delay
		ShowFadedLines()
		-- Get Chat Tab Namse stored in chatTabNames {}
		getTabNames()
		-- Rebuild Lam Panel
		BuildLAMPanel()
		-- 
		CreateNewChatTabPostHook()
		
		-- Should we minimize ?
		MinimizeChatAtLaunch()
		
		-- Message for new chars
		AutoSyncSettingsForNewPlayer()
		
		-- Chat Config synchronization
		SyncChatConfig(db.chatSyncConfig, "lastChar")
		SaveChatConfig()
		
		-- Tags next to entry box
		UpdateCharCorrespondanceTableChannelNames()
		
		-- Update Swtches
		UpdateCharCorrespondanceTableSwitchs()
		CHAT_SYSTEM:CreateChannelData()
		
		-- Set default channel at login
		SetToDefaultChannel()
		
		-- Save all category colors
		SaveGuildIndexes()
		
		-- Handle Copy text
		CopyToTextEntryText()
		
		-- Restore History if needed
		RestoreChatHistory()
		-- Default Tab
		SetDefaultTab(db.defaultTab)
		-- Change Window apparence
		ChangeChatWindowDarkness()
		
		-- libChat
		-- registerFormat = message for EVENT_CHAT_MESSAGE_CHANNEL
		-- registerFriendStatus = message for EVENT_FRIEND_PLAYER_STATUS_CHANGED
		-- registerIgnoreAdd = message for EVENT_IGNORE_ADDED, registerIgnoreRemove = message for EVENT_IGNORE_REMOVED
		-- registerGroupTypeChanged = message for EVENT_GROUP_TYPE_CHANGED
		-- All those events outputs to the ChatSystem
		RCHATLC:registerFormat(FormatMessage, ADDON_NAME)
		
		if not RCHATLC.manager.registerFriendStatus then
			RCHATLC:registerFriendStatus(OnFriendPlayerStatusChanged, ADDON_NAME)
		end
		
		RCHATLC:registerIgnoreAdd(OnIgnoreAdded, ADDON_NAME)
		RCHATLC:registerIgnoreRemove(OnIgnoreRemoved, ADDON_NAME)
		RCHATLC:registerGroupMemberLeft(OnGroupMemberLeft, ADDON_NAME)
		RCHATLC:registerGroupTypeChanged(OnGroupTypeChanged, ADDON_NAME)
		
		isAddonInitialized = true
		
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED)
		
	end
	
end


-- Runs whenever "me" left a guild (or get kicked)
local function OnSelfLeftGuild(_, _, guildName)

	-- It will rebuild optionsTable and recreate tables if user didn't went in this section before
	BuildLAMPanel()
	
	-- Revert category colors & options
	RevertCategories(guildName)
	
end

local function SwitchToParty(characterName)
	
	zo_callLater(function(characterName) -- characterName = avoid ZOS bug
		-- If "me" join group
		if(GetRawUnitName("player") == characterName) then
		
			-- Switch to party channel when joinin a group
			if db.enablepartyswitch then
				CHAT_SYSTEM:SetChannel(CHAT_CHANNEL_PARTY)
			end
			
		else
			
			-- Someone else joined group
			-- If GetGroupSize() == 2 : Means "me" just created a group and "someone" just joining
			 if GetGroupSize() == 2 then
				-- Switch to party channel when joinin a group
				if db.enablepartyswitch then
					CHAT_SYSTEM:SetChannel(CHAT_CHANNEL_PARTY)
				end
			 end
			 
		end
	end, 200)
	
end

-- Triggers when EVENT_GROUP_MEMBER_JOINED
local function OnGroupMemberJoined(_, characterName)
	SwitchToParty(characterName)
end

-- triggers when EVENT_GROUP_MEMBER_LEFT
local function OnGroupMemberLeft(_, characterName, reason, wasMeWhoLeft)
	
	-- Go back to default channel
	if GetGroupSize() <= 1 then
		-- Go back to default channel when leaving a group
		if db.enablepartyswitch then
			-- Only if we was on party
			if CHAT_SYSTEM.currentChannel == CHAT_CHANNEL_PARTY and db.defaultchannel ~= RCHAT_CHANNEL_NONE then
				SetToDefaultChannel()
			end
		end
	end
	
end

-- Save a category color for guild chat, set by ChatSystem at launch + when user change manually
local function SaveChatCategoriesColors(category, r, g, b)
	if db.chatConfSync[rChatData.localPlayer] then
		if db.chatConfSync[rChatData.localPlayer].colors[category] == nil then
			db.chatConfSync[rChatData.localPlayer].colors[category] = {}
		end
		db.chatConfSync[rChatData.localPlayer].colors[category] = { red = r, green = g, blue = b }
	end
end

-- PreHook of ZO_ChatSystem_ShowOptions() and ZO_ChatWindow_OpenContextMenu(control.index)
local function ChatSystemShowOptions(tabIndex)
	local self = CHAT_SYSTEM.primaryContainer
	tabIndex = tabIndex or (self.currentBuffer and self.currentBuffer:GetParent() and self.currentBuffer:GetParent().tab and self.currentBuffer:GetParent().tab.index)
	local window = self.windows[tabIndex]
	if window then
		ClearMenu()

		if not ZO_Dialogs_IsShowingDialog() then
			AddMenuItem(GetString(SI_CHAT_CONFIG_CREATE_NEW), function() self.system:CreateNewChatTab(self) end)
		end

		if not ZO_Dialogs_IsShowingDialog() and not window.combatLog and (not self:IsPrimary() or tabIndex ~= 1) then
			AddMenuItem(GetString(SI_CHAT_CONFIG_REMOVE), function() self:ShowRemoveTabDialog(tabIndex) end)
		end

		if not ZO_Dialogs_IsShowingDialog() then
			AddMenuItem(GetString(SI_CHAT_CONFIG_OPTIONS), function() self:ShowOptions(tabIndex) end)
		end
		
		if not ZO_Dialogs_IsShowingDialog() then
			AddMenuItem(GetString(RCHAT_CLEARBUFFER), function()
				rChatData.tabNotBefore[tabIndex] = GetTimeStamp()
				self.windows[tabIndex].buffer:Clear()
				self:SyncScrollToBuffer()
			end)
		end

		if self:IsPrimary() and tabIndex == 1 then
			if self:IsLocked(tabIndex) then
				AddMenuItem(GetString(SI_CHAT_CONFIG_UNLOCK), function() self:SetLocked(tabIndex, false) end)
			else
				AddMenuItem(GetString(SI_CHAT_CONFIG_LOCK), function() self:SetLocked(tabIndex, true) end)
			end
		end

		if window.combatLog then
			if self:AreTimestampsEnabled(tabIndex) then
				AddMenuItem(GetString(SI_CHAT_CONFIG_HIDE_TIMESTAMP), function() self:SetTimestampsEnabled(tabIndex, false) end)
			else
				AddMenuItem(GetString(SI_CHAT_CONFIG_SHOW_TIMESTAMP), function() self:SetTimestampsEnabled(tabIndex, true) end)
			end
		end
		
		--[[
		if db.chatConfSync[GetUnitName("player")].textEntryDocked then
			AddMenuItem(GetString(RCHAT_UNDOCKTEXTENTRY), function() UndockTextEntry() end)
		else
			AddMenuItem(GetString(RCHAT_REDOCKTEXTENTRY), function() RedockTextEntry() end)
		end
		]]
		
		ShowMenu(window.tab)
	end
	
	return true
	
end

-- Please note that some things are delayed in OnPlayerActivated() because Chat isn't ready when this function triggers
local function OnAddonLoaded(_, addonName)

	--Protect
	if addonName == ADDON_NAME then
		
		-- Char name
		rChatData.localPlayer = GetUnitName("player")
		
		--LAM and db for saved vars
		GetDBAndBuildLAM()
		
		-- Used for CopySystem
		
		if not db.lineNumber then
			db.lineNumber = 1
		elseif type(db.lineNumber) ~= "number" then
			db.lineNumber = 1
			db.LineStrings = {}
		elseif db.lineNumber > 5000 then
			StripLinesFromLineStrings(0)
		end
		
		if not db.chatTabChannel then
			db.chatTabChannel = {}
		end
		
		if not db.LineStrings then
			db.LineStrings = {}
		end
		
		if not tabNames then
			tabNames = {}
		end
		
		-- Will set Keybind for "switch to next tab" if needed
		SetSwitchToNextBinding()
		
		-- Will change font if needed
		ChangeChatFont()
		
		-- Automated messages
		InitAutomatedMessages()
		
		-- Resize, must be loaded before CHAT_SYSTEM is set
		CHAT_SYSTEM.maxContainerWidth, CHAT_SYSTEM.maxContainerHeight = GuiRoot:GetDimensions()
		
		-- Minimize Chat in Menus
		MinimizeChatInMenus()
		
		BuildNicknames()
		
		InitializeURLHandling()
		
		-- PreHook ReloadUI, SetCVar, LogOut & Quit to handle Chat Import/Export
		ZO_PreHook("ReloadUI", function() 
			SaveChatHistory(1)
			SaveChatConfig()
		end)
		
		ZO_PreHook("SetCVar", function() 
			SaveChatHistory(1)
			SaveChatConfig()
		end)
		
		ZO_PreHook("Logout", function()
			SaveChatHistory(2)
			SaveChatConfig()
		end)
		
		ZO_PreHook("Quit", function()
			SaveChatHistory(3)
			SaveChatConfig()
		end)
		
		-- Social option change color
		ZO_PreHook("SetChatCategoryColor", SaveChatCategoriesColors)
		-- Chat option change categories filters, add a callLater because settings are set after this function triggers.
		ZO_PreHook("ZO_ChatOptions_ToggleChannel", function() zo_callLater(SaveTabsCategories, 100) end)
		
		-- Right click on a tab name
		ZO_PreHook("ZO_ChatSystem_ShowOptions", function(control) return ChatSystemShowOptions() end)
		ZO_PreHook("ZO_ChatWindow_OpenContextMenu", function(control) return ChatSystemShowOptions(control.index) end)
		-- Bindings
		ZO_CreateStringId("SI_BINDING_NAME_RCHAT_TOGGLE_CHAT_WINDOW", GetString(RCHAT_TOGGLECHATBINDING))
		ZO_CreateStringId("SI_BINDING_NAME_RCHAT_WHISPER_MY_TARGET", GetString(RCHAT_WHISPMYTARGETBINDING))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_1", GetString(RCHAT_Tab1))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_2", GetString(RCHAT_Tab2))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_3", GetString(RCHAT_Tab3))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_4", GetString(RCHAT_Tab4))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_5", GetString(RCHAT_Tab5))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_6", GetString(RCHAT_Tab6))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_7", GetString(RCHAT_Tab7))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_8", GetString(RCHAT_Tab8))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_9", GetString(RCHAT_Tab9))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_10", GetString(RCHAT_Tab10))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_11", GetString(RCHAT_Tab11))
		ZO_CreateStringId("SI_BINDING_NAME_TAB_12", GetString(RCHAT_Tab12))
		-- Register OnSelfJoinedGuild with EVENT_GUILD_SELF_JOINED_GUILD
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GUILD_SELF_JOINED_GUILD, OnSelfJoinedGuild)

		-- Register OnSelfLeftGuild with EVENT_GUILD_SELF_LEFT_GUILD
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GUILD_SELF_LEFT_GUILD, OnSelfLeftGuild)
		
		-- Because ChatSystem is loaded after EVENT_ADDON_LOADED triggers, we use 1st EVENT_PLAYER_ACTIVATED wich is run bit after
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
		
		-- Whisp my target
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED, OnReticleTargetChanged)
		
		-- Party switches
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GROUP_MEMBER_JOINED, OnGroupMemberJoined)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GROUP_MEMBER_LEFT, OnGroupMemberLeft)
		
		-- Unregisters
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
		
		isAddonLoaded = true
		
	end
	
end

--Handled by keybind
function rChat_ToggleChat()
	
	if CHAT_SYSTEM:IsMinimized() then
		CHAT_SYSTEM:Maximize()
	else
		CHAT_SYSTEM:Minimize()
	end
	
end

-- Called by bindings
function rChat_WhispMyTarget()
	if targetToWhisp then
		CHAT_SYSTEM:StartTextEntry(nil, CHAT_CHANNEL_WHISPER, targetToWhisp)
	end
end

-- For compatibility. Called by others addons.
function rChat.formatSysMessage(statusMessage)
	return FormatSysMessage(statusMessage)
end

-- For compatibility. Called by others addons.
function rChat_FormatSysMessage(statusMessage)
	return FormatSysMessage(statusMessage)
end

-- For compatibility. Called by others addons.
function rChat_GetChannelColors(channel, from)
	return GetChannelColors(channel, from)
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)