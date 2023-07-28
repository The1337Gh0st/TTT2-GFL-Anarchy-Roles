if engine.ActiveGamemode() == "terrortown" then
    if SERVER and (not file.Exists("weapons/minecraft_swep/shared.lua", "lsv")) then
        util.AddNetworkString("StigMinecraftInstallNet")
        local roundCount = 0

        hook.Add("TTTBeginRound", "StigMinecraftInstallMessage", function()
            roundCount = roundCount + 1

            if (roundCount == 1) or (roundCount == 2) then
                timer.Simple(4, function()
                    PrintMessage(HUD_PRINTTALK, "[TTT Minecraft SWEP (Detective)]\nServer doesn't have the addon this mod needs to work!\nPRESS 'Y', TYPE /minecraft AND SUBSCRIBE TO THE ADDON \nor see this mod's workshop page to install it.")
                end)
            end
        end)

        hook.Add("PlayerSay", "StigMinecraftInstallCommand", function(ply, text)
            if string.lower(text) == "/minecraft" then
                net.Start("StigMinecraftInstallNet")
                net.Send(ply)

                return ""
            end
        end)
    elseif CLIENT then
        net.Receive("StigMinecraftInstallNet", function()
            steamworks.ViewFile("116592647")
        end)
    end

    hook.Add("PreRegisterSWEP", "MinecraftSWEPModified", function(SWEP, class)
        if class == "minecraft_swep" then
            SWEP.Base = "weapon_tttbase"
            SWEP.Kind = WEAPON_EXTRA
            SWEP.InLoadoutFor = nil
            SWEP.LimitedStock = true
            SWEP.AutoSpawnable = false

            SWEP.CanBuy = {ROLE_DETECTIVE}

            SWEP.Slot = 7
            SWEP.AllowDrop = false

            if CLIENT then
                SWEP.PrintName = "Minecraft Block"
                SWEP.Icon = "materials/entities/ttt_minecraft_swep.png"

                SWEP.EquipMenuData = {
                    type = "Weapon",
                    desc = "Place Minecraft blocks! \nPress 'R' to change blocks"
                }
            end

            function SWEP:OnDrop()
                self:Remove()
            end

            function SWEP:ShouldDropOnDie()
                return false
            end

            if SERVER then
                -- Banns the minecraft cake from the block list as it allows for gaining infinite health
                local blacklist = GetConVar("minecraft_swep_blacklist"):GetString()

                local blacklistedBlocks = {"48", "14", "37", "65"}

                local blacklistTable = string.Explode(",", blacklist)

                for _, blockID in ipairs(blacklistedBlocks) do
                    if not string.find(blacklist, blockID) then
                        table.insert(blacklistTable, blockID)
                    end
                end

                blacklist = table.concat(blacklistTable, ",")
                GetConVar("minecraft_swep_blacklist"):SetString(blacklist)
            end
        end
    end)
end