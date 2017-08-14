
local Camera = {
    x = 0,
    y = 0
}


function  Camera.MapToScreen( iX, iY )
    return  iX - Camera.x, iY - Camera.y
end


function  Camera.MapToWorld( iX, iY )
    return  iX + Camera.x, iY + Camera.y
end


return  Camera