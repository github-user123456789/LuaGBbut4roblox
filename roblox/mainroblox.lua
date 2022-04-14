function LuaGB:load_ram()
end
function LuaGB:draw_game_screen()
	local pixels = self.gameboy.graphics.game_screen
	--local image_data = self.game_screen_imagedata
	local raw_image_data = self.raw_game_screen_imagedata
	--local stride = image_data:getWidth()
	local stride = width
	
	local lastr, lastg, lastb = -2,-2,-2
	for y = 0, 143 do
		for x = 0, 159 do
			if raw_image_data then
				local pixel = raw_image_data[y*stride+x]
				local v_pixel = pixels[y][x]
				pixel.r = v_pixel[1]
				pixel.g = v_pixel[2]
				pixel.b = v_pixel[3]
				pixel.a = 255
			else
				local r = pixels[y][x][1]
				local g = pixels[y][x][2]
				local b = pixels[y][x][3]
				
				image_data:setPixel(x, y, pixels[y][x][1], pixels[y][x][2], pixels[y][x][3], 255)
			end
		end; if y % 1000 == 0 then task.wait() end
	end
	UpdateMonitor(image_data)
end

function LuaGB:load_game(game_path, specifygamename)
	self:reset()

	--local file_data, size = love.filesystem.read(game_path)
	local file_data, size = love.filesystem.read(game_path)
	if file_data then
		self.game_path = game_path
		self.game_filename = game_path:sub(#"https:// ")
		if not specifygamename then
			while string.find(self.game_filename, "/") do
				self.game_filename = string.sub(self.game_filename, string.find(self.game_filename, "/") + 1)
			end
		else
			self.game_filename = specifygamename
		end

		self.gameboy.cartridge.load(file_data, size)
		self:load_ram()
		self.gameboy:reset()

		print("Successfully loaded ", self.game_filename)
	else
		print("Couldn't open ", game_path, " giving up.")
		return
	end
	
	self.window_title = "LuaGB v" .. self.version .. " - " .. self.gameboy.cartridge.header.title
	--love.window.setTitle(self.window_title)

	self.menu_active = false
	self.emulator_running = true
	self.game_loaded = true
end

function LuaGB:reset()
	self.gameboy = Gameboy.new{}
	self.gameboy:initialize()
	self.gameboy:reset()
	--self.gameboy.audio.on_buffer_full(self.play_gameboy_audio)
	self.audio_dump_running = false
	self.gameboy.graphics.palette_dmg_colors = palette
end

loveupdates = 0
function love.update()
	if LuaGB.emulator_running then
		--coroutine.wrap(function() LuaGB.gameboy:run_until_vblank() end)()
		loveupdates += 1
		coroutine.wrap(function() --print("attempting to update | update number: ", loveupdates);
		LuaGB.gameboy:run_until_vblank() end)()
	end
	--[[
	if LuaGB.gameboy.cartridge.external_ram.dirty then
		LuaGB.save_delay = LuaGB.save_delay + 1
	end
	]]
	if LuaGB.save_delay > 60 * 10 then
		LuaGB.save_delay = 0
		LuaGB.gameboy.cartridge.external_ram.dirty = false
		--LuaGB:save_ram()
	end
end

function love.draw()
	LuaGB:draw_game_screen(0, 0, LuaGB.screen_scale)
end

LuaGB:load_game("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/testromtxt/Hungry%20Knight%20v3.txt", "Hungry Knight v3")
--LuaGB:load_game("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/testromtxt/lastcrownwarriorsdemo.txt", "Last Crown Warriors")
--LuaGB:load_game("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/testromtxt/ClubPenguinDemakeDemo.txt", "Club Penguin Demake")
-- RUN LOOPS N STUFF
while love and script do
	love.update()
	love.draw()
	task.wait()
end
