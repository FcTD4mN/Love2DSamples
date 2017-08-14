Bullet          = require( "Bullet" )
Camera          = require( "Camera" )
CollisionPool   = require( "CollisionPool" )

local ProjectilePool = {
    allProjectiles = {}
}


function  ProjectilePool:Type()
    return  "ProjectilePool"
end


function  ProjectilePool.Add( iProjectile )
    table.insert( ProjectilePool.allProjectiles, iProjectile )
end


function  ProjectilePool.Drain()
    for k,v in pairs( ProjectilePool.allProjectiles ) do
        if( v:IsWithinWindow() == false ) then
            CollisionPool.RemoveActiveElement( v )
            table.remove( ProjectilePool.allProjectiles, k )
        end
    end
end

function ProjectilePool.ApplyVectors()
    for k,v in pairs( ProjectilePool.allProjectiles ) do
        v:ApplyDirectionVector()
    end
end


function ProjectilePool.Move()
    for k,v in pairs( ProjectilePool.allProjectiles ) do
        v:Move()
    end
end


function  ProjectilePool.Draw()
    for k,v in pairs ( ProjectilePool.allProjectiles ) do
        v:Draw()
    end
end

return  ProjectilePool