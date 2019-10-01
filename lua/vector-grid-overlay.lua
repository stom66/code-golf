function drawGuidelines(grid_size)
	local vlines = {}
	local scale  = self.getScale().x
	local bounds = self.getBoundsNormalized().size
	local size   = math.max(bounds.x, bounds.z)/scale/2

	local function vline(start, finish, color, thickness, rotation)
		local thickness = 0.01
		if (start[1] == finish[1] and start[1]%1==0) 
		or (start[3] == finish[3] and start[3]%1==0) then
			thickness = 0.025
		end
		local line = {
			points = {
				{start[1], start[2], start[3]},
				{finish[1], finish[2], finish[3]},
			},
			color = color or {0, 1, 0},
			thickness = thickness,
			rotation = rotation or {0,0,0}
		}
		return line
	end

	--add general grid lines
	for n=0,size,grid_size do
		--horizontal lines
		table.insert(vlines, vline({0-size, 0.25, n}, {size, 0.25, n}))
		table.insert(vlines, vline({0-size, 0.25, 0-n}, {size, 0.25, 0-n}))
		table.insert(vlines, vline({n, 0.25, 0-size}, {n, 0.25, size}))
		table.insert(vlines, vline({0-n, 0.25, 0-size}, {0-n, 0.25, size}))
	end

	--add central crosshair
	table.insert(vlines, vline({0, 0.25, 0-size}, {0, 0.25, size}, {1,0,0}))
	table.insert(vlines, vline({0-size, 0.25, 0}, {size, 0.25, 0}, {1,0,0}))

	self.setVectorLines(vlines)
end