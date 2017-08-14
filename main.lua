BasicLevel      = require( "BasicLevel" )
Box             = require( "Box" )
Bullet          = require( "Bullet" )
Camera          = require( "Camera" )
CollisionPool   = require( "CollisionPool" )
CharacterBase   = require( "CharacterBase" )
Hero            = require( "Hero" )

local  hSpeed = 8
local  allProjectiles = {}
local  allEnnemies = {}
local  nbEnemies = 2
local  tick = 0

function love.load()
    hero        = Hero:New( love.graphics.getWidth() / 2 - 8, love.graphics.getHeight() / 2 - 8, 16, 16 )
    BasicLevel.Initialize()

    for i = 0, nbEnemies do
        ennemi  =  CharacterBase:New( love.math.random( love.graphics.getWidth() - 16 ), 500 )
        CollisionPool.AddActiveElement( ennemi )
        table.insert( allEnnemies, ennemi )
    end

    CollisionPool.AddActiveElement( hero )

    totalBackground = love.graphics.newImage( "Images/Background.png" )
    bg = love.graphics.newQuad( 0, 0, love.graphics.getWidth(), love.graphics.getHeight(), totalBackground:getWidth(), totalBackground:getHeight() )

    love.mouse.setVisible( false )
end


function love.update( iDeltaTime )
    -- So, here is the thing
    -- If we don't limit computers with ticks, the faster the computer will be, the faster the game will as well ...
    -- So all processing stuff have to be timed, whereas drawing stuff can go as fast as possible
    if( tick <= 1/124 ) then
        tick = tick + iDeltaTime
        return
    end

    tick = 0

    -- Ex6TenZ
    for k,v in pairs( allProjectiles ) do
        if( v:IsWithinWindow() == false ) then
            CollisionPool.RemoveActiveElement( v )
            table.remove( allProjectiles, k )
        end
    end

    for k,v in pairs( allEnnemies ) do
        if( v.life <= 0 ) then
            CollisionPool.RemoveActiveElement( v )
            table.remove( allEnnemies, k )
        end
    end

    -- AI stuff
    -- for k,v in pairs( allEnnemies ) do
    --     v:TrackAI( hero.x, hero.y )
    -- end

    -- Motion part
    hero:ApplyDirectionVector()

    for k,v in pairs( allProjectiles ) do
        v:ApplyDirectionVector()
    end

    for k,v in pairs( allEnnemies ) do
        v:ApplyDirectionVector()
    end

    -- Collision
    CollisionPool.RunCollisionTests()

    -- Move
    for k,v in pairs( allProjectiles ) do
        v:Move()
    end

    for k,v in pairs( allEnnemies ) do
        v:Move()
    end

    hero:Move()

    -- Camera
    x, y, w, h = bg:getViewport()
    bg:setViewport( Camera.x, Camera.y, w, h )
end


function love.draw()

    love.graphics.draw( totalBackground, bg, 0, 0 )

    love.graphics.setColor( 255, 10, 10 )
    hero:Draw()

    BasicLevel.Draw()

    for k,v in pairs( allEnnemies ) do
        v:Draw()
    end

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
        hero:AddVector( hSpeed, 0 )
    elseif( iKey == "q" ) then
        hero:AddVector( -hSpeed, 0 )
    elseif( iKey == "space" ) then
        hero:AddVector( 0, -hSpeed * 3 )
    end
end


function love.keyreleased( iKey )
    if iKey == "d" then
        hero:AddVector( -hSpeed, 0 )
    elseif( iKey == "q" ) then
        hero:AddVector( hSpeed, 0 )
    end
end


function  love.mousepressed( iX, iY, iButton, iIsTouch )
    if( iButton == 1 ) then
        bullet = Bullet:New( hero.x + hero.w / 2, hero.y + hero.h / 2, 5, 5 )
        CollisionPool.AddActiveElement( bullet )
        table.insert( allProjectiles, bullet )

        x, y = Camera.MapToWorld( love.mouse.getX(), love.mouse.getY() )
        vector = Vector:New( x - bullet.x, y - bullet.y )
        bullet:AddVectorV( vector:Normalized() * 5 )
    end
end