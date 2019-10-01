-- lua 5.3
--
--
-- working out the angle between two objects
--
-- inputs
local a = {
    x = 0,
    y = 0
}
local b = {
    x = 1,
    y = 1
}
--
-- work out result
local rad = math.atan2(b.x - a.x, b.y - a.y)
local deg = math.deg(rad)
--
-- print results
local msg = "Point B is at a "..deg.." angle from point A\n\n"
print(msg)
--
--
--
-- working out the x/y position for a given radius(distance) and angle, from a source
--
-- inputs
local source = {
    x = 0,
    y = 0
}
local distance = 10
local angle = 45
--
-- work out result
local target =  {
    x = source.x + math.cos(math.rad(angle))*distance,
    y = source.y + math.sin(math.rad(angle))*distance
}
--
--print results
local msg = "The point "..distance.." units at "..angle.."d is at position "..target.x..":"..target.y
print(msg)