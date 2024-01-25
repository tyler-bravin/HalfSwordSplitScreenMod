local UEHelpers = require("UEHelpers")

-- Importing functions to the global namespace of this mod just so that we don't have to retype 'UEHelpers.' over and over again.
local GetGameplayStatics = UEHelpers.GetGameplayStatics
local GetGameMapsSettings = UEHelpers.GetGameMapsSettings

-- Set this value to true if you wish for the first controller to control player 1, or false if you want the first controller to control player 2
local bOffsetGamepad = true
-- 0 is default horizontal (top and bottom), 1 is vertical (left and right)
local TwoPlayerSplitscreenLayout = 1

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

local function Init()
    GetGameMapsSettings().bUseSplitscreen = true
    GetGameMapsSettings().bOffsetPlayerGamepadIds = bOffsetGamepad
    GetGameMapsSettings().TwoPlayerSplitscreenLayout = TwoPlayerSplitscreenLayout
    Logf("UseSplitScreen: %s\n", GetGameMapsSettings().bUseSplitscreen)
    Logf("OffsetPlayerGamepadIds: %s\n", GetGameMapsSettings().bOffsetPlayerGamepadIds)
    Logf("TwoPlayerSplitscreenLayout: %d\n", GetGameMapsSettings().TwoPlayerSplitscreenLayout)

    IsInitialized = true
end

local function CachePlayerControllers()
    PlayerControllerTable = {}
    local AllPlayerControllers = FindAllOf("PlayerController") --or FindAllOf("Controller")
    for Index, PlayerController in pairs(AllPlayerControllers) do
        if PlayerController:IsValid() and PlayerController.Player:IsValid() and not PlayerController:HasAnyInternalFlags(EInternalObjectFlags.PendingKill) then
            PlayerControllerTable[PlayerController.Player.ControllerId + 1] = PlayerController
        end
    end
end

Init()

local function CreatePlayer()
    Log("Creating player..\n")
    CachePlayerControllers()

    Logf("GameplayStatics: %s\n", GetGameplayStatics():GetFullName())
    ExecuteInGameThread(function()
        NewController = GetGameplayStatics():CreatePlayer(PlayerControllerTable[1], #PlayerControllerTable, true)
        -- We need to insert this in the game thread or it will not be available outside of the callback
        if NewController:IsValid() then
            table.insert(PlayerControllerTable, NewController)
            Logf("Player %s created.\n", #PlayerControllerTable)
        else
            Log("Player could not be created.\n")
        end
    end)
end

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

function TeleportPlayers()
    CachePlayerControllers()

    if #PlayerControllerTable == 1 then
        Log("Players could not be teleported, only 1 player exists.\n")
        return
    end

    local DidTeleport = false

    Logf("Attempting to Teleport to Player 1..\n")

    ExecuteInGameThread(function()
        PlayerPawn = PlayerControllerTable[1].Pawn
        PlayerPawnLocationVec = PlayerPawn.RootComponent:K2_GetComponentLocation()
        PlayerPawnLocationRot = PlayerPawn.RootComponent:K2_GetComponentRotation()
        local HitResult = {}
        for i, EachPlayerController in ipairs(PlayerControllerTable) do
            if i > 1 and EachPlayerController.Pawn:IsValid() then
                EachPlayerController.Pawn:K2_SetActorLocationAndRotation(PlayerPawnLocationVec, PlayerPawnLocationRot,
                    false, HitResult, false)
                DidTeleport = true
            end
        end

        if DidTeleport then
            Log("Players teleport to Player 1.\n")
        else
            Log("No players could be teleported\n")
        end
    end)
end

RegisterKeyBind(Key.Y, { ModifierKey.CONTROL }, CreatePlayer)

RegisterKeyBind(Key.U, { ModifierKey.CONTROL }, DestroyPlayer)

RegisterKeyBind(Key.I, { ModifierKey.CONTROL }, TeleportPlayers)
