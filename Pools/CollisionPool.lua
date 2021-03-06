Box     = require( "Objects/Box" )
Vector  = require( "Utilities/Vector" )

-- CollisionPool
local CollisionPool = {
    inertElements = {},
    activeElements = {},
    projectiles = {} -- We need a separate pool for projectiles, because there are many of them, and they don't test collision between each other
}


function CollisionPool.AddInertElement( iElement )
    table.insert( CollisionPool.inertElements, iElement )
end


function CollisionPool.AddActiveElement( iElement )
    table.insert( CollisionPool.activeElements, iElement )
end


function CollisionPool.AddProjectile( iProjectile )
    table.insert( CollisionPool.projectiles, iProjectile )
end


function CollisionPool.RemoveInertElement( iElement )
    for k,v in pairs( CollisionPool.inertElements ) do
        if( v == iElement ) then
            table.remove( CollisionPool.inertElements, k )
        end
    end
end


function CollisionPool.RemoveActiveElement( iElement )
    for k,v in pairs( CollisionPool.activeElements ) do
        if( v == iElement ) then
            table.remove( CollisionPool.activeElements, k )
        end
    end
end


function CollisionPool.RemoveProjectile( iProjectile )
    for k,v in pairs( CollisionPool.projectiles ) do
        if( v == iProjectile ) then
            table.remove( CollisionPool.projectiles, k )
        end
    end
end


function  CollisionPool.RunCollisionTests()
    for k,v in pairs( CollisionPool.activeElements ) do

        for k2,v2 in pairs( CollisionPool.inertElements ) do
            if( CollisionPool.CheckCollisionAB( v, v2 ) ) then
                side = CollisionPool.GetCollisionSide( v, v2 )
                v:Collide( v2, side )
            end
        end

        for k2,v2 in pairs( CollisionPool.activeElements ) do
            if( v ~= v2 ) and ( CollisionPool.CheckCollisionAB( v, v2 ) ) then
                side = CollisionPool.GetCollisionSide( v, v2 )
                v:Collide( v2, side )
            end
        end

    end

    for k,v in pairs( CollisionPool.projectiles ) do

        for k2,v2 in pairs( CollisionPool.inertElements ) do
            if( CollisionPool.CheckCollisionAB( v, v2 ) ) then
                v:Collide( v2, "doesntmatter" ) -- Here, we don't care what side it was, we just deal the damages
            end
        end

        for k2,v2 in pairs( CollisionPool.activeElements ) do
            if( CollisionPool.CheckCollisionAB( v, v2 ) ) then
                v:Collide( v2, "doesntmatter" ) -- Here, we don't care what side it was, we just deal the damages
            end
        end

    end

end


function  CollisionPool.CheckCollisionAB( iBoxA, iBoxB )
    -- Is A going to collide with B
    projectionA = Box:New( iBoxA.x + iBoxA.motionVector.x, iBoxA.y + iBoxA.motionVector.y, iBoxA.w, iBoxA.h )

    -- Skip large distances
    vectorA = Vector:New( projectionA.w, projectionA.h )
    vectorB = Vector:New( iBoxB.w, iBoxB.h )
    xToX    = Vector:New( projectionA.x - iBoxB.x, projectionA.y - iBoxB.y )

    if( xToX:LengthSquared() > vectorA:LengthSquared() + vectorB:LengthSquared() ) then
        return  false
    end

    if( projectionA:SimpleCollision( iBoxB ) ) then
        return  true
    end

    return  false
end


function  CollisionPool.GetCollisionSide( iBoxA, iBoxB )
    projectionA = Box:New( iBoxA.x + iBoxA.motionVector.x, iBoxA.y + iBoxA.motionVector.y, iBoxA.w, iBoxA.h )

    if( iBoxA.x + iBoxA.w < iBoxB.x ) and ( projectionA.x + projectionA.w >= iBoxB.x ) then
        return  "Right"
    elseif( iBoxA.x > iBoxB.x + iBoxB.w ) and ( projectionA.x <= iBoxB.x + iBoxB.w ) then
        return  "Left"
    elseif( iBoxA.y + iBoxA.h < iBoxB.y ) and ( projectionA.y + projectionA.h >= iBoxB.y ) then
        return  "Bottom"
    elseif( iBoxA.y > iBoxB.y + iBoxB.h ) and ( projectionA.y <= iBoxB.y + iBoxB.h ) then
        return  "Top"
    end

    -- Shouldn't get here, it means this call of GetCollisionSide was useless
    return  "None?"
end


return  CollisionPool