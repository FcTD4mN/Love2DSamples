Bullet          = require( "Objects/Bullet" )
Vector          = require( "Utilities/Vector" )
Weapon          = require( "Weapons/Weapon" )

-- Inherits from CharacterBase
WeaponLarger = Weapon:New( 20 )

function  WeaponLarger:New( iDamage )
    newWeaponLarger = {}
    setmetatable( newWeaponLarger, self )
    self.__index = self

    newWeaponLarger.damage = iDamage

    return  newWeaponLarger
end


function  WeaponLarger:Type()
    return  "WeaponLarger"
end


function  WeaponLarger:Fire( iCenter, iDestination )
    bulletRad = 20
    bullet = Bullet:New( iCenter.x - bulletRad/2, iCenter.y - bulletRad/2, bulletRad, bulletRad )
    bullet.damage = self.damage

    vector = Vector:New( iDestination.x - iCenter.x, iDestination.y - iCenter.y )
    bullet:AddVectorV( vector:Normalized() * 2 )

    CollisionPool.AddProjectile( bullet )
    ProjectilePool.Add( bullet )
end


return  WeaponLarger
