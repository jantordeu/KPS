--[[
AutoTurn Module
]]--

local LOG = kps.Logger(kps.LogLevel.INFO)

kps.events.register("UI_ERROR_MESSAGE", function(event_type, event_error)
      if kps.enabled and kps.autoTurn and (event_error == SPELL_FAILED_UNIT_NOT_INFRONT) then -- or (event_error == ERR_BADATTACKFACING)
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