function SWEP:PushShot()
	
	local function FirePulse(force_fwd, force_up)
		if not IsValid(self.Owner) then return end

		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)

		self:SendWeaponAnim(ACT_VM_IDLE)

		local cone =  0
		local num = 1

		local bullet = {}
		bullet.Num    = num
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector( cone, cone, 0 )
		bullet.Tracer = 1
		bullet.Force  = 9999
		bullet.Damage = 1
		bullet.TracerName = "AirboatGunHeavyTracer"

		local owner = self.Owner
		local fwd = force_fwd / num
		local up = force_up / num
		bullet.Callback = function(att, tr, dmginfo)
            local ply = tr.Entity
                if SERVER and IsValid(ply) and ply:IsPlayer() and (not ply:IsFrozen()) then
                    local pushvel = tr.Normal * fwd

                    pushvel.z = math.max(pushvel.z, up)

                    ply:SetGroundEntity(nil)
                    ply:SetLocalVelocity(ply:GetVelocity() + pushvel)

                     ply.was_pushed = {att=owner, t=CurTime(), wep=self:GetClass()}

                end
            end

		self.Owner:FireBullets( bullet )

	end
	
	local PrimarySound = Sound( "weapons/ar2/fire1.wav" )
	
	if SERVER then
      sound.Play(PrimarySound, self:GetPos(), self.Primary.SoundLevel)
	end
	
	FirePulse(1500, 500)

end
