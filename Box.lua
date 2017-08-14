Camera = require( "Camera" )
Vector = require( "Vector" )

local Box = {}


function Box:New( iX, iY, iW, iH )
    newBox = {}
    setmetatable( newBox, self )
    self.__index = self

    newBox.x = iX
    newBox.y = iY
    newBox.w = iW
    newBox.h = iH

    newBox.motionVector     = Vector:New( 0, 0 )
    newBox.directionVector  = Vector:New( 0, 0 )
    newBox.gravityVector    = Vector:New( 0, 2 )

    return  newBox
end


function  Box:Type()
    return  "Box"
end


function Box:Draw()
    x, y = Camera.MapToScreen( self.x, self.y )
    if  ( x + self.w <= 0 )
        or ( y + self.h <= 0 )
        or ( x >= love.graphics.getWidth() )
        or ( y >= love.graphics.getHeight() ) then
        return
    end

    love.graphics.rectangle( "fill", x, y, self.w, self.h )
end


function  Box:ApplyDirectionVector()
    self.motionVector.x = self.directionVector.x
    self.motionVector.y = self.directionVector.y
end


function Box:AddVector( iX, iY )
    self.directionVector:Add( Vector:New( iX, iY ) )
end

-- Overload doesn't work in lua..
function Box:AddVectorV( iVector )
    self.directionVector:Add( iVector )
end


function Box:SetVector( iX, iY )
    self.directionVector = Vector:New( iX, iY )
end


function Box:Move()
    self.x = self.x + self.motionVector.x
    self.y = self.y + self.motionVector.y
    self:AddVectorV( self.gravityVector )
end


function  Box:Collide( iBox, iDirection )
    if( iDirection == "Bottom" ) or ( iDirection == "Top" ) then
        self.motionVector.y = 0
        -- We need to reset y, because of speed build ups
        self.directionVector.y = 0
    elseif( iDirection == "Left" ) or ( iDirection == "Right" ) then
        self.motionVector.x = 0
    end
end


function  Box:SimpleCollision( iBox )
    if( self:ContainsPoint( iBox.x, iBox.y ) )          then return  true  end
    if( self:ContainsPoint( iBox.x, iBox.y + iBox.h ) ) then return  true  end
    if( self:ContainsPoint( iBox.x + iBox.w, iBox.y ) ) then return  true  end
    if( self:ContainsPoint( iBox.x + iBox.w, iBox.y + iBox.h ) ) then return  true  end

    return  false
end


function  Box:ContainsPoint( iX, iY )
    if( iX >= self.x )
    and ( iX <= self.x + self.w )
    and ( iY >= self.y )
    and ( iY <= self.y + self.h ) then
        return  true
    end

    return  false
end


function  Box:IsWithinWindow()
    x, y = Camera.MapToScreen( self.x, self.y )
    return  x > 0 and x + self.w < love.graphics.getWidth()
        and y > 0 and y + self.h < love.graphics.getHeight()
end


return  Box