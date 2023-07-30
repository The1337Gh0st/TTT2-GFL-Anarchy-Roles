if CLIENT then
    EVENT.title = "title_bomber_revive"
    EVENT.icon = Material("vgui/ttt/dynamic/roles/icon_bomber.vmt")

    function EVENT:GetText()
        local reviveText = {
            {
                string = "desc_bomber_revive",
                params = {
                    bomber = self.event.nick,
                    death = self.event.lives
                }
            }
        }

        if self.event.didWorldSpawn then
            reviveText[#reviveText + 1] = {
                string = "desc_bomber_revive_worldspawn",
                params = {
                    bomber = self.event.nick,
                    death = self.event.lives
                }
            }
        end

        return reviveText
    end
end

if SERVER then
    function EVENT:Trigger(bomber, deaths, didWorldSpawn)
        -- self.didWorldSpawn = didWorldSpawn

        bomber.wasBomberRevive = true

        return self:Add({
            nick = bomber:Nick(),
            sid64 = bomber:SteamID64(),
            deaths = deaths,
            didWorldSpawn = didWorldSpawn
        })
    end
    
    hook.Add("TTT2OnTriggeredEvent", "cancel_bomber_revive_event", function(type, eventData)
        if type ~= EVENT_RESPAWN then return end
    
        local ply = player.GetBySteamID64(eventData.sid64)
    
        if not IsValid(ply) or not ply.wasBomberRevive then return end
    
        ply.wasBomberevive = nil 
    
        return false
    end)
end
