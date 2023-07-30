include( "functions/normal.lua" )
include( "functions/prop.lua" )
include( "functions/explosive.lua" )
include( "functions/burn.lua" )
include( "functions/push.lua" )
include( "functions/poison.lua" )
include( "functions/movespeednerf.lua" )
include( "functions/freeze.lua" )


if SERVER then
   AddCSLuaFile( "ttt_randomgun.lua" )
   AddCSLuaFile( "functions/normal.lua" )
   AddCSLuaFile( "functions/prop.lua" )
   AddCSLuaFile( "functions/explosive.lua" )
   AddCSLuaFile( "functions/burn.lua" )
   AddCSLuaFile( "functions/push.lua" )
   AddCSLuaFile( "functions/poison.lua" )
   AddCSLuaFile( "functions/movespeednerf.lua" )
   AddCSLuaFile( "functions/freeze.lua" )
end

if CLIENT then
	SWEP.PrintName				= "Randomgun"
	SWEP.Author					= "smith"
	SWEP.Instructions			= "You can never be sure what happens next."
	SWEP.Category				= "TTT"
	SWEP.Slot     				= 7

	SWEP.ViewModelFOV  = 72
	SWEP.ViewModelFlip = true
end

SWEP.Base			= "weapon_tttbase"

SWEP.Kind			= WEAPON_EXTRA
SWEP.CanBuy			= {}
SWEP.InLoadoutFor	= nil
SWEP.LimitedStock	= true
SWEP.AllowDrop		= false
SWEP.IsSilent		= false
SWEP.NoSights		= true
SWEP.AutoSpawnable	= false


SWEP.HoldType	= "pistol"
SWEP.AmmoEnt	= "item_ammo_pistol_ttt"

if CLIENT then
   SWEP.Icon = "vgui/ttt/icon_randomgun"

   SWEP.EquipMenuData = {
      type = "Randomgun",
      desc = "You can never be sure what happens next."
   };
end

SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "Pistol"
SWEP.Primary.ClipSize    = 5
SWEP.Primary.DefaultClip = 10

SWEP.ViewModel  = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"

if SERVER then
   resource.AddFile("materials/vgui/ttt/icon_randomgun.vmt")
   resource.AddFile("sound/burp.wav")
   resource.AddFile("sound/burp2.wav")
   resource.AddFile("sound/burp3.wav")
   resource.AddFile("sound/burp4.wav")
end


function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
	if not self:CanPrimaryAttack() then return end
	
	math.randomseed( os.time() )
	local decission = math.random( 1,8 )
	
	if decission == 1 then self:NormalShot()
		elseif decission == 2 then self:PropShot() 
		elseif decission == 3 then self:ExplosiveShot()
		elseif decission == 4 then self:BurningShot()
		elseif decission == 5 then self:PushShot()
		elseif decission == 6 then self:PoisonShot()
		elseif decission == 7 then self:MoveSpeedNerf()
		elseif decission == 8 then self:FreezeShot()
	end
	
	self:TakePrimaryAmmo( 1 )

end

function SWEP:CanPrimaryAttack()
   if not IsValid(self.Owner) then return end

   if self:Clip1() <= 0 then
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end
   return true
end

function SWEP:DryFire(setnext)
	self:EmitSound( "Weapon_Pistol.Empty" )
	setnext(self, CurTime() + 0.2)
end

function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire(CurTime() + 0.7)
   
   math.randomseed( os.time() )
   local decission = math.random( 1,4 )
   
   local SecondarySoundVarOne 	= Sound( "burp.wav" )
   local SecondarySoundVarTwo	= Sound( "burp2.wav" )
   local SecondarySoundVarThree = Sound( "burp3.wav" )
   local SecondarySoundVarFour 	= Sound( "burp4.wav" )
   
   if decission == 1 then self:EmitSound( SecondarySoundVarOne )
		elseif decission == 2 then self:EmitSound( SecondarySoundVarTwo )
		elseif decission == 3 then self:EmitSound( SecondarySoundVarThree )
		elseif decission == 4 then self:EmitSound( SecondarySoundVarFour )
	end

end

function SWEP:PreDrop()
	self.Owner:DropWeapon( self )
	self:Remove() 
end

