local DividingTimer = require("gameboy/audio/dividing_timer")

local VolumeEnvelope = {}

function VolumeEnvelope:new(o)
   o = o or {_volume,_adjustment}
   o.timer = DividingTimer:new()
   o.timer:onReset(function() o:clock() end)
   setmetatable(o, self)
   self.__index = self
   return o
end

function VolumeEnvelope:setVolume(volume)
  self._volume = volume
end

function VolumeEnvelope:volume()
  return self._volume
end

function VolumeEnvelope:setAdjustment(adjustment)
  self._adjustment = adjustment
end

function VolumeEnvelope:adjustment()
  return self._adjustment
end

function VolumeEnvelope:clock()
  if self.timer:period() ~= 8 then
    local volume = self._volume + self._adjustment
    if volume > 15 then
      self._volume = 15
    elseif volume < 0 then
      self._volume = 0
    else
      self._volume = volume
    end
  end
end

return VolumeEnvelope