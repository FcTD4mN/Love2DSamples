CollisionPool = require( "Pools/CollisionPool" )

local BasicLevel = {
    allWalls = {}
}

function  BasicLevel.Initialize()
    BasicLevel.AddWall( 50, love.graphics.getHeight() - 16*8, 16, 16*2 )
    BasicLevel.AddWall( 50, love.graphics.getHeight() - 16*3, 16, 16*2 )

    y = love.graphics.getHeight() - 16
    BasicLevel.AddWall( 0, y, 500, 16 )
    BasicLevel.AddWall(  550, y, 500, 16 )
    y = y + 100
    BasicLevel.AddWall( 250, y, 300, 16 )
    y = y + 100
    BasicLevel.AddWall( 100, y, 100, 16 )
    y = y + 100
    BasicLevel.AddWall( 250, y, 100, 16 )

    BasicLevel.AddWall( 500, y, 500, 16 )
end

function BasicLevel.AddWall( iX, iY, iW, iH )
    wall  =  Box:New( iX, iY, iW, iH )
    table.insert( BasicLevel.allWalls, wall )
    CollisionPool.AddInertElement( wall )
end


function BasicLevel.Draw()
    love.graphics.setColor( 20, 200, 20 )
    for k,v in pairs( BasicLevel.allWalls ) do
        v:Draw()
    end
end


return  BasicLevel


