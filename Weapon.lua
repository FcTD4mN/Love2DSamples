Bullet          = require( "Bullet" )
CollisionPool   = require( "CollisionPool" )
ProjectilePool  = require( "ProjectilePool" )
Vector          = require( "Vector" )

local Weapon = {}

function Weapon:New( iDamage )
    newWeapon = {}
    setmetatable( newWeapon, self )
    self.__index = self

    newWeapon.damage = iDamage

    return  newWeapon
end


function  Weapon:Type()
    return  "Weapon"
end


function  Weapon:Fire( iCenter, iDestination )
    bullet = Bullet:New( iCenter.x, iCenter.y, 5, 5 )
    bullet.damage = self.damage

    vector = Vector:New( iDestination.x - iCenter.x, iDestination.y - iCenter.y )
    bullet:AddVectorV( vector:Normalized() * 10 )

    CollisionPool.AddActiveElement( bullet )
    ProjectilePool.Add( bullet )
end


return  Weapon