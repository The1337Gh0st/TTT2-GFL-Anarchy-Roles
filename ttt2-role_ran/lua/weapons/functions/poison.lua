function SWEP:PoisonShot()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

   if not IsFirstTimePredicted() then return end

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = 0
   
   self.Owner:LagCompensation(true)

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Tracer = 0
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 10
   bullet.Damage = dmg
   bullet.Inflictor = self
   
   bullet.Callback = function(ply,tr,dmginfo)
	   local ent = tr.Entity
		 if IsValid(ent) and ent:IsPlayer()then 
			TakePoisonDamage(ent, self.Owner, self)
		 end 
   end
   
   if SERVER then
		self.Owner:FireBullets(bullet)
   end
   
   self.Owner:LagCompensation(false)
   
   if (not IsValid(self.Owner)) or (not self.Owner:Alive()) or self.Owner:IsNPC() then return end
      
   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then
      
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self.Owner:EyeAngles()
      self.Owner:SetEyeAngles( eyeang )
   end
   
   self.Weapon:EmitSound ( "Weapon_USP.SilencedShot", 100, 100 )
	
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
		
	
	

end

if SERVER then
	function TakePoisonDamage(ply, owner, wep)
		local thistime = CurTime() - 1

		timer.Create("TakePoisonDamage_"..ply:EntIndex(), 1, 100, function()
		
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(4)
			dmginfo:SetAttacker(owner)
			dmginfo:SetInflictor(wep)
			dmginfo:SetDamageType(DMG_POISON)
			ply:TakeDamageInfo(dmginfo)
			
			if thistime < CurTime() then
				ply:EmitSound("vo/npc/male01/mygut02.wav")
				thistime = CurTime() + 5
			end
			ply:SetNWBool("Poisoned", true)
			ply:SetPlayerColor(Vector(0, 1, 0))
			ply:SetColor(Color(0,255,0,255))
			if !ply:Alive() then
				ply:SetNWBool("Poisoned", false)
				timer.Stop("TakePoisonDamage_"..ply:EntIndex())
			end
		end)
	end

	function StopPoisonDamage(ply, sound)
		if sound then
			ply:EmitSound("vo/ravenholm/cartrap_better.wav")
		end
		ply:SetColor(Color(255,255,255,255))
		ply:SetPlayerColor(Vector(GAMEMODE.playercolor.r/255, GAMEMODE.playercolor.g/255, GAMEMODE.playercolor.b/255))
		ply:SetNWBool("Poisoned", false)
		timer.Stop("TakePoisonDamage_"..ply:EntIndex())
	end
	hook.Add("PlayerSpawn", "StopPoisonDamage", StopPoisonDamage2)
	
	local function Negate(ply, ent)
		if !ply:IsValid() or ply:IsSpec() then return end 
		if !ply:GetNWBool("Poisoned") then return end
		if ent:IsValid() and ent:GetClass() == "ttt_health_station" then
			StopPoisonDamage(ply, true)
		end
	end
	hook.Add("PlayerUse", "NegatePoisonHPStation", Negate)
	
	local function RemoveEffects(ply)
		StopPoisonDamage(ply, false)
	end
	hook.Add("PlayerSpawn", "RemovePoisonEffects", RemoveEffects)
end