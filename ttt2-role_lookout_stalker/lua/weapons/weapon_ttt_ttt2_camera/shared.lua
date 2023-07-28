if engine.ActiveGamemode() ~= "terrortown" then return end
SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "normal"
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props/cs_office/Cardboard_box02.mdl"
SWEP.Kind = WEAPON_EXTRA
SWEP.Spawnable = false
SWEP.AutoSpawnable = false
SWEP.AdminOnly = false
SWEP.Slot               = 7

SWEP.CanBuy = {ROLE_DETECTIVE}

SWEP.LimitedStock = true
SWEP.AllowDrop = false

function SWEP:PreDrop()
	self.Owner:DropWeapon( self )
	self:Remove() 
end
