#!/usr/bin/env lua

local clownmd5 = require "tools.lua.clownmd5"

-- Prevent make.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Make the ROM.
local co = coroutine.create(function() dofile("make.lua") end)
local _, _, abort = assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

if not abort then
	-- Hash the ROM.
	local hash = clownmd5.HashFile("s2built.bin")

	-- Verify the hash against known builds.
	print "-------------------------------------------------------------"

	if hash == "\x4F\x77\x9C\x3E\x0E\xE0\xBD\x06\x86\xAA\xB8\xF9\xE1\x6A\x40\x02" then
		print "ROM is bit-perfect with Prototype."
	else
		print "ROM is NOT bit-perfect with Prototype!"
	end
end
