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
    end

    self.x = -10
    self.y = -10
end


return  Bullet
