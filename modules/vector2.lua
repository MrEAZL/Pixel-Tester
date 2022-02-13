local setmetatable = setmetatable

local Vector2 = {}

Vector2.new = function(x, y)
    local newVector = {}

    newVector[1] = x or 0
    newVector[2] = y or 0

    newVector.x = newVector[1]
    newVector.y = newVector[2]

    return newVector
end

return Vector2