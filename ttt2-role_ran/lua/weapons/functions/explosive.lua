function SWEP:ExplosiveShot()
	
	local PrimarySound = Sound("weapons/grenade_launcher1.wav")
	
	if SERVER then
      sound.Play(PrimarySound, self:GetPos(), self.Primary.SoundLevel)
	end
	
	if ( CLIENT ) then return end
	
	local angle = self.Owner:EyeAngles() 
	local projectile = ents.Create( "ent_expl_microwave" )
	
	if ( IsValid( projectile ) ) then
		projectile:SetPos( self.Owner:GetShootPos() + angle:Forward() * 50 + angle:Right() * 1 - angle:Up() * 1 )
		projectile:SetAngles( angle )
		projectile:SetOwner( self.Owner )
		projectile:Spawn()
		projectile:Activate()
	else
		self:DryFire()
	end

end