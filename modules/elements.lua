local element = require("modules.element")
local color = require("modules.color")
local elements = {}

local waterUpdate = function(self)
    local neighbors = {vector2.new(self.position.x, self.position.y+1), vector2.new(self.position.x+1, self.position.y), vector2.new(self.position.x-1, self.position.y)}

    if self.grid:isEmpty(neighbors[1]) then
        self:replace(neighbors[1])
    elseif self.grid:isEmpty(neighbors[2]) then
        self:replace(neighbors[2])
    elseif self.grid:isEmpty(neighbors[3]) then
        self:replace(neighbors[3])
    end
end

local mudUpdate = function(self)
    local neighbors = {vector2.new(self.position.x, self.position.y+1), vector2.new(self.position.x+1, self.position.y), vector2.new(self.position.x-1, self.position.y)}

    if self.grid:isEmpty(neighbors[1]) then
        self:replace(neighbors[1])
    elseif self.grid:getId(neighbors[1]) == self.id then
        if self.grid:isEmpty(neighbors[2]) then
            self:replace(neighbors[2])
        elseif self.grid:isEmpty(neighbors[3]) then
            self:replace(neighbors[3])
        end
    end
end

local sandUpdate = function(self)
    local neighbors = {vector2.new(self.position.x, self.position.y+1), vector2.new(self.position.x+1, self.position.y), vector2.new(self.position.x-1, self.position.y), vector2.new(self.position.x+1, self.position.y+1), vector2.new(self.position.x-1, self.position.y+1)}

    if self.grid:isEmptyOrPenetrable(neighbors[1]) then
        self:replace(neighbors[1])
    elseif self.grid:isEmpty(neighbors[4]) or self.grid:isEmpty(neighbors[5]) then
        if self.grid:isEmpty(neighbors[2]) then
            self:replace(neighbors[2])
        elseif self.grid:isEmpty(neighbors[3]) then
            self:replace(neighbors[3])
        end
    end
end

local empty = function() end

local colors = {["water"] = color.new(0, 0, 0.5), ["mud"] = color.new(0.15, 0.1, 0.1), ["sand"] = color.new(0.5, 0.5, 0), ["stone"] = color.new(0.2, 0.2, 0.2)}

elements.fill = function(self, grid, pixel, x1, x2, y1, y2)
    if not self[pixel] then return end

    for indexX = x1, x2 - 1 do
        for indexY = y1, y2 - 1 do
            if not grid:isEmpty(indexX, indexY) then goto continue end
            self[pixel](grid, vector2.new(indexX, indexY))

            ::continue::
        end
    end
end

elements.water = function(grid, pos)
    local newElement = element.new(pos, colors.water, waterUpdate, 1, true, true)
    newElement:init(grid)

    return newElement
end

elements.mud = function(grid, pos)
    local newElement = element.new(pos, colors.mud, mudUpdate, 2, false, true)
    newElement:init(grid)

    return newElement
end

elements.sand = function(grid, pos)
    local newElement = element.new(pos, colors.sand, sandUpdate, 3, false, true)
    newElement:init(grid)

    return newElement
end

elements.stone = function(grid, pos)
    local newElement = element.new(pos, colors.stone, empty, 0, false, false)
    newElement:init(grid)

    return newElement
end

return elements