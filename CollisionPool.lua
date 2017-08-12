Box     = require( "Box" )
Vector  = require( "Vector" )

-- CollisionPool
local CollisionPool = {
    inertElements = {},
    activeElements = {}
}


function CollisionPool.AddInertElement( iElement )
    table.insert( CollisionPool.inertElements, iElement )
end


function CollisionPool.AddActiveElement( iElement )
    table.insert( CollisionPool.activeElements, iElement )
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

    -- Simple tests have to be done in both ways to ensure all detections : projA->iBoxB and iBoxB->projA
    if( projectionA:SimpleCollision( iBoxB ) ) then
        return  true
    end
    if( iBoxB:SimpleCollision( projectionA ) ) then
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