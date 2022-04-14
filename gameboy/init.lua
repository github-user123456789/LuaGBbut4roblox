
-- TODO: port input system from https://raw.githubusercontent.com/zeta0134/LuaGB/master/love/main.lua
-- NOTE: most games don't work. mabye its due to palette issues? (it might show the intro of an engine and then it'll just go blank or freeze)

local spritemult = 25

-- import utils, script below utils
-- a              : --
local owner = owner
----------------------
-- Services
local HTTP = game:service("HttpService")
-------------
-- UTILS --
local Utils = {}
function Utils:Create(InstData, Props)
	local Obj = Instance.new(InstData[1], InstData[2])
	for k, v in pairs (Props) do
		Obj[k] = v
	end; if Obj:IsA("ImageLabel") or Obj:IsA("ImageButton") then
		Obj.ResampleMode = "Pixelated"
	end
	if Obj:IsA("GuiBase2D") then
		Obj.Size *= spritemult
		Obj.Position *= spritemult
	end
	return Obj
end
-- LEGACY FUNCTIONS WITH ADDED FEATURES
function Utils:ezweld(p, a, b, cf, c1)
	local weld = Instance.new("Weld",p)
	weld.Part0 = a
	weld.Part1 = b
	weld.C0 = cf
	if c1 then weld.C1 = c1 end
    return weld
end
function Utils:NewSound(p, id, pit, vol, loop, autoplay)
	local Sound = Instance.new("Sound",p)
    Sound.Pitch = pit
    Sound.Volume = vol
    Sound.SoundId = "rbxassetid://" ..id
    Sound.Looped = loop
	if autoplay then
    	Sound:Play()
	end
    return Sound
end
-----------
-- LuaNES is written by nico-abram on github
-- You can find the original github here: https://github.com/nico-abram/LuaNES

-- This script is pretty much his emulator but edited to run in roblox
-- apart from the "main.lua" script (Possibly, not sure yet)

local reqmap = {}
local function crequire(str)
	local env = getfenv()
	env[str] = reqmap[str]
	
	return reqmap[str]
end
local function importgit(url)
	print("Running: " ..url)
	local func = loadstring(HTTP:GetAsync(url))
	-- sandbox it to make stuff like bit work
	local sb = getfenv(func)
	sb.require = crequire
	sb.io = {
		open = function(a)
			local str = HTTP:GetAsync(a)
			local file = {}
			function file:read(a)
				return str
			end
			function file:close() return true end
			return file
		end,
	}
	-- return what the function returns
	return func()
end

reqmap["bit"] = bit32

-- /gameboy/graphics/
print("graphics:")
cache = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/graphics/cache.lua"); reqmap["gameboy/graphics/cache"] = cache
palette = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/graphics/palette.lua"); reqmap["gameboy/graphics/palette"] = palette
registers = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/graphics/registers.lua"); reqmap["gameboy/graphics/registers"] = registers
graphics = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/graphics/init.lua"); reqmap["gameboy/graphics"] = graphics

-- /gameboy/z80/
print("z80:")
arithmetic = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/arithmetic.lua"); reqmap["gameboy/z80/arithmetic"] = arithmetic
bitwise = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/bitwise.lua"); reqmap["gameboy/z80/bitwise"] = bitwise
call = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/call.lua"); reqmap["gameboy/z80/call"] = call
cp = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/cp.lua"); reqmap["gameboy/z80/cp"] = cp
inc_dec = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/inc_dec.lua"); reqmap["gameboy/z80/inc_dec"] = inc_dec
jp = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/jp.lua"); reqmap["gameboy/z80/jp"] = jp
ld = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/ld.lua"); reqmap["gameboy/z80/ld"] = ld
registers = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/registers.lua"); reqmap["gameboy/z80/registers"] = registers
rl_rr_cb = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/rl_rr_cb.lua"); reqmap["gameboy/z80/rl_rr_cb"] = rl_rr_cb
stack = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/stack.lua"); reqmap["gameboy/z80/stack"] = stack

