function SWEP:MoveSpeedNerf()
	
	self.Weapon:EmitSound ( "Weapon_USP.SilencedShot", 100, 100 )
	
	if not self:CanPrimaryAttack() then return end
	if SERVER and self.Owner:GetNWBool('disguised',false) == true and string.len(self.Owner:GetNWString('disgas','')) > 0 then self.Owner:ConCommand('ttt_set_disguise 0') end
	if SERVER and _rdm then
		local stid = self.Owner:SteamID()
		if not _rdm.shotsFired[stid] then _rdm.shotsFired[stid] = {} end
		table.insert(_rdm.shotsFired[stid],CurTime())
	end
	if SERVER and ShootLog then ShootLog(Format("WEAPON:\t %s [%s] shot a %s", self.Owner:Nick(), self.Owner:GetRoleString(), self.Weapon:GetClass())) end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   --sound.Play(self.Primary.Sound, self.Weapon:GetPos(), self.Primary.SoundLevel)
   self.Weapon:SendWeaponAnim(ACT_VM_IDLE)

   local cone = 0
   local num = 1

   local bullet = {}
   bullet.Num    = num
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.Force  = 0
   bullet.Damage = 1
   bullet.TracerName = "Tracer"

   local owner = self.Owner
   bullet.Callback = function(att, tr, dmginfo)
		local ply = tr.Entity
		if SERVER and IsValid(ply) and (ply:IsPlayer() or ply:IsNPC()) then
			ply.infected = true
			ply:SetNWBool('infected',true)
			ply:SetWalkSpeed(ply:GetWalkSpeed()*0.6)
		end
	end
    self.Owner:FireBullets( bullet )
	local owner = self.Owner
    if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end


end

local function StopPoison()
    for i, ply in pairs(player.GetAll()) do
      ply:SetWalkSpeed(200)
    end
end

hook.Add("TTTEndRound", "PoisonTimerEnd", StopPoison)
hook.Add("TTTPrepareRound", "PoisonTimerEnd", StopPoison)

local function StopPoison2(ply)
	if IsValid(ply) and ply.infected and not ply:Alive() then
		ply:SetWalkSpeed()
	end
end
hook.Add( "PlayerDisconnected", "playerDisconnected", StopPoison2 )
local function StopPoison2(ply)
	if IsValid(ply) and ply.infected and not ply:Alive() then
		ply:SetWalkSpeed(200)
	end
end
hook.Add("TTTPrepareRound", "PoisonTimerEnd2", StopPoison2)

local function DoPoison(attacker,ply)
	if IsValid(ply) and ply:Alive() and ply.infected and IsValid(attacker) then
		local pos = ply:GetPos()
		local ang = ply:GetAngles()
		local dmg = DamageInfo()
		dmg:SetDamage(0)
		dmg:SetAttacker(attacker)
		dmg:SetInflictor(ply)
		dmg:SetDamageType(DMG_GENERIC)
		ply:TakeDamageInfo(dmg)
	end
end