local vector2 = require("modules.vector2")
local pixel = {}

function pixel.new(position, color)
    local newPixel = {}

    newPixel.position = position
    newPixel.color = color
    
    return newPixel
end

return pixel