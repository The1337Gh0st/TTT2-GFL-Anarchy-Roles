if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName = "Gambler's Suitcase"
   SWEP.Slot = 6

   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Receive a random Traitor Item!"
   };

   SWEP.Icon = "vgui/ttt/suitcase"
end

SWEP.Base = "weapon_tttbase"
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props_c17/suitcase_passenger_physics.mdl"
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0
SWEP.MaxAmmo = 10 -- Maxumum ammo



SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

-- This is special equipment
SWEP.Kind = WEAPON_EXTRA
SWEP.CanBuy = {ROLE_TRAITOR} -- only detectives can buy
SWEP.LimitedStock = true -- only buyable once
--SWEP.WeaponID = AMMO_CUBE
SWEP.AllowDrop = false
SWEP.NoSights = true

function SWEP:Initialize()

	if ( CLIENT ) then return end

	timer.Create( "gsuitcase_ammo" .. self:EntIndex(), 30, 0, function()
		if ( self:Clip1() < self.MaxAmmo ) then self:SetClip1( math.min( self:Clip1() + 1, self.MaxAmmo ) ) end
	end )

end

function SWEP:PreDrop()
timer.Stop( "gsuitcase_ammo" .. self:EntIndex() )
	self.Owner:DropWeapon( self )
	self:Remove() 
end


function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:CreateSuitcase()
	self:TakePrimaryAmmo (1)

	
end

function SWEP:DrawWorldModel()
	return false
end

SWEP.ENT = nil

function SWEP:CreateSuitcase()
	if SERVER then
		local ply = self.Owner
		local suitcase = ents.Create("ttt_gambler_case")
		suitcase.Role = ROLE_TRAITOR
		if IsValid(suitcase) and IsValid(ply) then
			local vsrc = ply:GetShootPos()
			local vang = ply:GetAimVector()
			local vvel = ply:GetVelocity()
			local vthrow = vvel + vang * 100
			suitcase:SetPos(vsrc + vang * 10)
			suitcase:Spawn()

			local phys = suitcase:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(vthrow)
				phys:SetMass(200)
			end
			self.ENT = suitcase
		end
	end
end

function SWEP:SecondaryAttack()
 	 if not self:CanSecondaryAttack() then
		return
	end
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay)
	if not IsFirstTimePredicted() then
		return
	end
end