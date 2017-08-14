Box             = require( "Box" )
Camera          = require( "Camera" )
CharacterBase   = require( "CharacterBase" )
Vector          = require( "Vector" )
Weapon          = require( "Weapon" )
WeaponLarger    = require( "WeaponLarger" )

-- Inherits from CharacterBase
Hero = CharacterBase:New( 0, 0 )

function  Hero:New( iX, iY, iW, iH )
    newHero = {}
    setmetatable( newHero, self )
    self.__index = self

    newHero.x = iX
    newHero.y = iY
    newHero.w = iW
    newHero.h = iH

    newHero.motionVector        = Vector:New( 0, 0 )
    newHero.directionVector     = Vector:New( 0, 0 )
    newHero.gravityVector       = Vector:New( 0, 2 )

    newHero.life = 100

    newHero.weapon = WeaponLarger:New( 90 )

    return  newHero
end


function  Hero:Type()
    return  "Hero"
end


function  Hero:Move()
    self.x = self.x + self.motionVector.x
    self.y = self.y + self.motionVector.y
    self:AddVectorV( self.gravityVector )

    Camera.x = Camera.x + self.motionVector.x
    Camera.y = Camera.y + self.motionVector.y
end


function  Hero:Collide( iBox, iDirection )
    if( iDirection == "Bottom" ) or ( iDirection == "Top" ) then
        self.motionVector.y = 0
        -- We need to reset y, because of speed build ups
        self.directionVector.y = 0
    elseif( iDirection == "Left" ) or ( iDirection == "Right" ) then
        self.motionVector.x = 0
    end
end


function  Hero:Shoot( iDestination )
    center = Vector:New( hero.x + hero.w / 2, hero.y + hero.h / 2 )
    self.weapon:Fire( center, iDestination )
end


return  Hero
