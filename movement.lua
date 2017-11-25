
local movement = 
{
	Properties = 
	{
		moveSpeed = { default = 0.5, description = "Movement speed of the ship", suffix = " m/s"},
		rotateSpeed = {default = 0.01, description = "Rotation speed of the ship", suffix = "" },
	},
}
function movement:OnActivate()
	
	-- Set key and mouse bindings 
	self.forwardId = InputEventNotificationId("Forward")
	self.ForwardBus = InputEventNotificationBus.Connect(self, self.forwardId)
	
	self.backwardId = InputEventNotificationId("Backward")
	self.BackwardBus = InputEventNotificationBus.Connect(self, self.backwardId)
	
	self.leftId = InputEventNotificationId("Strafe Left")
	self.LeftBus = InputEventNotificationBus.Connect(self, self.leftId)
	
	self.rightId = InputEventNotificationId("Strafe Right")
	self.RightBus = InputEventNotificationBus.Connect(self, self.rightId)
    
	self.MouseXId = InputEventNotificationId("MouseX")
	self.XInputBus = InputEventNotificationBus.Connect(self, self.MouseXId)	
	
	self.MouseYId = InputEventNotificationId("MouseY")
	self.YInputBus = InputEventNotificationBus.Connect(self, self.MouseYId)	
end

function movement:OnHeld(Inputvalue)
	local rSpeed = self.Properties.rotateSpeed
	local mSpeed = self.Properties.moveSpeed
	local playerDir = TransformBus.Event.GetWorldTM(self.entityId)
	local forwardV = playerDir:GetColumn(1)  -- returns vector ship is facing
	local sideV = playerDir:GetColumn(0) -- returns sideways (right) vector for ship
	local upV = playerDir:GetColumn(2)  -- returns up vector for ship	
	
-- Handle Keyborad Input
	if ( InputEventNotificationBus.GetCurrentBusId() == self.forwardId ) then
		 TransformBus.Event.MoveEntity(self.entityId, forwardV * mSpeed * Inputvalue )
		Debug.Log("Moved Ship Forward")
	elseif (  InputEventNotificationBus.GetCurrentBusId() == self.backwardId ) then
		TransformBus.Event.MoveEntity(self.entityId, -forwardV * mSpeed * Inputvalue )
		Debug.Log("Moved Ship Backward")	
	elseif (  InputEventNotificationBus.GetCurrentBusId() == self.rightId ) then
		TransformBus.Event.MoveEntity(self.entityId, sideV * mSpeed * Inputvalue )
		Debug.Log("Moved Ship Right")
	elseif (  InputEventNotificationBus.GetCurrentBusId() == self.leftId ) then
		TransformBus.Event.MoveEntity(self.entityId, -sideV * mSpeed * Inputvalue )
		Debug.Log("Moved Ship Left")
	end
	
-- Handle Mouse Input	
	if (InputEventNotificationBus.GetCurrentBusId() == self.MouseXId) then
		TransformBus.Event.RotateAroundLocalZ(self.entityId, -Inputvalue * rSpeed)
		Debug.Log("Moved Mouse Up/Down")
	elseif (InputEventNotificationBus.GetCurrentBusId() == self.MouseYId) then
		TransformBus.Event.RotateByX(self.entityId, -Inputvalue * rSpeed)
		Debug.Log("Moved Mouse Left/Right")
	end
end

 
function movement:OnDeactivate()
	self.ForwardBus:Disconnect()
	self.BackwardBus:Disconnect()
	self.LeftBus:Disconnect()
	self.RightBus:Disconnect()
	self.XInputBus:Disconnect()
	self.YInputBus:Disconnect()
end

return movement