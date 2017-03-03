local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y)
    local self = setmetatable({}, Enemy)
    self.position = vec(x, y)
    self.heading = 0
    self.vision = Vision.new(self.position, self.heading, 90, 500)
    return self
end

function Enemy:update(dt)
    self.vision:setHeading(self.heading)
end

function Enemy:draw()
    -- enemy circle
    love.graphics.setColor(255, 255, 255, 100)
    love.graphics.circle('fill', self.position.x, self.position.y, 10)
    -- heading line
    love.graphics.setColor(50, 50, 100)
    local hx, hy = math.cos(self.heading), math.sin(self.heading)
    love.graphics.line(self.position.x, self.position.y, self.position.x + hx * 30, self.position.y + hy * 30)
    -- vision
    self.vision:draw(self.position.x, self.position.y)
end

return Enemy
