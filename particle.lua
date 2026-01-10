Particle = {}
Particle.__index = Particle

function Particle:spawn(x, y, radius, color, life, vx, vy)
 local p = Particle:new()

 p.x = x
 p.y = y
 p.vx = vx
 p.vy = vy
 p.radius = radius
 p.color = color
 p.life = life -- seconds

 add(particles, p)
end

function Particle:new()
 local self = setmetatable({}, Particle)

 return self
end

function Particle:update()
 -- Update particle logic here
 self.life -= 0.016 -- assuming 60 FPS

 self.x += self.vx
 self.y += self.vy
end

function Particle:is_dead()
 -- Return true if the particle should be removed
 return self.life <= 0
end

function Particle:draw()
 -- Draw the particle here
 circfill(self.x, self.y, self.radius, self.color)
end
