if SERVER then
	AddCSLuaFile()
else

	SWEP.PrintName = "Minigun"
	SWEP.Slot = 7
	SWEP.Icon = "vgui/ttt/icon_minigun"

	-- client side model settings
	SWEP.UseHands = true -- should the hands be displayed
	SWEP.ViewModelFlip = false -- should the weapon be hold with the left or the right hand
	SWEP.ViewModelFOV = 60
end

game.AddAmmoType( {
	name = "MINIGUN",
	dmgtype = DMG_GENERIC,
	tracer = 0,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
} )


SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.Kind = WEAPON_EXTRA

-- always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

--[[Default GMod values]]--
SWEP.Primary.Ammo = "MINIGUN"
SWEP.Primary.Delay = 0.05
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Cone = 0.1
SWEP.Primary.Damage = 2
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 9999
SWEP.Primary.ClipMax = 9999
SWEP.Primary.DefaultClip = 9999
SWEP.Primary.NumShots = 5
SWEP.Primary.Sound = Sound("BlackVulcan.Single")

--[[Model settings]]--
SWEP.HoldType = "crossbow"
SWEP.ViewModel = Model("models/weapons/v_minigunvulcan.mdl")
SWEP.WorldModel = Model("models/weapons/w_m134_minigun.mdl")



--[[TTT config values]]--

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2,
-- then this gun can be spawned as a random weapon.

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "AirboatGun"

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = false

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = true

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 2 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 150)

   -- decay from 3.2 to 1.7
   return 1.7 + math.max(0, (1.5 - 0.002 * (d ^ 1.25)))
end


function SWEP:PreDrop()
	self.Owner:DropWeapon( self )
	self:Remove() 
end
