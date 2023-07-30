---- Example TTT custom weapon

-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile()
	resource.AddFile( "materials/VGUI/ttt/bomb_transfusion.vtf" )
	resource.AddFile( "materials/VGUI/ttt/bomb_transfusion.vmt" )
	resource.AddFile( "sound/click.mp3" )
	resource.AddFile( "sound/killer_queen.mp3" )
	resource.AddFile( "sound/kotchio_miro.mp3" )
	resource.AddFile( "sound/primary_bomb.mp3" )
	resource.AddFile( "sound/sha.mp3" )
end

if CLIENT then
   SWEP.PrintName = "Bomb Transmutation"
   SWEP.Slot      = 7 -- add 1 to get the slot number key

   SWEP.ViewModelFlip = false

   SWEP.Icon = "VGUI/ttt/bomb_transfusion"

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "[[Killer Queen has touched this object]]"
   };
end

game.AddAmmoType( {
	name = "killerqueen",
	dmgtype = DMG_GENERIC,
	tracer = 0,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
} )


-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_tttbase"

--- Standard GMod values

local swep_kq_charge_radius = CreateConVar("swep_kq_charge_radius", 200, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
                                                "Radius in which you can charge entity as bomb")
local swep_kq_trigger_radius = CreateConVar("swep_kq_trigger_radius", 100, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
                                                "Radius in which charged object will trigger player/npc detonation")
local swep_kq_explosion_radius = CreateConVar("swep_kq_explosion_radius", 10, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
												"Explosion radius")
local swep_kq_delay = CreateConVar("swep_kq_delay", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
												"Delay between trigger (*click* sound) and explosion")

local swep_kq_target_owner = CreateConVar("swep_kq_target_owner", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
												"Enable bomb to detonate it's owner")

local swep_kq_sound_deploy = CreateConVar("swep_kq_sound_deploy", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
												"Enable `Killer Queen` sound on deploy")
local swep_kq_sound_charge = CreateConVar("swep_kq_sound_charge", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
												"Enable `Ichi no bakudan` sound on charge")
local swep_kq_sound_trigger = CreateConVar("swep_kq_sound_trigger", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
												"Enable *click* sound on trigger")
local swep_kq_remove = CreateConVar("swep_kq_remove", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE},
												"Whether or not the bomb will remove something upon use")
CreateConVar("swep_kq_charges", 2, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How many charges Bomb Transmutation starts with", 0, 100)												
CreateConVar("swep_kq_primary_delay", 4, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Attack delay after setting a bomb and triggering a bomb", 0, 100)


SWEP.DrawAmmo = false;
SWEP.DrawCrosshair = false;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = ""

SWEP.Primary.ClipSize = GetConVar("swep_kq_charges"):GetInt()
SWEP.Primary.DefaultClip = GetConVar("swep_kq_charges"):GetInt()
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "killerqueen"
SWEP.AmmoEnt = "none"
SWEP.Primary.Delay = GetConVar("swep_kq_primary_delay"):GetInt()
SWEP.FiresUnderwater = true

SWEP.Delay = 10

bomb = {}
sha = {}
btd = {}

function SWEP:Initialize()
	self:SetWeaponHoldType("magic")
	self.__killerqueen = 57005
	bomb[self.Owner] = nil
end

function SWEP:Deploy()
	if swep_kq_sound_deploy:GetBool() then
		self.Owner:EmitSound("killer_queen.mp3")
	end
	return true
end
 
function SWEP:Holster()
	return true
end
 
function SWEP:Think() 
end

function SWEP:PrimaryAttack()

if ( !self:CanPrimaryAttack() ) then return end

	
	if !bomb[self.Owner] then
		local entity = self.Owner:GetEyeTrace().Entity
		if entity and entity:IsValid() then
			local distance = self.Owner:GetPos():Distance(entity:GetPos())
			if distance <= swep_kq_charge_radius:GetInt() then
				bomb[self.Owner] = entity
				if swep_kq_sound_charge:GetBool() then
					self.Owner:EmitSound("primary_bomb.mp3")
					self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			
				end
			end
		end
	else
		if !bomb[self.Owner]:IsValid() then
			bomb[self.Owner] = nil
		elseif SERVER then 
			if swep_kq_sound_trigger:GetBool() then
				self.Owner:EmitSound("click.mp3")
				self:TakePrimaryAmmo(1)
				self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )


			end

			local target = bomb[self.Owner];
			local target_dissolve = bomb[self.Owner]:IsNPC() or bomb[self.Owner]:IsPlayer();

			bomb[self.Owner] = nil;

			timer.Simple(swep_kq_delay:GetFloat(), function() 
				if not target_dissolve then
					for key, entity in pairs(ents.FindInSphere(target:GetPos(), swep_kq_trigger_radius:GetInt())) do
						local _ = entity:IsNPC() or entity:IsPlayer()

						if not swep_kq_target_owner:GetBool() then
							_ = _ and self.Owner != entity
						end

						if _ and entity:IsValid() and entity:Health() > 0 then
							pos = entity:GetPos()
							target = entity
							target_dissolve = true
							break
						end
					end
					self:Deploy()
				end

				local explode = ents.Create("env_explosion")
				explode:SetOwner(self.Owner)
				explode:SetKeyValue("iMagnitude", swep_kq_explosion_radius:GetInt())
				explode:Spawn()
				explode:SetPos(target:GetPos())
				explode:Fire("Explode", 0, 0)
				
				if target_dissolve then 
					--target:TakeDamage(self.__killerqueen, self.Owner, self)
					local d = DamageInfo()
					d:SetDamage( target:Health() )
					d:SetAttacker( self.Owner )
					d:SetInflictor( self.Owner )
					d:SetDamageType( DMG_DISSOLVE ) 
					target:TakeDamageInfo( d )
				else 
					timer.Simple(0.05, function() 
					if swep_kq_remove:GetBool() then
						if target:IsValid() then 
							target:Remove()
								end
							else
						end
					end)
				end
			end)
		end
	end
end

--function SWEP:Deploy()
	--if (self.Weapon:Clip1() == 0) then
	--	self:Remove()
--	else
	--	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
--	end
--end

--if SERVER then
	--hook.Add("EntityTakeDamage", "PRIMARYBOMBKILLERQUEEN", function(entity, dmg)
	--	if dmg:GetInflictor().__killerqueen then
	--		dmg:SetDamageType(DMG_DISSOLVE)
	--	end
--	end)
--end


--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_EXTRA

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon. Of course this AK is special equipment so it won't,
-- but for the sake of example this is explicitly set to false anyway.
SWEP.AutoSpawnable = false

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = {ROLE_TRAITOR}

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = nil

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = true

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = false

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = true