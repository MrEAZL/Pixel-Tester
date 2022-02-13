local abs = math.abs
local floor = math.floor
local min = math.min
local max = math.max
local pairs = pairs

local currentElement = "stone"
local elementsList = {"stone", "water", "mud", "sand"}

local brushSize = 2
local width, height = 500, 500

local currentGrid = {}
local pixelSize = 0


function love.load()
    vector2 = require("modules.vector2")
    color = require("modules.color")
    grid = require("modules.grid")
    pixel = require("modules.pixel")
    elements = require("modules.elements")

    love.window.setTitle("Pixel Tester")
    love.window.setMode(width, height)
    
    currentGrid = grid.new(200, 200)
    
    pixelSize = 1 / currentGrid.SizeY * height
    
    love.graphics.setBackgroundColor(0.4, 0.4, 0.4)
    
    love._openConsole()
end

local function drawPixel(position, color, mode, size)
    love.graphics.setColor(unpack(color or {0, 0, 0}))
    return love.graphics.rectangle(mode or "fill", position.x - (size and (size * pixelSize)/2 or 0), position.y - (size and (size * pixelSize)/2 or 0), size and size*pixelSize or pixelSize, size and size*pixelSize or pixelSize)
end

local function getMousePosition()
    local x, y = love.mouse.getPosition()
    local position = vector2.new(x, y)
    
    return position
end

local function getMousePositionOnGrid()
    local position = getMousePosition()
    position.x = floor((position.x / width) * (currentGrid.SizeX))
    position.y = floor((position.y / height) * (currentGrid.SizeY))

    return position
end

function love.keypressed(key)
    if key:lower() == "f" then
        currentGrid:clear()
    elseif tonumber(key) and elementsList[tonumber(key)] then
        currentElement = elementsList[tonumber(key)]
        print(string.format("Selected element \"%s\"", currentElement))
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        brushSize = min(10, brushSize + 2)
    elseif y < 0 then
        brushSize = max(2, brushSize - 2)
    end
end

local function handleMouse()
    local position = getMousePositionOnGrid()
    local half = floor(brushSize/2)
    
    if love.mouse.isDown(1) then
        elements:fill(currentGrid, currentElement, position.x - half, position.x + half, position.y - half, position.y + half)
    elseif love.mouse.isDown(2) then
        currentGrid:fillCoordinates(nil, position.x - half, position.x + half, position.y - half, position.y + half)
    end
end

local function drawPixels()
    while true do
        local mousePosition = getMousePosition()
        local pixelPosition = {}

        for indexX, pixels in pairs(currentGrid.Pixels) do
            for indexY, pixel in pairs(pixels) do
                pixelPosition = vector2.new((indexX - 1) * pixelSize, (indexY - 1) * pixelSize)
                drawPixel(pixelPosition, pixel.color)
            end
        end

        drawPixel(mousePosition, {1, 0, 0}, "line", brushSize)
        coroutine.yield()
    end
end
local draw = coroutine.create(drawPixels)

local function updatePixels(dt)
    while true do
        handleMouse()
        
        for indexX, pixels in pairs(currentGrid.Pixels) do
            for indexY, pixel in pairs(pixels) do
                pixel:update(dt)
                pixel.position = vector2.new(indexX - 1, indexY - 1)
            end
        end
        dt = coroutine.yield()
    end
end
local update = coroutine.create(updatePixels)

function love.update(dt)
    coroutine.resume(update, dt)
end

function love.draw()
    coroutine.resume(draw)
end

function love.quit()
    return true
end