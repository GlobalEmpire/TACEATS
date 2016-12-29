local event = require("event")
local serialize = require("serialization")
local component = require("component")
local turret = component.os_energyturret

local targetX = 1
local targetY = 1
local targetZ = 1
local angleOffset = 1
local targetDistance = 1
local targetIndex = 1

local function computeAngle(targetX, targetY, targetZ, targetDistance)
    -- opposite is X, adjacent is Z
    -- because trig
	if targetZ < 0 then
		if targetX < 0 then
			angleOffset = 270
			targetX = -targetX
			targetZ = -targetZ
		else
			angleOffset = 0
			targetZ = -targetZ
		end
	else
		if targetX < 0 then
			angleOffset = 180
			targetX = -targetX
		else
			angleOffset = 90
		end
	end
	XAngle = math.atan((targetX/targetZ))
	YAngle = math.sin(targetY/targetDistance)
    if angleOffset == 90 or angleOffset == 270 then
	   turret.moveTo(((90-math.deg(XAngle))+angleOffset), math.deg(YAngle))
    else
        turret.moveTo((math.deg(XAngle)+angleOffset), math.deg(YAngle))
    end
end

local function fireControl(junk, targets)
    targets = serialize.unserialize(targets)
    targetIndex = 1
    while targetIndex <= #targets do
        computeAngle(targets[targetIndex]["x"], targets[targetIndex]["y"], targets[targetIndex]["z"], targets[targetIndex]["distance"])
        targetIndex = targetIndex + 1
        turret.fire()
        os.sleep(1)
    end
end
event.listen("TSelected", fireControl)