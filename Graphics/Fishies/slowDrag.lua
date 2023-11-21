--[[
    This is a demonstration for reproducing an ANR issue with
    Android Controller.stop()/start().
    Triggering the Android lifecycle while Lua is processing heavy 
    work (as shown below) can replicate the problem.
]]

local sum = 0
local co = coroutine.create(function ()
	for i = 1, 100000 do

		sum = sum + i

		local start_time = os.clock()
		while os.clock() - start_time < 0.1  do
		end

		coroutine.yield(sum)
	end
end)

timer.performWithDelay(10, function()
	for i = 1, 100 do
		if co and coroutine.status(co) ~= "dead" then
			coroutine.resume(co)
		end
	end
end, 0)
