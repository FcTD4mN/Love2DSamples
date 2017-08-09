Box             = require( "Box" )
Bullet          = require( "Bullet" )
CollisionPool   = require( "CollisionPool" )
Ennemi          = require( "Ennemi" )

local  hSpeed = 2
local  allProjectiles = {}
local  allEnnemies = {} -- TODO: handle bunch of ennemies + make them go towards player (function AI() ?)

function love.load()
    box         = Box:New( 10, 10, 16, 16 )
    ground      = Box:New( 0, love.graphics.getHeight() - 16, love.graphics.getWidth(), 16 )
    wallTop     = Box:New( 50, love.graphics.getHeight() - 16*8, 16, 16*2 )
    wallBottom  = Box:New( 50, love.graphics.getHeight() - 16*3, 16, 16*2 )

    ennemi      = Ennemi:New( 200, 10 )

    CollisionPool.AddInertElement( ground )
    CollisionPool.AddInertElement( wallTop )
    CollisionPool.AddInertElement( wallBottom )
    CollisionPool.AddInertElement( ennemi )
    CollisionPool.AddActiveElement( box )

    love.mouse.setVisible( false )
end


function love.update( dt )
    -- Ex6TenZ
    for k,v in pairs( allProjectiles ) do
        if( v:IsWithinWindow() == false ) then
            table.remove( allProjectiles, k )
        end
    end

    -- Motion part
    box:ApplyDirectionVector()

    for k,v in pairs( allProjectiles ) do
        v:ApplyDirectionVector()
    end

    CollisionPool.RunCollisionTests()

    for k,v in pairs( allProjectiles ) do
        v:Move()
    end

    box:Move()
end


function love.draw()
    love.graphics.setColor( 255, 10, 10 )
    box:Draw()
    love.graphics.setColor( 10, 255, 10 )
    ground:Draw()
    love.graphics.setColor( 10, 255, 50 )
    wallTop:Draw()
    love.graphics.setColor( 10, 255, 50 )
    wallBottom:Draw()

    ennemi:Draw()

    love.graphics.setColor( 255, 255, 50 )
    for k,v in pairs( allProjectiles ) do
        v:Draw()
    end

    DrawCursor()
end


function  DrawCursor()
    x, y = love.mouse.getPosition()
    love.graphics.setColor( 255, 255, 255 )
    love.graphics.rectangle( "fill", x - 10 , y, 5, 1 )
    love.graphics.rectangle( "fill", x + 5 , y, 5, 1 )
    love.graphics.rectangle( "fill", x , y + 5, 1, 5 )
    love.graphics.rectangle( "fill", x , y - 10, 1, 5 )
end


function love.keypressed( iKey )
    if iKey == "d" then
        box:AddVector( hSpeed, 0 )
    elseif( iKey == "q" ) then
        box:AddVector( -hSpeed, 0 )
    elseif( iKey == "space" ) then
        box:AddVector( 0, -10 )
    end
end


function love.keyreleased( iKey )
    if iKey == "d" then
        box:AddVector( -hSpeed, 0 )
    elseif( iKey == "q" ) then
        box:AddVector( hSpeed, 0 )
    end
end


function  love.mousepressed( iX, iY, iButton, iIsTouch )
    if( iButton == 1 ) then
        bullet = Bullet:New( box.x + box.w / 2, box.y + box.h / 2, 5, 5 )
        CollisionPool.AddActiveElement( bullet )
        table.insert( allProjectiles, bullet )
        vector = Vector:New( love.mouse.getX() - bullet.x, love.mouse.getY() - bullet.y )
        bullet:AddVectorV( vector:Normalized() * 5 )
    end
end