rChat = rChat or {}

local SF = LibSFUtils
local L = GetString

--[[ ---------------------------------------------
A lookup table of tab names indexed by tab index
--]]
rChat_TabNames = {}
local TabNames = rChat_TabNames

function TabNames:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.nameList = {}
	return o
end

function TabNames:Refresh()
	local nameList = {}
    local totalTabs = CHAT_SYSTEM.tabPool.m_Active
	if totalTabs ~= nil and #totalTabs >= 1 then
        for idx, tmpTab in pairs(totalTabs) do
            local tabLabel = tmpTab:GetNamedChild("Text")
            local tmpTabName = tabLabel:GetText()
            if tmpTabName ~= nil and tmpTabName ~= "" then
                nameList[idx] = tmpTabName
            end
        end
    end
	self.nameList = nameList
	return self.nameList
end

function TabNames:GetNames()
	if not self.nameList  then
		self:Refresh()
	end
    local totalTabs = CHAT_SYSTEM.tabPool.m_Active
	if #totalTabs ~= #self.nameList then
		self:Refresh()
	end
	return self.nameList
end

function TabNames:GetIndex(tabName)
    local tabIdx = 1
    for i,v in ipairs(self.nameList) do
        if v == tabName then
            tabIdx = i
            break
        end
    end
    return tabIdx
end

--[[ ---------------------------------------------
  rChat functions which manipulate tabs
--]]

local function isValidTabIndex(tabndx)
    if type(tabndx)~="number" then 
		return false 
	end

    local container=CHAT_SYSTEM.primaryContainer
    if not container then 
		return false 
	end

    if tabndx<1 or tabndx>#container.windows then 
		return false 
	end
    if container.windows[tabndx].tab==nil then 
		return false 
	end
	return true
end

function rChat.ChangeTab(tabToSet)
    if isValidTabIndex(tabToSet) == false then 
		return 
	end

    local container=CHAT_SYSTEM.primaryContainer
	container.tabGroup:SetClickedButton(container.windows[tabToSet].tab)
    if CHAT_SYSTEM:IsMinimized() then 
		CHAT_SYSTEM:Maximize() 
	end
end


