function SWEP:BurningShot()	-- functions mainly copied from weapon_ttt_flaregun

	local function RunIgniteTimer(ent, timer_name)
		if IsValid(ent) and ent:IsOnFire() then
			if ent:WaterLevel() > 0 then
			ent:Extinguish()
		elseif CurTime() > ent.burn_destroy then
			ent:SetNotSolid(true)
			ent:Remove()
		else
         return
		end
	end

	timer.Remove(timer_name)
	
	end

	local SendScorches

	if CLIENT then
		local function ReceiveScorches()
		local ent = net.ReadEntity()
		local num = net.ReadUInt(8)
		for i=1, num do
			util.PaintDown(net.ReadVector(), "FadingScorch", ent)
		end

		if IsValid(ent) then
			util.PaintDown(ent:LocalToWorld(ent:OBBCenter()), "Scorch", ent)
		end
	end
	net.Receive("TTT_FlareScorch", ReceiveScorches)
	else
		SendScorches = function(ent, tbl)
			net.Start("TTT_FlareScorch")
			net.WriteEntity(ent)
			net.WriteUInt(#tbl, 8)
			for _, p in pairs(tbl) do
				net.WriteVector(p)
			end
		net.Broadcast()
	end

	end

	local function ScorchUnderRagdoll(ent)
		if SERVER then
		local postbl = {}
		for i=0, ent:GetPhysicsObjectCount()-1 do
			local subphys = ent:GetPhysicsObjectNum(i)
			if IsValid(subphys) then
				local pos = subphys:GetPos()
				util.PaintDown(pos, "FadingScorch", ent)

				table.insert(postbl, pos)
			end
		end

		SendScorches(ent, postbl)
	end

	local mid = ent:LocalToWorld(ent:OBBCenter())
	mid.z = mid.z + 25
	util.PaintDown(mid, "Scorch", ent)
	
	end


	function IgniteTarget(att, path, dmginfo)
		local ent = path.Entity
		if not IsValid(ent) then return end

		if CLIENT and IsFirstTimePredicted() then
			if ent:GetClass() == "prop_ragdoll" then
				ScorchUnderRagdoll(ent)
		end
		return
	end

	if SERVER then

		local dur = ent:IsPlayer() and 5 or 10

		if ent:IsPlayer() and (not GAMEMODE:AllowPVP()) then return end

		ent:Ignite(dur, 100)

		ent.ignite_info = {att=dmginfo:GetAttacker(), infl=dmginfo:GetInflictor()}

		if ent:IsPlayer() then
			timer.Simple(dur + 0.1, function()
										if IsValid(ent) then
										ent.ignite_info = nil
										end
									end)

		elseif ent:GetClass() == "prop_ragdoll" then
			ScorchUnderRagdoll(ent)

			local burn_time = 10
			local tname = Format("ragburn_%d_%d", ent:EntIndex(), math.ceil(CurTime()))

			ent.burn_destroy = CurTime() + burn_time

			timer.Create(tname,
						0.1,
						math.ceil(1 + burn_time / 0.1), -- upper limit, failsafe
						function()
							RunIgniteTimer(ent, tname)
						end)
		end
	end
	
	end

	local function ShootFlare()
		local cone = 0
		local bullet = {}
		
		bullet.Num       = 1
		bullet.Src       = self.Owner:GetShootPos()
		bullet.Dir       = self.Owner:GetAimVector()
		bullet.Spread    = Vector( cone, cone, 0 )
		bullet.Tracer    = 1
		bullet.Force     = 2
		bullet.Damage    = 10
		bullet.TracerName = self.Tracer
		bullet.Callback = IgniteTarget

		self.Owner:FireBullets( bullet )
	end
	

	local PrimarySound = Sound( "Weapon_USP.SilencedShot" )
	
	if SERVER then
      sound.Play(PrimarySound, self:GetPos(), self.Primary.SoundLevel)
	end
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	ShootFlare()
	
	if IsValid(self.Owner) then
      self.Owner:SetAnimation( PLAYER_ATTACK1 )

      self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	end

end
