BasicLevel      = require( "BasicLevel" )
Box             = require( "Objects/Box" )
Bullet          = require( "Objects/Bullet" )
Camera          = require( "Camera" )
CollisionPool   = require( "Pools/CollisionPool" )
CharacterBase   = require( "Objects/CharacterBase" )
Hero            = require( "Objects/Hero" )
ProjectilePool  = require( "Pools/ProjectilePool" )

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
    ProjectilePool.Drain()

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

    ProjectilePool.ApplyVectors()

    for k,v in pairs( allEnnemies ) do
        v:ApplyDirectionVector()
    end

    -- Collision
    CollisionPool.RunCollisionTests()

    -- Move
    ProjectilePool.Move()

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
    ProjectilePool.Draw()

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
        x, y = Camera.MapToWorld( love.mouse.getX(), love.mouse.getY() )
        hero:Shoot( Vector:New( x, y ) )
    end
end