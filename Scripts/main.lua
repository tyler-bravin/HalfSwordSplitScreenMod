-- Half Sword Split Screen Mod v0.2 by massclown
-- This is heavily based on UE4SS SplitScreenMod
-- https://github.com/massclown/HalfSwordSplitScreenMod
-- Requirements: UE4SS 2.5.2 (or newer)
local UEHelpers = require("UEHelpers")

-- Importing functions to the global namespace of this mod just so that we don't have to retype 'UEHelpers.' over and over again.
local GetGameplayStatics = UEHelpers.GetGameplayStatics
local GetGameMapsSettings = UEHelpers.GetGameMapsSettings
local GetWorldContextObject = UEHelpers.GetWorldContextObject
-- Set this value to true if you wish for the first controller to control player 1, or false if you want the first controller to control player 2
local bOffsetGamepad = true
-- 0 is default horizontal (top and bottom), 1 is vertical (left and right)
local TwoPlayerSplitscreenLayout = 0 -- Keep this as 0 (horizontal) or 1 (vertical)

local PlayerControllerTable = {}

------------------------------------------------------------------------------
function Log(Message)
    print("[HalfSwordSplitScreenMod] " .. Message)
end

function Logf(...)
    print("[HalfSwordSplitScreenMod] " .. string.format(...))
end

function ErrLog(Message)
    print("[HalfSwordSplitScreenMod] [ERROR] " .. Message)
end

function ErrLogf(...)
    print("[HalfSwordSplitScreenMod] [ERROR] " .. string.format(...))
end

function string:contains(sub)
    return self:find(sub, 1, true) ~= nil
end

