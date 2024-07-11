if CLIENT then
    local ttsEnabled = true

    net.Receive("TTT_TTS_Speak", function()
        if ttsEnabled then
            local text = net.ReadString()
            local voice = net.ReadString()
            Speak(text, voice)
        end
    end)

    net.Receive("TTT_TTS_ToggleVoice", function()
        ttsEnabled = net.ReadBool()
        if ttsEnabled then
            SetGlobalBool("TTS_Enabled", true)
        else
            SetGlobalBool("TTS_Enabled", false)
        end
    end)

    concommand.Add("voice_1", function()
        ttsEnabled = true
        net.Start("TTT_TTS_ToggleVoice")
        net.WriteBool(true)
        net.SendToServer()
        print("TTS enabled on client")
    end)

    concommand.Add("voice_0", function()
        ttsEnabled = false
        net.Start("TTT_TTS_ToggleVoice")
        net.WriteBool(false)
        net.SendToServer()
        print("TTS disabled on client")
    end)

    concommand.Add("voice_zahar", function() setVoiceCommand("zahar") end)
    concommand.Add("voice_oksana", function() setVoiceCommand("oksana") end)
    concommand.Add("voice_alyss", function() setVoiceCommand("alyss") end)
    concommand.Add("voice_omazh", function() setVoiceCommand("omazh") end)
    concommand.Add("voice_jane", function() setVoiceCommand("jane") end)
    concommand.Add("voice_random", function() setVoiceCommand("random") end)

    local function setVoiceCommand(voice)
        net.Start("TTT_TTS_SetVoice")
        net.WriteString(voice)
        net.SendToServer()
        print("Voice command sent: " .. voice)
    end

    function Speak(text, voice)
        local encodedText = urlencode(text)
        local url = "https://tts.voicetech.yandex.net/tts?speaker=" .. voice .. "&text=" .. encodedText
        print("Generated URL: " .. url) -- Вывод URL в консоль
        sound.PlayURL(url, "3d", function(station)
            if IsValid(station) then
                station:SetVolume(100) -- Громкость
                station:Play()
            else
                print("Failed to play sound from URL: " .. url)
            end
        end)
    end

    function urlencode(str)
        if str then
            str = string.gsub(str, "\n", "\r\n")
            str = string.gsub(str, "([^%w ])", function(c) return string.format("%%%02X", string.byte(c)) end)
            str = string.gsub(str, " ", "%%20")
        end
        return str
    end
end

if CLIENT then
    hook.Add("OnPlayerChat", "TTT_TTS_HandleChatCommand", function(ply, text)
        if ply ~= LocalPlayer() then return end

        if string.StartWith(text, "!voice_1") then
            net.Start("TTT_TTS_ToggleVoice")
            net.WriteBool(true)
            net.SendToServer()
            return true
        elseif string.StartWith(text, "!voice_0") then
            net.Start("TTT_TTS_ToggleVoice")
            net.WriteBool(false)
            net.SendToServer()
            return true
        elseif string.StartWith(text, "!voice_") then
            local voice = string.sub(text, 8)
            net.Start("TTT_TTS_SetVoice")
            net.WriteString(voice)
            net.SendToServer()
            return true
        end
    end)
end