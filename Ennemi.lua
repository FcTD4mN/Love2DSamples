Box     = require( "Box" )

-- Inherits from box
Ennemi = Box:New( 0, 0, 5, 5 )

function  Ennemi:New( iX, iY )
    newEnnemi = {}
    setmetatable( newEnnemi, self )
    self.__index = self

    newEnnemi.x = iX
    newEnnemi.y = iY
    newEnnemi.w = 24
    newEnnemi.h = 24

    newEnnemi.motionVector      = Vector:New( 0, 0 )
    newEnnemi.directionVector   = Vector:New( 0, 0 )
    newEnnemi.gravityVector     = Vector:New( 0, 0 )

    newEnnemi.life = 100

    return  newEnnemi
end


function  Ennemi:Type()
    return  "Ennemi"
end


function Ennemi:Draw()
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
    love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )
end


function  Ennemi:Collide( iBox, iDirection )
    self.motionVector.y = 0
    self.motionVector.x = 0
end


function  Ennemi:Hit()
    self.life = self.life - 10
end


function Ennemi:TrackAI( iX, iY )
    vector = Vector:New( iX - self.x, iY - self.y )
    self.directionVector = vector:Normalized()
end



return  Ennemi
