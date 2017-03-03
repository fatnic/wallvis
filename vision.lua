local Vision = {}
Vision.__index = Vision

function Vision.new(origin, heading, fov, distance)
    local self = setmetatable({}, Vision)
    self.origin = origin
    self.heading = heading
    self.fov = fov
    self:calcFoV()
    self.distance = distance
    self.walls = nil
    return self
end

function Vision:setHeading(heading)
    self.heading = heading
    self:calcFoV()
end

function Vision:setOrigin(origin)
    self.origin = origin
end

function Vision:setWalls(walls)
    self.walls = walls
end

function Vision:calcFoV()
    self.minFoV = self.heading - tools.normaliseRadian(math.rad(self.fov / 2))
    self.maxFoV = self.heading + tools.normaliseRadian(math.rad(self.fov / 2))
end

function Vision:draw()
    love.graphics.setColor(120, 120, 0)
    love.graphics.arc('line', self.origin.x, self.origin.y, self.distance, self.maxFoV, self.minFoV, 10)
end

function Vision:findClosestInterect(point)
    local ray = { a = self.origin, b = point }
    local closestIntersect = ray.b
    closestIntersect.distance = ray.a:dist(ray.b)

    for _, wall in pairs(self.walls) do
        for _, segment in pairs(wall.segments) do
            local found, intersect = tools.doLinesIntersect(ray, segment)
            if found then
                local distance = ray.a:dist(intersect)
                if distance < closestIntersect.distance then
                    closestIntersect = intersect
                    closestIntersect.distance = distance
                end
            end
        end
    end
    return closestIntersect
end

function Vision:inVision(point)
    -- point too far away
    if self.origin:dist(point) > self.distance then return false end
    
    -- point with min/max FoV
    local pa = tools.normaliseRadian(math.atan2(point.y - self.origin.y, point.x - self.origin.x))
    if tools.isAngleBetween(pa, self.minFoV, self.maxFoV) then 
        if self.walls then
            intersect = self:findClosestInterect(point)
            if self.origin:dist(intersect) < self.origin:dist(point) then return false end
            return true, pa
        end
        -- if no walls then true
        return true, pa
    end

    return false
end

return Vision
