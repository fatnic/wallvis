local tools = {}

tools.normaliseRadian = function(rad)
    local result = rad % (2 * math.pi)
    if result < 0 then result = result + (2 * math.pi) end
    return result
end

tools.isAngleBetween = function(angle, min, max)
    local rad = math.pi * 2
    local angle = (rad + (angle % rad)) % rad
    local min = (rad + min) % rad
    local max = (rad + max) % rad
    if (min < max) then return min <= angle and angle <= max end
    return min <= angle or angle <= max
end

tools.lineBoundingBox = function(a, b)
    local x = math.min(a.x, b.x)
    local y = math.min(a.y, b.y)
    local w = math.max(a.x, b.x) - x
    local h = math.max(a.y, b.y) - y
    return { position = vec(x, y), width = w, height = h }
end

tools.doLinesIntersect = function(ray, segment)
    local a, b = ray.a, ray.b
    local c, d = segment.a, segment.b

    local L1 = {X1=a.x,Y1=a.y,X2=b.x,Y2=b.y}
    local L2 = {X1=c.x,Y1=c.y,X2=d.x,Y2=d.y}

    local d = (L2.Y2 - L2.Y1) * (L1.X2 - L1.X1) - (L2.X2 - L2.X1) * (L1.Y2 - L1.Y1)

    if (d == 0) then return false end

    local n_a = (L2.X2 - L2.X1) * (L1.Y1 - L2.Y1) - (L2.Y2 - L2.Y1) * (L1.X1 - L2.X1)
    local n_b = (L1.X2 - L1.X1) * (L1.Y1 - L2.Y1) - (L1.Y2 - L1.Y1) * (L1.X1 - L2.X1)

    local ua = n_a / d
    local ub = n_b / d

    if (ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1) then
        local x = L1.X1 + (ua * (L1.X2 - L1.X1))
        local y = L1.Y1 + (ua * (L1.Y2 - L1.Y1))
        return true, vec(x, y)--{x=x, y=y}
    end

    return false
end

return tools
