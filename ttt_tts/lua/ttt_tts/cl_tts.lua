local voices = {"zahar", "oksana", "alyss", "omazh", "jane"}

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w ])", function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "%%20")
    end
    return str
end

function Speak(text, voice)
    local encodedText = urlencode(text)
    local url = "https://tts.voicetech.yandex.net/tts?speaker=" .. voice .. "&text=" .. encodedText
    print("Generated URL: " .. url) -- Вывод URL в консоль
    sound.PlayURL(url, "3d", function(station)
        if IsValid(station) then
            station:SetVolume(1) -- Установить громкость на максимум
            station:Play()
        else
            print("Failed to play sound from URL: " .. url)
        end
    end)
end

local function setVoiceCommand(ply, voice)
    if table.HasValue(voices, voice) then
        LocalPlayer():SetNWString("SelectedVoice", voice)
        print("Voice set to: " .. voice)
    elseif voice == "random" then
        local randomVoice = voices[math.random(#voices)]
        LocalPlayer():SetNWString("SelectedVoice", randomVoice)
        print("Random voice selected: " .. randomVoice)
    else
        print("Invalid voice: " .. voice)
    end
end

concommand.Add("voice_zahar", function() setVoiceCommand(LocalPlayer(), "zahar") end)
concommand.Add("voice_oksana", function() setVoiceCommand(LocalPlayer(), "oksana") end)
concommand.Add("voice_alyss", function() setVoiceCommand(LocalPlayer(), "alyss") end)
concommand.Add("voice_omazh", function() setVoiceCommand(LocalPlayer(), "omazh") end)
concommand.Add("voice_jane", function() setVoiceCommand(LocalPlayer(), "jane") end)
concommand.Add("voice_random", function() setVoiceCommand(LocalPlayer(), "random") end)
