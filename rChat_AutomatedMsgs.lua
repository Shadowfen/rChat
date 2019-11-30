rChat = rChat or {}


local SF = LibSFUtils
local LMM = LibMainMenu

rChat_AutomatedMsgs ={}

local L = GetString

ZO_CreateStringId("RCHAT_AUTOMSG_NAME_DEFAULT_TEXT", L(RCHAT_RCHAT_AUTOMSG_NAME_DEFAULT_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_DEFAULT_TEXT", L(RCHAT_RCHAT_AUTOMSG_MESSAGE_DEFAULT_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_TIP1_TEXT", L(RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP1_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_TIP2_TEXT", L(RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP2_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_TIP3_TEXT", L(RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP3_TEXT))
ZO_CreateStringId("RCHAT_AUTOMSG_NAME_HEADER", L(RCHAT_RCHAT_AUTOMSG_NAME_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_MESSAGE_HEADER", L(RCHAT_RCHAT_AUTOMSG_MESSAGE_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_ADD_TITLE_HEADER", L(RCHAT_RCHAT_AUTOMSG_ADD_TITLE_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_EDIT_TITLE_HEADER", L(RCHAT_RCHAT_AUTOMSG_EDIT_TITLE_HEADER))
ZO_CreateStringId("RCHAT_AUTOMSG_ADD_AUTO_MSG", L(RCHAT_RCHAT_AUTOMSG_ADD_AUTO_MSG))
ZO_CreateStringId("RCHAT_AUTOMSG_EDIT_AUTO_MSG", L(RCHAT_RCHAT_AUTOMSG_EDIT_AUTO_MSG))
ZO_CreateStringId("SI_BINDING_NAME_RCHAT_SHOW_AUTO_MSG", L(RCHAT_SI_BINDING_NAME_RCHAT_SHOW_AUTO_MSG))
ZO_CreateStringId("RCHAT_AUTOMSG_REMOVE_AUTO_MSG", L(RCHAT_RCHAT_AUTOMSG_REMOVE_AUTO_MSG))

-- These require access to rChat.save and rChat.data (local vars in rChat.lua that have
-- been stuffed in rChat table so that we can get to them from here.
-- Readdress this properly.
-- When this file is loaded, most of the rChat stuff has not been initialized yet.
-- So when we want access to .save or .data, we must do it when the function is 
-- called, not when the file is loaded.

-- Called by XML
function rChat_HoverRowOfAutomatedMessages(control)
    local rChatData = rChat.data
    rChatData.autoMessagesShowKeybind = true
    rChatData.automatedMessagesList:Row_OnMouseEnter(control)
end

-- Called by XML
function rChat_ExitRowOfAutomatedMessages(control)
    local rChatData = rChat.data
    rChatData.autoMessagesShowKeybind = false
    rChatData.automatedMessagesList:Row_OnMouseExit(control)
end


function rChat_AutomatedMsgs.FindSavedAutomatedMsg(name)
    local dataList = rChat.save.automatedMessages
    for index, data in pairs(dataList) do
        if(data.name == name) then
            return data, index
        end
    end
end

function rChat_AutomatedMsgs.FindAutomatedMsg(name)
    local dataList = rChat.data.automatedMessagesList.list.data
    for i = 1, #dataList do
        local data = dataList[i].data
        if(data.name == name) then
            return data, index
        end
    end
end


function rChat_AutomatedMsgs.CleanAutomatedMessageList(dbs)
    -- :RefreshData() adds dataEntry recursively, delete it to avoid overflow in SavedVars
    for k, v in ipairs(dbs.automatedMessages) do
        if v.dataEntry then
            v.dataEntry = nil
        end
    end
end

function rChat_AutomatedMsgs.RemoveAutomatedMessage(dbs)
    local data = ZO_ScrollList_GetData(WINDOW_MANAGER:GetMouseOverControl())
    local _, index = rChat_AutomatedMsgs.FindSavedAutomatedMsg(data.name)
    table.remove(dbs.automatedMessages, index)
    
    local rChatData = rChat.data
    rChatData.automatedMessagesList:RefreshData()
    rChat_AutomatedMsgs.CleanAutomatedMessageList(dbs)

end


--[[
local MENU_CATEGORY_RCHAT = nil
function rChat_ShowAutoMsg()
    LMM:ToggleCategory(MENU_CATEGORY_RCHAT)
end

-- ---------------------------------------------------------------------------
-- Global space functions called by bindings and XML

function rChat_ShowAutoMsg()
    LMM:ToggleCategory(MENU_CATEGORY_RCHAT)
end

-- Register Slash commands
SLASH_COMMANDS["/msg"] = rChat_ShowAutoMsg
-- ---------------------------------------------------------------------------



local automatedMessagesList = rChat_AutomatedMsgs

function automatedMessagesList:New(control)
    o = {} 
    setmetatable(o, self)
    self.__index = self
    
    ZO_SortFilterList.InitializeSortFilterList(o, control)
    
    local AutomatedMessagesSorterKeys = {
        ["name"] = {},
        ["message"] = {tiebreaker = "name"}
    }
    
    o.masterList = {}
    ZO_ScrollList_AddDataType(o.list, 1, "rChatXMLAutoMsgRowTemplate", 32, 
        function(control, data)  o:SetupEntry(control, data) end)
    ZO_ScrollList_EnableHighlight(o.list, "ZO_ThinListHighlight")
    o.sortFunction = function(listEntry1, listEntry2) 
            return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, 
                    o.currentSortKey, AutomatedMessagesSorterKeys, 
                    o.currentSortOrder) 
            end
    --o:SetAlternateRowBackgrounds(true)
    
    return o
end

function automatedMessagesList:SetupEntry(control, data)
    
    control.data = data
    control.name = GetControl(control, "Name")
    control.message = GetControl(control, "Message")
    
    local messageTrunc = rChat.FormatRawText(data.message)
    if string.len(messageTrunc) > 53 then
        messageTrunc = string.sub(messageTrunc, 1, 53) .. " .."
    end
    
    control.name:SetText(data.name)
    control.message:SetText(messageTrunc)
    
    ZO_SortFilterList.SetupRow(self, control, data)
    
end

function automatedMessagesList:BuildMasterList()
    self.masterList = {}
    local messages = rChat.save.automatedMessages
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

local function SaveAutomatedMessage(name, message, isNew)
    local db = rChat.save   
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
            
            local rChatData = rChat.data
            local entryList = ZO_ScrollList_GetDataList(rChatData.automatedMessagesList.list)
            
            if isNew then
                local data = {name = "!" .. name, message = message}
                local entry = ZO_ScrollList_CreateDataEntry(1, data)
                table.insert(entryList, entry)
                table.insert(db.automatedMessages, {name = "!" .. name, message = message}) -- "data" variable is modified by ZO_ScrollList_CreateDataEntry and will crash eso if saved to savedvars
            else
                
                local data = RAM.FindAutomatedMsg(name)
                local _, index = RAM.FindSavedAutomatedMsg(name)
                
                data.message = message
                db.automatedMessages[index].message = message
            end
            
            ZO_ScrollList_Commit(rChatData.automatedMessagesList.list)
            
        else
            rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(false)
            rChatXMLAutoMsg:GetNamedChild("Warning"):SetText(L(RCHAT_SAVMSGERRALREADYEXISTS))
            rChatXMLAutoMsg:GetNamedChild("Warning"):SetColor(1, 0, 0)
            zo_callLater(function() rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(true) end, 5000)
        end
        
    end

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
                text     = RCHAT_AUTOMSG_ADD_AUTO_MSG,
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
                text     = RCHAT_AUTOMSG_EDIT_AUTO_MSG,
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
--]]