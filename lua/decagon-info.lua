--lua 5.3

--declare variables
local width = 115 --diagonal across five sides, double radius
local start_pos = { --position of first vertice
  x = 0,
  z = width/2
}

--auto work out some things, set defaults
local edge_length = width / (1 + math.sqrt(5))
local heading = 108 --initial heading. We're going clockwise from the top-most point, so 90+(36/2)
local sin = math.sin
local cos = math.cos
local rad = math.rad
local midpoints = {}
local vertices = {}

local start_rot = 162
for i=1,10 do
    local rot = start_rot + (i*36)
    if rot > 360 then
        rot = rot - 360
    end
    print(rot)
end
    

--function to take 2 tables and return a table of their averages. Uses keys from first t\ble.
local function average(t1, t2) 
    local t = {}
    for k,v in pairs(t1) do
        t[k] = (v + t2[k])/2
    end
    return t
end

--go through each vertice and work out the midpoint
--then work out the end point (which is the next loop start_pos)
for i = 1,10 do
    local target_pos = {
        x = start_pos.x + sin(rad(heading))*edge_length,
        z = start_pos.z + cos(rad(heading))*edge_length
    }
    local midpoint = average(start_pos, target_pos)
    
    table.insert(vertices, target_pos) --add the results
    table.insert(midpoints, midpoint)
    start_pos = target_pos --move to the next point
    heading = heading + 36 --turn a corner, 360/10 sides
end

--print the results
print("Edge length: "..edge_length)
for k,v in ipairs(vertices) do
   -- print("Vertice "..k..": "..v.x..", "..v.z)
end

for k,v in ipairs(midpoints) do
    print("Midpoint "..k..": "..v.x..", "..v.z)
end