z80 = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/z80/init.lua"); reqmap["gameboy/z80"] = z80
-- /gameboy/mbc/

print("mbc:")
mbc1 = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/mbc/mbc1.lua"); reqmap["gameboy/mbc/mbc1"] = mbc1
mbc2 = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/mbc/mbc2.lua"); reqmap["gameboy/mbc/mbc2"] = mbc2
mbc3 = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/mbc/mbc3.lua"); reqmap["gameboy/mbc/mbc3"] = mbc3
mbc5 = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/mbc/mbc5.lua"); reqmap["gameboy/mbc/mbc5"] = mbc5
none = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/mbc/none.lua"); reqmap["gameboy/mbc/none"] = none

-- /gameboy/

print("gameboy:")
io = importgit("https://raw.githubusercontent.com/zeta0134/LuaGB/master/gameboy/io.lua"); reqmap["gameboy/io"] = io

audio = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/audio.lua"); reqmap["gameboy/audio"] = audio
rom_header = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/rom_header.lua"); reqmap["gameboy/rom_header"] = rom_header
cartridge = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/cartridge.lua"); reqmap["gameboy/cartridge"] = cartridge
dma = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/dma.lua"); reqmap["gameboy/dma"] = dma
input = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/input.lua"); reqmap["gameboy/input"] = input
interrupts = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/interrupts.lua"); reqmap["gameboy/interrupts"] = interrupts
memory = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/memory.lua"); reqmap["gameboy/memory"] = memory
opcode_names = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/opcode_names.lua"); reqmap["gameboy/opcode_names"] = opcode_names
timers = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/timers.lua"); reqmap["gameboy/timers"] = timers

gameboy = importgit("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/gameboy/init.lua"); reqmap["gameboy"] = gameboy

-- FAKELOVE --
local love = {}
local image_data = {}
function image_data:setPixel(x, y, r, g, b)
	x -= 1
	y -= 1
	if not image_data[y] then
		image_data[y] = {}
	end
	image_data[y][x] = {r, g, b}
end

love.filesystem = {}
function love.filesystem.read(file)
	print("reading file")
	local data = HTTP:GetAsync(file)
	return data, #data
end
-------------

--- GAMEBOY MAIN SCRIPT ---

print("Loaded gameboy")

local Gameboy = gameboy
local LuaGB = {}
LuaGB.audio_dump_running = false
LuaGB.game_filename = ""
LuaGB.game_path = ""
LuaGB.game_loaded = false
LuaGB.version = "0.1.1"
LuaGB.window_title = ""
LuaGB.save_delay = 0

LuaGB.game_screen_image = nil
LuaGB.game_screen_imagedata = nil

LuaGB.debug = {}
LuaGB.debug.active_panels = {}
LuaGB.debug.enabled = false

LuaGB.emulator_running = false
LuaGB.menu_active = true

LuaGB.screen_scale = 3 / 3

local scale = LuaGB.screen_scale
local width = 160 * scale --width of gameboy screen
local height = 144 * scale --height of gameboy screen

-- FAKEWINDOW --

-- draw monitor lool

local Texts = {}

local Unicode = "██"
local TextScale = 29 / 1.4 / 1.1
local TextOffset = UDim2.new(0, 0, 0, 15)
local Canvas = Vector2.new(1600 / 2 / 1.25 / 1.5, 800 / 2) * 10 / scale
local ScreenSize = Vector3.new(8, 8, 0)
local Following = owner.Character.Torso

local Monitor = Utils:Create({"Part", script}, {
	Size = ScreenSize,
	CanCollide = false,
	Massless = true,
	Transparency = .75,
	Locked = true,
}); Utils:ezweld(Monitor, Monitor, Following, CFrame.new(0, -5, 5))
local Surface = Utils:Create({"SurfaceGui", Monitor}, {
	CanvasSize = Canvas,
	LightInfluence = 0,
	Face = "Back",
	Enabled = false
})

