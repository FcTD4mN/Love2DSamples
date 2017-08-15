Bullet          = require( "Objects/Bullet" )
Vector          = require( "Utilities/Vector" )
Weapon          = require( "Weapons/Weapon" )

-- Inherits from CharacterBase
WeaponSpread = Weapon:New( 5 )

function  WeaponSpread:New( iDamage )
    newWeaponSpread = {}
    setmetatable( newWeaponSpread, self )
    self.__index = self

    newWeaponSpread.damage = iDamage

    return  newWeaponSpread
end


function  WeaponSpread:Type()
    return  "WeaponSpread"
end


function  WeaponSpread:Fire( iCenter, iDestination )
    bulletRad = 5
    for i = -10, 10 do
        bullet = Bullet:New( iCenter.x - bulletRad/2, iCenter.y - bulletRad/2, bulletRad, bulletRad )
        bullet.damage = self.damage

        vector = Vector:New( ( iDestination.x - i*5 ) - iCenter.x, ( iDestination.y - i*5 ) - iCenter.y )
        bullet:AddVectorV( vector:Normalized() * 2 )

        CollisionPool.AddProjectile( bullet )
        ProjectilePool.Add( bullet )
    end
end


return  WeaponSpread
