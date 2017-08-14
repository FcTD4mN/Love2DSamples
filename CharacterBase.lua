Box     = require( "Box" )

-- Inherits from box
CharacterBase = Box:New( 0, 0, 5, 5 )

function  CharacterBase:New( iX, iY )
    newCharacterBase = {}
    setmetatable( newCharacterBase, self )
    self.__index = self

    newCharacterBase.x = iX
    newCharacterBase.y = iY
    newCharacterBase.w = 24
    newCharacterBase.h = 24

    newCharacterBase.motionVector      = Vector:New( 0, 0 )
    newCharacterBase.directionVector   = Vector:New( 0, 0 )
    newCharacterBase.gravityVector     = Vector:New( 0, 0 )

    newCharacterBase.life = 100

    return  newCharacterBase
end


function  CharacterBase:Type()
    return  "CharacterBase"
end


function CharacterBase:Draw()
    x, y = Camera.MapToScreen( self.x, self.y )
    if  ( x + self.w <= 0 )
        or ( y + self.h <= 0 )
        or ( x >= love.graphics.getWidth() )
        or ( y >= love.graphics.getHeight() ) then
        return
    end

    if( self.life <= 0 ) then
        return
    end

    if( self.life > 70 ) then
        love.graphics.setColor( 0,255,0 )
    elseif( self.life > 30 ) then
        love.graphics.setColor( 255,255,0 )
    else
        love.graphics.setColor( 255,0,0 )
    end
    love.graphics.rectangle( "fill", x, y, self.w, self.h )
end


function  CharacterBase:Collide( iBox, iDirection )
    if( iBox:Type() == "Hero" ) then
        iBox:Hit( love.math.random( 10, 30 ) )
    end

    self.motionVector.y = 0
    self.motionVector.x = 0
end


function  CharacterBase:Hit( iDamage )
    self.life = self.life - iDamage
end


function CharacterBase:TrackAI( iX, iY )
    vector = Vector:New( iX - self.x, iY - self.y )
    self.directionVector = vector:Normalized()
end



return  CharacterBase