local Clicker = Instance.new("ClickDetector", Monitor)
local Viewers = {}
Clicker.MouseClick:connect(function(Player)
	local ObjectValue = Utils:Create({"ObjectValue", nil}, {
		Name = "BGInstance",
		Value = Surface,
	}); ObjectValue.Parent = NLS([[
		local BG = script.BGInstance.Value
		BG.Enabled = true
		BG.Parent.ClickDetector:Destroy()
		--BG.Parent.LS2Use:Destroy()
	]], Player.Character);
end)

local function NewToRGB(num) -- credit to deafaultyboii1324 on devforum
	return math.clamp(math.ceil(num * 255), 0, 255)
end
local function PaintPixel(color, text)
	return [[<font color="rgb(]].. NewToRGB(color.r).."," ..NewToRGB(color.g) .."," ..NewToRGB(color.b) ..[[)">]] ..text ..[[</font>]]
end
local function PaintPixelRGB(color, text)
	return [[<font color="rgb(]].. color.r .."," ..color.g .."," ..color.b ..[[)">]] ..text ..[[</font>]]
end

Surface.Parent = nil
local Count = 0
local Bounds = game:service("TextService"):GetTextSize(Unicode, TextScale, "RobotoMono", Vector2.new(1000, TextScale))
for Y = 0,height do
	local Text = Utils:Create({"TextBox", Surface}, {
		Size = UDim2.new(1, 0, 0, TextScale),
		Position = UDim2.new(0, 0, 0, Y),
		BackgroundTransparency = 1,
		TextSize = TextScale,
		Text = "",
		--TextXAlignment = "Left",
		RichText = true,
		Font = "RobotoMono",
		ZIndex = 10
	});
	Text.Position = UDim2.new(0, 0, 0, Y * Bounds.Y) + TextOffset; --StreamTitle.Position += UDim2.new(0, 0, 0, Y * Bounds.Y)
	-- Add and color pixels
	for i = 1,width do
		Count += 1
		Color = {r = 255, g = 255, b = 255}
		Text.Text ..= PaintPixelRGB(Color, Unicode)
		LastColor = Color
	end; if Y % 2 == 0 then task.wait() end
	table.insert(Texts, Text)
end; print(height, width, "| screen loaded")
Surface.Parent = Monitor

local LCS = nil
local function UpdateMonitor(image_data)
	--local ScreenData = image
	local ScreenData = image_data
	if not ScreenData then return end
	local Count = 0
	local LastColor = {r = .6, g = .6, b = .6}
	if not LCS then
		LCS = {}
		for i = 1,height do
			LCS[i] = "ok"
		end
	end
	for y,v in pairs (Texts) do
		local TextI = y
		local Text = v
		if Text then
			-- Add and color pixels
			local ColorString = nil
			if LCS[y] ~= Text.Text then
				ColorString = ""
				for i = 1,width do
					Count += 1
					local Color
					if ScreenData[y] then
						Color = ScreenData[y][i]
						if Color then
							Color = {r = Color[1], g = Color[2], b = Color[3]}
							LastColor = Color
						else
							Color = LastColor
						end
					else
						Color = LastColor
					end
					ColorString ..= PaintPixelRGB(Color, Unicode);
				end; Text.Text = ColorString; if y % 5 == 0 then task.wait(); end
			end
			if ColorString then
				LCS[y] = ColorString
			end
		end
	end
end

local function FPSCounter()
	local FPS = Utils:Create({"TextBox", Surface}, {
		Size = UDim2.new(1, 0, 0, 80),
		Position = UDim2.new(0, 0, 1, -80),
		TextScaled = true,
		TextXAlignment = "Left",
		ZIndex = 100,
		Font = "Arcade",
	}); game:service("RunService").Heartbeat:connect(function()
		FPS.Text = "Wait FPS: " ..1/wait() ..[[
		Multiplied by 2: ]] ..2/wait()
	end)
end

FPSCounter()

