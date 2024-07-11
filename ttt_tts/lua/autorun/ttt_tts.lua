if SERVER then
    util.AddNetworkString("TTT_TTS_Speak")
    util.AddNetworkString("TTT_TTS_SetVoice")
    util.AddNetworkString("TTT_TTS_ToggleVoice")

    local quickChatMessages = {
        "Да.",
        "Нет.",
        "На помощь!",
        "Я с никто.",
        "Я вижу никого.",
        "Никто ведет себя подозрительно.",
        "Никто предатель!",
        "Никто невиновный.",
        "Есть кто живой?"
    }

    local playerQuickChat = {}

    local function setVoiceCommand(ply, voice)
        local voices = {"zahar", "oksana", "alyss", "omazh", "jane"}
        if table.HasValue(voices, voice) then
            ply:SetNWString("SelectedVoice", voice)
            ply:ChatPrint("Voice set to: " .. voice)
        elseif voice == "random" then
            local randomVoice = voices[math.random(#voices)]
            ply:SetNWString("SelectedVoice", randomVoice)
            ply:ChatPrint("Random voice selected: " .. randomVoice)
        else
            ply:ChatPrint("Invalid voice: " .. voice)
        end
    end

    local function handleChatCommand(ply, text)
        if string.StartWith(text, "!speech_1") then
            if ply:IsSuperAdmin() then
                SetGlobalBool("TTS_Enabled", true)
                ply:ChatPrint("TTS enabled")
            else
                ply:ChatPrint("You do not have permission to use this command")
            end
            return ""
        elseif string.StartWith(text, "!speech_0") then
            if ply:IsSuperAdmin() then
                SetGlobalBool("TTS_Enabled", false)
                ply:ChatPrint("TTS disabled")
            else
                ply:ChatPrint("You do not have permission to use this command")
            end
            return ""
        elseif string.StartWith(text, "!voice_1") then
            net.Start("TTT_TTS_ToggleVoice")
            net.WriteBool(true)
            net.Send(ply)
            ply:ChatPrint("TTS enabled for your client")
            return ""
        elseif string.StartWith(text, "!voice_0") then
            net.Start("TTT_TTS_ToggleVoice")
            net.WriteBool(false)
            net.Send(ply)
            ply:ChatPrint("TTS disabled for your client")
            return ""
        elseif string.StartWith(text, "!voice_") then
            local voice = string.sub(text, 8)
            setVoiceCommand(ply, voice)
            return ""
        end
        return text
    end

    hook.Add("PlayerSay", "TTTChatTTS", function(ply, text, team)
        text = handleChatCommand(ply, text)
        if text == "" then return "" end

        if GetGlobalBool("TTS_Enabled", true) then
            local voice = ply:GetNWString("SelectedVoice", "random")
            if voice == "random" then
                local voices = {"zahar", "oksana", "alyss", "omazh", "jane"}
                voice = voices[math.random(#voices)]
                ply:SetNWString("SelectedVoice", voice)
                ply:ChatPrint("Random voice selected: " .. voice)
            end

            if ply:GetRole() == ROLE_INNOCENT then
                net.Start("TTT_TTS_Speak")
                net.WriteString(text)
                net.WriteString(voice)
                net.Broadcast()
            elseif ply:GetRole() == ROLE_TRAITOR or ply:GetRole() == ROLE_DETECTIVE then
                if not team then
                    net.Start("TTT_TTS_Speak")
                    net.WriteString(text)
                    net.WriteString(voice)
                    net.Broadcast()
                end
            end
        end
        return text
    end)

    hook.Add("PlayerButtonDown", "TTTQuickChatTTS", function(ply, button)
        if ply:Team() == TEAM_SPEC then return end  -- Игнорируем наблюдателей

        if button == KEY_B then
            playerQuickChat[ply] = true
        elseif button >= KEY_1 and button <= KEY_9 then
            if playerQuickChat[ply] then
                local quickChatMessage = quickChatMessages[button - KEY_1 + 1]
                local voice = ply:GetNWString("SelectedVoice", "random")
                if voice == "random" then
                    local voices = {"zahar", "oksana", "alyss", "omazh", "jane"}
                    voice = voices[math.random(#voices)]
                    ply:SetNWString("SelectedVoice", voice)
                end
                net.Start("TTT_TTS_Speak")
                net.WriteString(quickChatMessage)
                net.WriteString(voice)
                net.Broadcast()
                playerQuickChat[ply] = nil
            end
        end
    end)

    hook.Add("PlayerDisconnected", "TTTClearQuickChat", function(ply)
        playerQuickChat[ply] = nil
    end)

    concommand.Add("speech_1", function(ply)
        if ply:IsSuperAdmin() then
            SetGlobalBool("TTS_Enabled", true)
            ply:ChatPrint("TTS enabled")
        else
            ply:ChatPrint("You do not have permission to use this command")
        end
    end)

    concommand.Add("speech_0", function(ply)
        if ply:IsSuperAdmin() then
            SetGlobalBool("TTS_Enabled", false)
            ply:ChatPrint("TTS disabled")
        else
            ply:ChatPrint("You do not have permission to use this command")
        end
    end)


    concommand.Add("voice_zahar", function(ply) setVoiceCommand(ply, "zahar") end)
    concommand.Add("voice_oksana", function(ply) setVoiceCommand(ply, "oksana") end)
    concommand.Add("voice_alyss", function(ply) setVoiceCommand(ply, "alyss") end)
    concommand.Add("voice_omazh", function(ply) setVoiceCommand(ply, "omazh") end)
    concommand.Add("voice_jane", function(ply) setVoiceCommand(ply, "jane") end)
    concommand.Add("voice_random", function(ply) setVoiceCommand(ply, "random") end)
    concommand.Add("voice_1", function(ply)
        net.Start("TTT_TTS_ToggleVoice")
        net.WriteBool(true)
        net.Send(ply)
        ply:ChatPrint("TTS enabled for your client")
    end)
    concommand.Add("voice_0", function(ply)
        net.Start("TTT_TTS_ToggleVoice")
        net.WriteBool(false)
        net.Send(ply)
        ply:ChatPrint("TTS disabled for your client")
    end)
end
