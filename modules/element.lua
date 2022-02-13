local pixel = require("modules.pixel")
local vector2 = require("modules.vector2")
local element = {}

local init = function(self, grid)
    self.grid = grid
    self.grid:setPixel(self, self.position)
end

local replace = function(self, x, y)
    self.grid:replacePixel(self, x, y)
end

function element.new(position, color, update, id, penetrable, moveable)
    local newElement = pixel.new(position, color)
    newElement.id = id or -1
    newElement.penetrable = penetrable or false
    newElement.moveable = moveable or true

    newElement.init = init
    newElement.replace = replace
    newElement.update = update

    return newElement
end

return element