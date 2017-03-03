vec = require 'vector'
tools = require 'tools'

Enemy = require 'enemy'
Vision = require 'vision'
Wall = require 'wall'

dot = vec(0, 0)

w = {
    { 0, 0, love.graphics:getWidth(), love.graphics:getHeight(), true },
    { 450, 250, 200, 20 },
    { 200, 250, 200, 20 },
    { 450, 550, 200, 20 },
    { 200, 550, 200, 20 },
}

walls = {}

function love.load()
    for _, wall in pairs(w) do table.insert(walls, Wall.new(unpack(wall))) end
    enemy = Enemy.new(love.graphics:getWidth() / 4, 450)
    enemy.vision:setWalls(walls)
end

function love.update(dt)
    love.window.setTitle(love.timer.getFPS() .. ' fps')
    enemy:update(dt)
    dot.seen = false
    local seen, angle = enemy.vision:inVision(dot)
    if seen then
        dot.seen = true
        enemy.heading = angle
    end
end

function love.draw()
    for _, wall in pairs(walls) do wall:draw() end
    enemy:draw()

    love.graphics.setColor(105, 255 ,255)
    love.graphics.circle('fill', dot.x, dot.y, 5)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'a' then enemy.heading = enemy.heading - 0.05 end
    if key == 'd' then enemy.heading = enemy.heading + 0.05 end
end

function love.mousemoved(x, y)
    dot.x = x
    dot.y = y
end
