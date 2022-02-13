local elements = require("modules.elements")
local vector2 = require("modules.vector2")
local grid = {}

grid.new = function(X, Y)
    local newGrid = {}

    newGrid.SizeX = X
    newGrid.SizeY = Y
    newGrid.Pixels = {}

    newGrid.setPixel = function(self, pixel, x, y)
        if type(x) == "table" and x.y and x.y then
            if x.y > self.SizeY or x.x > self.SizeX then return end
            if not self.Pixels[x.x + 1] then self.Pixels[x.x + 1] = {} end
            self.Pixels[x.x + 1][x.y + 1] = pixel
        elseif type(x) == "table" and x.position then
            if x.y > self.SizeY or x.position.x > self.SizeX then return end
            if not self.Pixels[x.position.x + 1] then self.Pixels[x.position.x + 1] = {} end
            self.Pixels[x.position.x + 1][x.position.y + 1] = pixel
        elseif type(x) == "number" and type(y) == "number" then
            if y > self.SizeY or x > self.SizeX then return end
            if not self.Pixels[x + 1] then self.Pixels[x + 1]  = {} end
            self.Pixels[x + 1][y + 1] = pixel
        end
    end

    newGrid.fillCoordinates = function(self, pixel, x1, x2, y1, y2)
        if x1 > self.SizeX or x2 > self.SizeX or y1 > self.SizeY or y2 > self.SizeY then return end
        if not self.Pixels[x1 + 1] then self.Pixels[x1 + 1] = {} end
        if not self.Pixels[x2 + 1] then self.Pixels[x2 + 1] = {} end

        for indexX = x1, x2 - 1 do
            for indexY = y1, y2 - 1 do
                self:setPixel(pixel, indexX, indexY)
            end
        end
    end

    newGrid.deletePixel = function(self, x, y)
        if not x then return end

        if type(x) == "table" and x.x and x.y then
            if self.Pixels[x.x + 1] then
                self.Pixels[x.x + 1][x.y + 1] = nil
            end
        elseif type(x) == "table" and x.position then
            if self.Pixels[x.position.x + 1] then
                self.Pixels[x.position.x + 1][x.position.y + 1] = nil
            end
        elseif type(x) == "number" and type(y) == "number" then
            if self.Pixels[x + 1] then
                self.Pixels[x + 1][y + 1] = nil 
            end
        end
    end

    newGrid.replacePixel = function(self, x1, x2, y1, y2)
        local pixel1 = self:getPixel(x1, y1)
        local pixel2 = self:getPixel(x2, y2)
        local pixel1Position = {}

        if pixel1 then
            pixel1Position = pixel1.position
        end

        self:setPixel(pixel1, x2, y2)
        self:setPixel(pixel2, pixel1Position)
    end

    newGrid.getPixel = function(self, x, y)
        if type(x) == "table" and x.x and x.y then
            if self.Pixels[x.x + 1] then
                return self.Pixels[x.x + 1][x.y + 1]
            end
        elseif type(x) == "table" and x.position then
            return x
        elseif type(x) == "number" and type(y) == "number" then
            if self.Pixels[x + 1] then
                return self.Pixels[x + 1][y + 1]
            end
        end
    end

    newGrid.clear = function(self)
        self.Pixels = {}
    end

    newGrid.isEmpty = function(self, x, y)
        local pixel = self:getPixel(x, y)
        return pixel == nil
    end

    newGrid.isPenetrable = function(self, x, y)
        local pixel = self:getPixel(x, y)
        return pixel.penetrable
    end

    newGrid.isEmptyOrPenetrable = function(self, x, y)
        return self:isEmpty(x, y) or self:isPenetrable(x, y)
    end

    newGrid.getId = function(self, x, y)
        local pixel = self:getPixel(x, y)
        return pixel.id
    end

    return newGrid
end

return grid