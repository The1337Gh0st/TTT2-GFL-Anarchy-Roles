function SWEP:FreezeShot()

self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   self:EmitSound( "Weapon_USP.SilencedShot", 100, 100 )

   self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

   self:ShootIce()


   if IsValid(self.Owner) then
      self.Owner:SetAnimation( PLAYER_ATTACK1 )

      self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
   end

   if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
      self:SetNWFloat( "LastShootTime", CurTime() )
   end
end
	

function FreezeTarget(att, path, dmginfo)
   local ent = path.Entity
   if not IsValid(ent) then return end

   if SERVER then

      -- disallow if prep or post round
      if ent:IsPlayer() and (not GAMEMODE:AllowPVP()) then return end

      ent:Freeze(true)

      if ent:IsPlayer() then
         timer.Simple(4 + 0.1, function()
                                    if IsValid(ent) then
                                       ent:Freeze(false)
                                    end
                                 end)
      end
   end
end

function SWEP:ShootIce()
   local cone = 0
   local bullet = {}
   bullet.Num       = 1
   bullet.Src       = self.Owner:GetShootPos()
   bullet.Dir       = self.Owner:GetAimVector()
   bullet.Spread    = Vector( cone, cone, 0 )
   bullet.Tracer    = 1
   bullet.Force     = 2
   bullet.Damage    = 0
   bullet.TracerName = self.Tracer
   bullet.Callback = FreezeTarget

   self.Owner:FireBullets( bullet )
end