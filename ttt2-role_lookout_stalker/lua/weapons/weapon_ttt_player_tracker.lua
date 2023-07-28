-- Tracker

if SERVER then
   AddCSLuaFile( "weapon_ttt_player_tracker.lua" )
end

if CLIENT then
   SWEP.PrintName = "Player Tracker"
   SWEP.Author = "CountLow"
   SWEP.Slot      = 7 

   SWEP.ViewModelFOV  = 54
	SWEP.ViewModelFlip = false

end

SWEP.Base				= "weapon_tttbase"

SWEP.HoldType			= "pistol"
SWEP.UseHands = true

SWEP.Primary.Delay       = 0.1
SWEP.Primary.Recoil      = 0
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize    = 5
SWEP.Primary.ClipMax     = 5
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Sound         = Sound( "Weapon_FiveSeven.Single" )
SWEP.MaxAmmo = 5 -- Maximum ammo
SWEP.DeploySpeed = 3

SWEP.IronSightsPos         = Vector(-5.95, -4, 2.799)
SWEP.IronSightsAng         = Vector(0, 0, 0)


SWEP.ViewModel             = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_fiveseven.mdl"



SWEP.Kind = WEAPON_EXTRA

SWEP.AutoSpawnable = false

SWEP.AmmoEnt = "none"

SWEP.InLoadoutFor = nil

SWEP.LimitedStock = true

SWEP.AllowDrop = false

SWEP.IsSilent = false

SWEP.NoSights = false

if CLIENT then
   SWEP.Icon = "VGUI/ttt/icon_dart"

   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "If you shoot someone, they will be given an aura effect that allows you to track them through walls. It starts with 2 shots."
   };
end

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_dart.vmt")
end



local tracked = {}
local prog = 0

function SWEP:Initialize()


	if ( CLIENT ) then return end

	timer.Create( "tracker_ammo" .. self:EntIndex(), 45, 0, function()
		if ( self:Clip1() < self.MaxAmmo ) then self:SetClip1( math.min( self:Clip1() + 1, self.MaxAmmo ) ) end
	end )

end

function SWEP:PrimaryAttack() 
 if ( !self:CanPrimaryAttack() ) then return end
 --self.Weapon:EmitSound ( "Weapon_FiveSeven.Single", 100, 100 )
    if SERVER then
       
        self:SetNextPrimaryFire(CurTime() + 0.5)
        
        self:ShootBullet( 0, 1, 0.001 )

        self:TakePrimaryAmmo( 1 )

   --     self.Owner:ViewPunch( Angle( -4, 0, 0 ) )
    end
    if CLIENT then

        local ply = self:GetOwner()
        local tr = ply:GetEyeTrace()
        local tar = tr.Entity

        if(tar.IsPlayer() == false) then return end

        tracked[prog] = tar

        prog = prog + 1
    end
end


hook.Add("PreDrawHalos", "Draw", function()
    for a = 0, #tracked, 1 do
        if(IsValid(tracked[a]) and tracked[a]:Alive() == false) then tracked[a] = false end
    end
    halo.Add(tracked, Color(0,230,150, 255), 2, 2, 10, false, true)
end)

hook.Add("TTTBeginRound", "start", function()
    if CLIENT then
        prog = 0
        table.Empty( tracked )
    end
end)

hook.Add("TTTPrepareRound", "prep", function()
    if CLIENT then
        prog = 0
        table.Empty( tracked )
    end
end)

function reset(weap, own)
    swap = !swap
	if(own ~= nil) then
		own:SetFOV(0, 0.1)
		weap:SetIronsights( false )
	end
end

function SWEP:Holster()
    reset(self, self.Owner)
    return true
end

function SWEP:Reload()
    reset(self, self.Owner)
end


function SWEP:SetZoom(state)
   if CLIENT then return end
   if not (IsValid(self.Owner) and self.Owner:IsPlayer()) then return end
   if state then
      self.Owner:SetFOV(35, 0.5)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end


-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end
    
    bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    
    if SERVER then
        self:SetZoom(bIronsights)
    end
    
    self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetZoom( false )
    self:SetIronsights( false )
	timer.Stop( "tracker_ammo" .. self:EntIndex() )
	self.Owner:DropWeapon( self )
	self:Remove() 
    return self.BaseClass.PreDrop(self)
	

end



function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
    self:DefaultReload( ACT_VM_RELOAD )
    self:SetIronsights( false )
    self:SetZoom( false )
end

function SWEP:Holster()
    self:SetIronsights( false )
    self:SetZoom( false )
    return true
end

function SWEP:Deploy()
		self.Weapon:SetNextPrimaryFire(CurTime()+1)
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		return true
	end
