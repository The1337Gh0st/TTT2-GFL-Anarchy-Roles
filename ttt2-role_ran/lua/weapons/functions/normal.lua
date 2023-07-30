function SWEP:NormalShot()
	
	local PrimarySound = Sound( "Weapon_AWP.Single" )
	
	if SERVER then
      sound.Play(PrimarySound, self:GetPos(), self.Primary.SoundLevel)
	end
	
	self:ShootBullet( 350, 1, self.Primary.NumShots, 0 )
	
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
	owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * 1, math.Rand(-0.1,0.1) *1, 0 ) )

end