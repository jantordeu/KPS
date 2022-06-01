--[[
AutoTurn Module
]]--

function _JumpOrAscendStart()
   secured = false
   while not secured do
      RunScript([[
         for index = 1, 100 do
            if not issecure() then
               return
            end
         end
         secured = true
         JumpOrAscendStart()
      ]])
   end
end

function _CameraOrSelectOrMoveStop()
   secured = false
   while not secured do
      RunScript([[
         for index = 1, 100 do
            if not issecure() then
               return
            end
         end
         secured = true
         CameraOrSelectOrMoveStop()
      ]])
   end
end

function _CameraOrSelectOrMoveStart()
   secured = false
   while not secured do
      RunScript([[
         for index = 1, 100 do
            if not issecure() then
               return
            end
         end
         secured = true
         CameraOrSelectOrMoveStart()
      ]])
   end
end

function _TurnLeftStart()
   secured = false
   while not secured do
      RunScript([[
         for index = 1, 100 do
            if not issecure() then
               return
            end
         end
         secured = true
         TurnLeftStart()
      ]])
   end
end

function _TurnLeftStop()
   secured = false
   while not secured do
      RunScript([[
         for index = 1, 100 do
            if not issecure() then
               return
            end
         end
         secured = true
         TurnLeftStop()
      ]])
   end
end

local LOG = kps.Logger(kps.LogLevel.INFO)

kps.events.register("UI_ERROR_MESSAGE", function(event_type, event_error)
      if kps.enabled and kps.autoTurn and (event_error == ERR_BADATTACKFACING) then
         if kps["env"].player.isMoving == false then
            if kps.timers.check("Facing") == 0 then kps.timers.create("Facing", 1) end
            TurnLeftStart()
            CameraOrSelectOrMoveStart()
            C_Timer.After(1,function() TurnLeftStop() end)
            C_Timer.After(1,function() CameraOrSelectOrMoveStop() end)
         end
      end
end)

kps.events.register("UNIT_SPELLCAST_START", function(...)
      if kps.autoTurn and kps.timers.check("Facing") > 0 then
         local unitID = select(1,...)
         if unitID == "player" then 
            TurnLeftStop()
            CameraOrSelectOrMoveStop()
         end
      end
end)