local Credits = Utils:Create({"TextBox", Surface}, {
	Size = UDim2.new(1, 0, 0, 200),
	Position = UDim2.new(0, 0, 1, -80),
	Text = "LuaGB originally by zeta0134 on github, ported to Roblox by youngmacka123",
	TextScaled = true,
	TextXAlignment = "Left",
	ZIndex = 100,
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(0, 1),
	Font = "Arcade",
});

local Debug = Utils:Create({"TextBox", Surface}, {
	Size = UDim2.new(.25, 0, 0, 600),
	Position = UDim2.new(0, 0, 1, -80 - 200),
	Text = "DEBUG",
	TextSize = 100,
	TextXAlignment = "Left",
	TextYAlignment = "Top",
	ZIndex = 100,
	BackgroundTransparency = .25,
	AnchorPoint = Vector2.new(0, 1),
	Font = "Arcade",
});

local loveupdates = 0
game:service("RunService").Heartbeat:connect(function()
	Debug.Text = [[-----DEBUG-----
LoveUpdate: ]] ..tostring(loveupdates)
end)
----------------
-- make the fake window look cool and nice and stuff --
local BG = Utils:Create({"ImageLabel", Surface}, {
	Size = UDim2.new(1, 0, 1, 0),
	Image = "rbxassetid://9358959157",
	ZIndex = 1,
	BackgroundTransparency = 1,
	ScaleType = "Tile",
	TileSize = UDim2.fromOffset(8*spritemult, 8*spritemult)
})
-------------------------------------------------------
function LuaGB:load_ram()
end
local lastdraw = nil
local lastraw = nil
local shouldwait = 0
function LuaGB:draw_game_screen()
	local pixels = self.gameboy.graphics.game_screen
	--local image_data = self.game_screen_imagedata
	local raw_image_data = self.raw_game_screen_imagedata
	--local stride = image_data:getWidth()
	local stride = width
	
	if not lastdraw then lastdraw = pixels end
	
	local different = 0
	local lastc = {}
	for y = 0, 143 do
		for x = 0, 159 do
			if raw_image_data then
				local pixel = raw_image_data[y*stride+x]
				local v_pixel = pixels[y][x]
				pixel.r = v_pixel[1]
				pixel.g = v_pixel[2]
				pixel.b = v_pixel[3]
				pixel.a = 255
				
				different += 1
			else
				local r = pixels[y][x][1]
				local g = pixels[y][x][2]
				local b = pixels[y][x][3]
				
				local lr = lastdraw[y][x][1]
				local lg = lastdraw[y][x][2]
				local lb = lastdraw[y][x][3]
				
				if r ~= lr and g ~= lg and b ~= lb then
					different += 1
				end
				
				if lastc.r ~= r and lastc.g ~= g and lastc.b ~= b then
					image_data:setPixel(x, y, pixels[y][x][1], pixels[y][x][2], pixels[y][x][3], 255)
				else
					--image_data[y][x] = nil
					image_data:setPixel(x, y, pixels[y][x][1], pixels[y][x][2], pixels[y][x][3], 255)
				end; lastc = {r,g,b}
			end
		end; if y % 200 == 0 then task.wait() end
	end; different += 1
	
	if different > 0 then
		UpdateMonitor(image_data); shouldwait = 100
	else
		--task.wait()
		shouldwait += 50
	end
	lastdraw = pixels
	lastraw = raw_image_data
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
		loveupdates += 1
		coroutine.wrap(function()
		LuaGB.gameboy:run_until_vblank() end)()
	end
	if LuaGB.save_delay > 60 * 10 then
		LuaGB.save_delay = 0
		LuaGB.gameboy.cartridge.external_ram.dirty = false
	end
end

function love.draw()
	LuaGB:draw_game_screen(0, 0, LuaGB.screen_scale)
end

LuaGB:load_game("https://raw.githubusercontent.com/github-user123456789/LuaGBbut4roblox/master/testromtxt/Hungry%20Knight%20v3.txt", "Hungry Knight v3")

while love and script do
	love.update()
	love.draw()
	task.wait()
end
