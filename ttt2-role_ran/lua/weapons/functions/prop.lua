function SWEP:PropShot()

	local PrimarySound = Sound("weapons/grenade_launcher1.wav")
	
	if SERVER then
      sound.Play(PrimarySound, self:GetPos(), self.Primary.SoundLevel)
	end
	
	if ( CLIENT ) then return end

	local ent = ents.Create( "prop_physics" )
	if (  !IsValid( ent ) ) then return end
	ent:SetModel( "models/props_c17/oildrum001.mdl" )
 	util.SpriteTrail(ent, 0, Color(255,215,0), false, 16, 1, 6, 1/(15+1)*0.5, "trails/tube.vmt")

	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:Spawn()
	
	local phys = ent:GetPhysicsObject()
	if (  !IsValid( phys ) ) then ent:Remove() return end
	
	phys:SetMass( 250 )
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 900000
	phys:ApplyForceCenter( velocity )

end