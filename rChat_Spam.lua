rChat = rChat or {}

local SF = LibSFUtils

-- These require access to rChat.save and rChat.data (local vars in rChat.lua that have
-- been stuffed in rChat table so that we can get to them from here.
-- Readdress this properly.

local spammableChannels = {}
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_1 + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_2 + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_3 + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_4 + 1] = true
spammableChannels[CHAT_CHANNEL_SAY + 1] = true
spammableChannels[CHAT_CHANNEL_YELL + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE + 1] = true
spammableChannels[CHAT_CHANNEL_EMOTE + 1] = true

local function IsSpammableChannel(chanCode)
    if chanCode == nil then return nil end
    return spammableChannels[chanCode + 1]
end

-- Return true/false if text is a flood
local function SpamFlood(from, text, chanCode)
    local db = rChat.save

	-- 2+ messages identical in less than 30 seconds on Character channels = spam
		
	-- Should not happen
	if db.LineStrings == nil then return false end
	if db.lineNumber == nil or db.lineNumber == 1 then return false end   -- 1st message cannot be a spam
		
    
    local previousLine = db.lineNumber - 1
    local ourMessageTimestamp = GetTimeStamp()
    
    local checkSpam = true
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
                        
                        -- spammableChannels[spamChanCode] = true if our message was sent in a spammable channel
                        -- spammableChannels[db.LineStrings[previousLine].channel] = return true if previous message was sent in a spammable channel
                        
                        if IsSpammableChannel(spamChanCode) and IsSpammableChannel(db.LineStrings[previousLine].channel) then
                            -- Spam
                            --CHAT_SYSTEM:Zo_AddMessage("Spam detected ( " .. text ..  " )")
                            return true
                        end
                    end
                end
            else
                -- > 30s, stop analysis
                checkSpam = false
            end
        end
        
        if previousLine > 1 then
            previousLine = previousLine - 1
        else
            checkSpam = false
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
			CHAT_SYSTEM:Zo_AddMessage("spamLookingFor:" .. text .." ;spamString=" .. spamString)
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
			CHAT_SYSTEM:Zo_AddMessage("WT detected ( " .. text .. " )")
			return true
            
        -- Werewolf Bite
		elseif string.find(text, "[Ww][Ww][%s]+[Bb][Ii][Tt][Ee]") then
			-- Match
			CHAT_SYSTEM:Zo_AddMessage("WT WW Bite detected ( " .. text .. " )")
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
	
	local spamStrings = {
		["[Ll]ooking [Ff]or ([Nn]ew+) [Mm]embers"] = 5, -- looking for (new) members
		["%d%d%d\+"] = 5, -- 398+
		["%d%d%d\/500"] = 5, -- 398/500
		["gilde"] = 1, -- 398/500
		["[Gg]uild"] = 1, -- 398/500
		["[Tt][Ee][Aa][Mm][Ss][Pp][Ee][Aa][Kk]"] = 1,
		["[Dd][Ii][Ss][Cc][Oo][Rr][Dd]"] = 1,
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
	
	if IsSpammableChannel(spamChanCode) then
        CHAT_SYSTEM:Zo_AddMessage("Guild Recruiting analysis: <"..text..">")
		
		local textLen = string.len(text)
        
		-- 30 chars are needed to make a phrase of guild recruitment. If recruiter spam in SMS, rChat won't handle it.

        if textLen <= 30 then return end
        
        -- Each message can possibly be a spam, let's write our checklist
        CHAT_SYSTEM:Zo_AddMessage("GR Len ( " .. textLen .. " )")
        
        if textLen > 300 then
            guildHeuristics = 50
        elseif textLen > 250 then
            guildHeuristics = 40
        elseif textLen > 200 then
            guildHeuristics = 30
        elseif textLen > 150 then
            guildHeuristics = 20
        elseif textLen > 100 then
            guildHeuristics = 10
        end
        
        -- Still to do
        for spamString, value in ipairs(spamStrings) do
            if string.find(text, spamString) then
                CHAT_SYSTEM:Zo_AddMessage(spamString)
                guildHeuristics = guildHeuristics + value
            end
        end
        
        if guildHeuristics > 60 then
            CHAT_SYSTEM:Zo_AddMessage("GR : true (score=" .. guildHeuristics .. ")")
            return true
        end
    
        CHAT_SYSTEM:Zo_AddMessage("GR : false (score=" .. guildHeuristics .. ")")
	
	end
	
	return false
	
end

-- Return true/false if anti spam is enabled for a certain category
-- Categories must be : Flood, LookingFor, WantTo, GuildRecruit
local function IsSpamEnabledForCategory(category)
    local db = rChat.save
    local rChatData = rChat.data
	
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
			
				CHAT_SYSTEM:Zo_AddMessage("lookingForProtect is temporary disabled since " .. rChat.spamTempLookingForStopTimestamp)
				
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
		
		CHAT_SYSTEM:Zo_AddMessage("wantToProtect disabled")
		-- AntiSpam is disabled
		return false
	
	-- Join my Awesome guild
	elseif category == "GuildRecruit" then
		-- Enabled in Options?
		if db.guildProtect then
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
function rChat.SpamFilter(chanCode, from, text, isCS)
    local rChatData = rChat.data

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
		if SpamFlood(from, text, chanCode) then 
            CHAT_SYSTEM:Zo_AddMessage("Blocked flood msg")
            return true end
	end
	
	-- But "I" can have exceptions
	if zo_strformat(SI_UNIT_NAME, from) == rChatData.localPlayer or from == GetDisplayName() then
	
		CHAT_SYSTEM:Zo_AddMessage("I saw something ( " .. text .. " )")
		
		if IsSpamEnabledForCategory("LookingFor") then
			-- "I" can look for a group
			if SpamLookingFor(text) then
				
				CHAT_SYSTEM:Zo_AddMessage("I saw a LF Message ( " .. text .. " )")
				
				-- If I break myself the rule, disable it few minutes
				rChatData.spamTempLookingForStopTimestamp = GetTimeStamp()
				rChatData.spamLookingForEnabled = false
				
			end
		end
		
		if IsSpamEnabledForCategory("WantTo") then
			-- "I" can be a trader
			if SpamWantTo(text) then
				
				CHAT_SYSTEM:Zo_AddMessage("I saw a WT Message ( " .. text .. " )")
				
				-- If I break myself the rule, disable it few minutes
				rChatData.spamTempWantToStopTimestamp = GetTimeStamp()
				rChatData.spamWantToStop = true
                CHAT_SYSTEM:Zo_AddMessage("Blocked WTT")
				
			end
		end
		
		if IsSpamEnabledForCategory("GuildRecruit") then
			-- "I" can do some guild recruitment
			if SpamGuildRecruit(text, chanCode) then
				
				CHAT_SYSTEM:Zo_AddMessage("I saw a GR Message ( " .. text .. " )")
				
				-- If I break myself the rule, disable it few minutes
				rChatData.spamTempGuildRecruitStopTimestamp = GetTimeStamp()
				rChatData.spamGuildRecruitStop = true
                CHAT_SYSTEM:Zo_AddMessage("Blocked guild")
				
			end
		end
		
		-- My message will be displayed in any case
		return false
		
	end
	
	-- Spam
	if IsSpamEnabledForCategory("Flood") then
		if SpamFlood(from, text, chanCode) then 
            CHAT_SYSTEM:Zo_AddMessage("Blocked flood 1")
            return true 
        end
	end
	
	-- Looking For
	if IsSpamEnabledForCategory("LookingFor") then
		if SpamLookingFor(text) then 
            CHAT_SYSTEM:Zo_AddMessage("Blocked LFG 1")
            return true 
        end

	end
	
	-- Want To
	if IsSpamEnabledForCategory("WantTo") then
		if SpamWantTo(text) then 
            CHAT_SYSTEM:Zo_AddMessage("Blocked WTT 1")
            return true 
        end
	end
	
	-- Guild Recruit
	if IsSpamEnabledForCategory("GuildRecruit") then
		if SpamGuildRecruit(text, chanCode) then  
            CHAT_SYSTEM:Zo_AddMessage("Blocked GR 1")
            return true 
        end
	end
	
	return false

end
