Box     = require( "Objects/Box" )
Vector  = require( "Utilities/Vector" )

-- Inherits from box
Bullet = Box:New( 0, 0, 5, 5 )

function  Bullet:New( iX, iY, iW, iH )
    newBullet = {}
    setmetatable( newBullet, self )
    self.__index = self

    newBullet.x = iX
    newBullet.y = iY

    newBullet.w = iW
    newBullet.h = iH

    newBullet.x2 = iX + newBullet.w -- So we avoid doing billions times those sums
    newBullet.y2 = iY + newBullet.h -- So we avoid doing billions times those sums

    newBullet.motionVector      = Vector:New( 0, 0 )
    newBullet.directionVector   = Vector:New( 0, 0 )
    newBullet.gravityVector     = Vector:New( 0, 0 )

    newBullet.damage = 0

    return  newBullet
end


function  Bullet:Type()
    return  "Bullet"
end


function  Bullet:Collide( iBox, iDirection )
    if( iBox:Type() == "CharacterBase" ) then
        iBox:Hit( self.damage )
    elseif( iBox:Type() == "Hero" ) then
        return
    elseif( iBox:Type() == "Bullet" ) then
        return
    end

    -- Put it outta screen so it'll be Drained by the projectile pool
    self.x = -10
    self.y = -10
end


return  Bullet
