local color = {}

color.new = function(r, g, b, a)
    local newColor = {}

    newColor[1] = r or 0
    newColor[2] = g or 0
    newColor[3] = b or 0
    newColor[4] = a or 1

    newColor.R = newColor[1]
    newColor.G = newColor[2]
    newColor.B = newColor[3]
    newColor.a = newColor[4]

    return newColor
end

return color