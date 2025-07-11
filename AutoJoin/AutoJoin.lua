local AutoJoinDB = AutoJoinDB or {}

-- Frame to handle events
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")

-- Join all saved channels
local function JoinSavedChannels()
    DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: Attempting to join saved channels...")
    local anyJoined = false
    for channelName, _ in pairs(AutoJoinDB) do
        DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: Joining channel -> " .. channelName)
        JoinChannelByName(channelName)
        anyJoined = true
    end
    if anyJoined then
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoJoin:|r Custom channels loaded.")
    else
        DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: No channels saved.")
    end
end

-- Help message
local function PrintHelp()
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoJoin|r Commands:")
    DEFAULT_CHAT_FRAME:AddMessage("  /aj add <channel>   - Add a channel to auto-join")
    DEFAULT_CHAT_FRAME:AddMessage("  /aj remove <channel> - Remove a channel from auto-join")
    DEFAULT_CHAT_FRAME:AddMessage("  /aj list             - List all auto-join channels")
end

-- Slash command
SLASH_AUTOJOIN1 = "/aj"
SlashCmdList["AUTOJOIN"] = function(msg)
    if not msg then
        PrintHelp()
        return
    end

    local _, _, cmd, rest = string.find(msg, "^(%S+)%s*(.*)$")
    if cmd then cmd = string.lower(cmd) end

    if cmd == "join" or cmd == "j" or cmd == "add" cmd == "a" then
        if rest ~= "" then
            AutoJoinDB[rest] = true
            DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: Added |cff00ff00" .. rest .. "|r to auto-join list.")
            JoinChannelByName(rest)
        else
            DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: Please specify a channel name.")
        end

    elseif cmd == "remove" or cmd == "delete" or cmd == "rm" or cmd == "del" then
        if rest ~= "" then
            if AutoJoinDB[rest] then
                AutoJoinDB[rest] = nil
                DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: Removed |cffff0000" .. rest .. "|r from auto-join list.")
            else
                DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: Channel not found in list.")
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: Please specify a channel name.")
        end

    elseif cmd == "list" then
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoJoin Channels:|r")
        local found = false
        for channel, _ in pairs(AutoJoinDB) do
            DEFAULT_CHAT_FRAME:AddMessage("  - " .. channel)
            found = true
        end
        if not found then
            DEFAULT_CHAT_FRAME:AddMessage("  No channels saved")
        end

    else
        PrintHelp()
    end
end

-- Event handler
f:SetScript("OnEvent", function(self, event)
    if event == "VARIABLES_LOADED" then
        AutoJoinDB = AutoJoinDB or {}
        DEFAULT_CHAT_FRAME:AddMessage("AutoJoin: VARIABLES_LOADED - DB ready.")
    elseif event == "PLAYER_ENTERING_WORLD" then
        JoinSavedChannels()
    end
end)