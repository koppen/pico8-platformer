Particle = {}
Particle.__index = Particle

function Particle:spawn(pos, radius, color, life, vx, vy, gravity)
 local p = Particle:new()

 p.x = pos.x
 p.y = pos.y
 p.vx = vx
 p.vy = vy
 p.gravity = gravity or 0
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

 self.vy += self.gravity
end

function Particle:is_dead()
 -- Return true if the particle should be removed
 return self.life <= 0
end

function Particle:draw()
 -- Draw the particle here
 circfill(self.x, self.y, self.radius, self.color)
end