function string:starts_with(start)
    return self:sub(1, #start) == start
end

function string:ends_with(ending)
    return ending == "" or self:sub(- #ending) == ending
end

------------------------------------------------------------------------------
-- TEMPORARILY COMMENTING OUT INPUT REMAPPING
-- function RemapAllIKDBs()
--     local IKDBInstances = FindAllOf("InputKeyDelegateBinding")
--     if not IKDBInstances then
--         print("No instances of 'InputKeyDelegateBinding' were found\n")
--     else
--         for Index, IKDBInstance in pairs(IKDBInstances) do
--             Logf("Remapping for InputKeyDelegateBinding instance [%d] %s\n", Index, IKDBInstance:GetFullName())
--             RemapIKDBForGamepad(IKDBInstance)
--         end
--     end
-- end

------------------------------------------------------------------------------
-- TEMPORARILY COMMENTING OUT INPUT REMAPPING
-- function RemapIKDBForGamepad(InputKeyDelegateBindingInstance)
--     Logf("bindings object [%s]\n", tostring(InputKeyDelegateBindingInstance))
--     if InputKeyDelegateBindingInstance == nil or not InputKeyDelegateBindingInstance:IsValid() then
--         ErrLogf("Could not find InputKeyDelegateBinding\n")
--     else
--         ---@class TArray
--         local bindingArray = InputKeyDelegateBindingInstance['InputKeyDelegateBindings']
--         bindingArray:ForEach(function(Index, Element)
--             local this_binding = Element:get()
--             -- Logf("Binding [%s] %s\n", Index, this_binding)
--             local FunctionNameToBind_str = this_binding['FunctionNameToBind']:ToString()
--             local ActionGamepadMapping = {
--                 -- left hand pickup/drop
--                 ["InpActEvt_Q_K2Node_InputKeyEvent_4"] = "Gamepad_LeftShoulder",
--                 ["InpActEvt_Q_K2Node_InputKeyEvent_5"] = "Gamepad_LeftShoulder",
--                 -- right hand pickup/drop
--                 ["InpActEvt_E_K2Node_InputKeyEvent_2"] = "Gamepad_RightShoulder",
--                 ["InpActEvt_E_K2Node_InputKeyEvent_3"] = "Gamepad_RightShoulder",
--                 -- swap hands
--                 ["InpActEvt_X_K2Node_InputKeyEvent_8"] = "Gamepad_FaceButton_Left",
--                 -- inventory does not work properly, stays on forever
--                 --["InpActEvt_R_K2Node_InputKeyEvent_9"] = "Gamepad_FaceButton_Right",
--             }
--             local GamepadKey = ActionGamepadMapping[FunctionNameToBind_str]
--             if GamepadKey ~= nil then
--                 this_binding["InputChord"]["Key"]["KeyName"] = FName(GamepadKey)
--                 local luatable_binding = {
--                     FunctionNameToBind = this_binding['FunctionNameToBind'],
--                     InputKeyEvent = this_binding['InputKeyEvent'],
--                     InputChord = this_binding['InputChord']
--                 }
--                 Element:set(luatable_binding)
--             end
--         end)
--     end
-- end

------------------------------------------------------------------------------
-- TEMPORARILY COMMENTING OUT UI REMOVAL
-- function RemovePlayerOneHUD()
--     -- UI_HUD_C
--     local HUD = FindFirstOf("UI_HUD_C")
--     if HUD and HUD:IsValid() then
--         HUD:RemoveFromViewport()
--         Logf("Removing HUD\n")
--     end
-- end

------------------------------------------------------------------------------
-- TEMPORARILY COMMENTING OUT DEATH SCREEN REMOVAL
-- function RemovePlayerOneDeathScreen()
--     -- UI_DED_C
--     local DED = FindFirstOf("UI_DED_C")
--     if DED and DED:IsValid() then
--         DED:RemoveFromViewport()
--         Logf("Removing Death screen\n")
--         if GetGameplayStatics():IsGamePaused(GetWorldContextObject()) then
--             GetGameplayStatics():SetGamePaused(GetWorldContextObject(), false)
--             Logf("Unpausing game after death screen\n")
--         end
--     end
-- end

------------------------------------------------------------------------------
-- TEMPORARILY COMMENTING OUT PLAYER DEAD HOOK
-- function HookPlayerOneDead()
--     Logf("Player dead hook called\n")
--     RemovePlayerOneDeathScreen()
-- end

------------------------------------------------------------------------------
-- TEMPORARILY COMMENTING OUT CLIENT RESTART HOOK
-- function InitEveryGame()
--     Logf("ClientRestart hook\n")
--     ExecuteWithDelay(1000, function()
--         RemovePlayerOneHUD()
--     end)
-- end

------------------------------------------------------------------------------
local function InitMod()
    GetGameMapsSettings().bUseSplitscreen = true
    GetGameMapsSettings().bOffsetPlayerGamepadIds = bOffsetGamepad
    GetGameMapsSettings().TwoPlayerSplitscreenLayout = TwoPlayerSplitscreenLayout
    Logf("UseSplitScreen: %s\n", GetGameMapsSettings().bUseSplitscreen)
    Logf("OffsetPlayerGamepadIds: %s\n", GetGameMapsSettings().bOffsetPlayerGamepadIds)
    Logf("TwoPlayerSplitscreenLayout: %d\n", GetGameMapsSettings().TwoPlayerSplitscreenLayout)

    -- TEMPORARILY COMMENTING OUT INPUT REMAPPING
    -- RemapAllIKDBs()

    IsInitialized = true
end
------------------------------------------------------------------------------
local function CachePlayerControllers()
    PlayerControllerTable = {}
    local AllPlayerControllers = FindAllOf("PlayerController") --better than FindAllOf("Controller")
    for Index, PlayerController in pairs(AllPlayerControllers) do
        -- TEMPORARILY COMMENTING OUT INPUT REMAPPING
        -- RemapAllIKDBs()
        if PlayerController:IsValid() and PlayerController.Player:IsValid() and not PlayerController:HasAnyInternalFlags(EInternalObjectFlags.PendingKill) then
            PlayerControllerTable[PlayerController.Player.ControllerId + 1] = PlayerController
        end
    end
end
------------------------------------------------------------------------------
local function CreatePlayer()
    Log("Creating player..\n")
    CachePlayerControllers()

    --local map = FindFirstOf("Abyss_Map_Open_C")
    --local player = map['Player Willie']

    Logf("GameplayStatics: %s\n", GetGameplayStatics():GetFullName())
    -- Example of more debug logs
    ExecuteInGameThread(function()
        Log("Inside GameThread for player creation.\n")
        NewController = GetGameplayStatics():CreatePlayer(PlayerControllerTable[1], #PlayerControllerTable, true)
        Logf("Attempted to create player. NewController is %s\n", tostring(NewController))

        if NewController:IsValid() then
            Logf("NewController is valid. Full name: %s\n", NewController:GetFullName())
            table.insert(PlayerControllerTable, NewController)
            Logf("Player %s added to table.\n", #PlayerControllerTable)
            Logf("Checking NewController.Player: %s\n", tostring(NewController.Player))
            if NewController.Player and NewController.Player:IsValid() then
                Logf("NewController.Player is valid. ControllerId: %d\n", NewController.Player.ControllerId)
            else
                Log("NewController.Player is NOT valid.\n")
            end
            Logf("Checking NewController.Pawn: %s\n", tostring(NewController.Pawn))
            if NewController.Pawn and NewController.Pawn:IsValid() then
                Logf("NewController.Pawn is valid. Full name: %s\n", NewController.Pawn:GetFullName())
            else
                Log("NewController.Pawn is NOT valid. This is often the source of issues.\n")
            end
            -- Add more checks here
        else
            Log("Player could not be created - NewController is not valid.\n")
        end
    end)
end
------------------------------------------------------------------------------
function DestroyPlayer()
    -- The caller is caching the player controllers so that it can output that the correct player is being destroyed.
    CachePlayerControllers()

    if #PlayerControllerTable == 1 then
        Log("Player could not be destroyed, only 1 player exists.\n")
        return
    end
    Logf("GameplayStatics: %s\n", GetGameplayStatics():GetFullName())

    local ControllerToRemove = PlayerControllerTable[#PlayerControllerTable]
    Logf("Removing %s\n", ControllerToRemove:GetFullName())
    if not ControllerToRemove:IsValid() then
        Log("PlayerController to be removed is not valid.\nPlayerController could not be destroyed.\n")
        return
    end

    ExecuteInGameThread(function()
        GetGameplayStatics():RemovePlayer(ControllerToRemove, true)
    end)
end

------------------------------------------------------------------------------
-- -- Teleporting does not work at all yet
-- function TeleportPlayers()
--     --CachePlayerControllers()

--     --if #PlayerControllerTable == 1 then
--     --    Log("Players could not be teleported, only 1 player exists.\n")
--     --    return
--     --end

--     --local DidTeleport = false

--     --Logf("Attempting to Teleport to Player 1..\n")

--     --ExecuteInGameThread(function()
--     --    PlayerPawn = PlayerControllerTable[1].Pawn
--     --    PlayerPawnLocationVec = PlayerPawn.RootComponent:K2_GetComponentLocation()
--     --    Logf("Player 1 at {X=%.3f, Y=%.3f, Z=%.3f}\n", PlayerPawnLocationVec.X, PlayerPawnLocationVec.Y,
--     --        PlayerPawnLocationVec.Z)
--     --    PlayerPawnLocationVec.X = PlayerPawnLocationVec.X + 100.0
--     --    PlayerPawnLocationVec.Y = PlayerPawnLocationVec.Y + 100.0
--     --    PlayerPawnLocationVec.Z = PlayerPawnLocationVec.Z + 0.0
--     --    PlayerPawnLocationRot = PlayerPawn.RootComponent:K2_GetComponentRotation()
--     --    local HitResult = {}
--     --    local res
--     --    for i, EachPlayerController in ipairs(PlayerControllerTable) do
--     --        if i > 1 and EachPlayerController.Pawn:IsValid() then
--     --            Logf("Teleporting to {X=%.3f, Y=%.3f, Z=%.3f}\n", PlayerPawnLocationVec.X, PlayerPawnLocationVec.Y,
--     --                PlayerPawnLocationVec.Z)
--     --            --            EachPlayerController.Pawn:SetActorEnableCollision(false)
--     --            res = EachPlayerController.Pawn:K2_SetActorLocationAndRotation(PlayerPawnLocationVec,
--     --                PlayerPawnLocationRot,
--     --                false, HitResult, false)
--     --            --            res = EachPlayerController.Pawn:K2_SetActorLocation(PlayerPawnLocationVec, --PlayerPawnLocationRot,
--     --            --                false, HitResult, true)
--     --            --            res = EachPlayerController.Pawn:TeleportTo(PlayerPawnLocationVec, PlayerPawnLocationRot,
--     --            --                false, true)
--     --            --            EachPlayerController.Pawn:SetActorEnableCollision(true)
--     --            DidTeleport = true
--     --            Logf("Teleport Player #%d result: %s\n", i, tostring(res))
--     --        end
--     --    end

--     --    if DidTeleport then
--     --        Log("Players teleport to Player 1.\n")
--     --    else
--     --        Log("No players could be teleported\n")
--     --    end
--     --end)
-- end
------------------------------------------------------------------------------
InitMod()
------------------------------------------------------------------------------
-- Dirty hack
-- TEMPORARILY COMMENTING OUT OBJECT CONSTRUCTION HOOK (AND ITS REMAPPING)
-- NotifyOnNewObject("/Script/Engine.Character", function(ConstructedObject)
--    Logf("HOOK Willie_BP Constructed: %s\n", ConstructedObject:GetFullName())
--    RemapAllIKDBs()
-- end)
------------------------------------------------------------------------------
-- TEMPORARILY COMMENTING OUT CLIENT RESTART HOOK
-- RegisterHook("/Script/Engine.PlayerController:ClientRestart", InitEveryGame)
-- RegisterHook("/Game/Character/Blueprints/Willie_BP.Willie_BP_C:Dead", HookPlayerOneDead)
------------------------------------------------------------------------------
RegisterKeyBind(Key.N, { ModifierKey.CONTROL }, CreatePlayer)

RegisterKeyBind(Key.U, { ModifierKey.CONTROL }, DestroyPlayer)

-- TEMPORARILY COMMENTING OUT DEATH SCREEN REMOVAL KEYBIND
-- RegisterKeyBind(Key.D, { ModifierKey.CONTROL }, RemovePlayerOneDeathScreen)

-- RegisterKeyBind(Key.I, { ModifierKey.CONTROL }, TeleportPlayers)
------------------------------------------------------------------------------
-- EOF