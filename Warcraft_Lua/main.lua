function init_Lua()
    debugprint = 2

    -- Define Classes
    debugfunc(function()
        init_triggers()

        Init_luaGlobals()
        init_locationClass()
        init_indexerClass()
        init_heroClass()
        init_spawnClass()
        init_aiClass()
    end, "Define Classes")
    dprint("Classes Defined", 2)

    -- Start the Map init
    Init_Map()

    -- Init Classes
    debugfunc(function()
        loc = loc_Class.new()
        addRegions()
        indexer = indexer_Class.new()
        hero = hero_Class.new()
        ai = ai_Class.new()
        spawn = spawn_Class.new()

    end, "Init Classes")

    dprint("Classes Initialized", 2)

    -- Init Trigger
    debugfunc(function()

        init_AutoZoom()
        Init_HeroLevelsUp()
        Init_UnitCastsSpell()
        Init_PlayerBuysUnit()
        init_spawnTimers()
        Init_UnitEntersMap()
        Init_stopCasting()
        Init_finishCasting()
        Init_IssuedOrder()
        Init_UnitDies()
        init_MoveToNext()
    end, "Init Triggers")

    dprint("Triggers Initialized", 2)

    -- Spawn Base / Unit Setup
    -- Init Trigger
    debugfunc(function()
        spawnAddBases()
        spawnAddUnits()
    end, "Init Spawn")

    dprint("Spawn Setup", 2)

    -- Setup Delayed Init Triggers
    init_Delayed_1()
    init_Delayed_10()

    dprint("Init Finished")
end

-- Init Delayed Functions 1 second after Map Init
function init_Delayed_1()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 1)
    TriggerAddAction(t, function()
        debugfunc(function()
            ai:pickHeroes()
            dprint("pick Heroes Successfull", 2)
            ai:init_loopStates()
            dprint("AI Started", 2)

            orderStartingUnits()
            spawn:startSpawn()

            dprint("Spawn Started", 2)
        end, "Start Delayed Triggers")
    end)
end

-- Init Delayed Functions 10 second after Map Init
function init_Delayed_10()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 10)
    TriggerAddAction(t, function()
        debugfunc(function()
            -- FogMaskEnableOn()
            -- FogEnableOn()

            -- Set up the Creep Event Timer
            StartTimerBJ(udg_EventTimer, false, 350.00)
        end, "Start Delayed Triggers")
    end)
end

function Init_Map()

    FogEnableOff()
    FogMaskEnableOff()
    MeleeStartingVisibility()
    udg_UserPlayers = GetPlayersByMapControl(MAP_CONTROL_USER)
    udg_ALL_PLAYERS = GetPlayersAll()

    -- Turn on Bounty
    ForForce(udg_ALL_PLAYERS, function()
        SetPlayerFlagBJ(PLAYER_STATE_GIVES_BOUNTY, true, GetEnumPlayer())
    end)

    -- Add Computers to their group
    udg_PLAYERcomputers[1] = Player(18)
    udg_PLAYERcomputers[2] = Player(19)
    udg_PLAYERcomputers[3] = Player(20)
    udg_PLAYERcomputers[4] = Player(21)
    udg_PLAYERcomputers[5] = Player(22)
    udg_PLAYERcomputers[6] = Player(23)

    -- Create the Allied Computers
    ForceAddPlayerSimple(udg_PLAYERcomputers[1], udg_PLAYERGRPallied)
    ForceAddPlayerSimple(udg_PLAYERcomputers[2], udg_PLAYERGRPallied)
    ForceAddPlayerSimple(udg_PLAYERcomputers[3], udg_PLAYERGRPallied)

    -- Create the Federation Computers
    ForceAddPlayerSimple(udg_PLAYERcomputers[4], udg_PLAYERGRPfederation)
    ForceAddPlayerSimple(udg_PLAYERcomputers[5], udg_PLAYERGRPfederation)
    ForceAddPlayerSimple(udg_PLAYERcomputers[6], udg_PLAYERGRPfederation)

    -- Create the Allied Users
    ForceAddPlayerSimple(Player(0), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(1), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(2), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(3), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(4), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(5), udg_PLAYERGRPalliedUsers)

    -- Create the Federation Users
    ForceAddPlayerSimple(Player(6), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(7), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(8), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(9), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(10), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(11), udg_PLAYERGRPfederationUsers)

    -- Change the color of Player 1 and Player 2
    SetPlayerColorBJ(Player(0), PLAYER_COLOR_COAL, true)
    SetPlayerColorBJ(Player(1), PLAYER_COLOR_EMERALD, true)

    -- Change the color of the computer players to all match
    ForForce(udg_PLAYERGRPallied, function()
        SetPlayerColorBJ(GetEnumPlayer(), PLAYER_COLOR_RED, true)
    end)
    ForForce(udg_PLAYERGRPfederation, function()
        SetPlayerColorBJ(GetEnumPlayer(), PLAYER_COLOR_BLUE, true)
    end)

end

function init_spawnTimers()
    -- Create Spawn Loop Trigger

    TriggerAddAction(Trig_spawnLoop, function()
        debugfunc(function()
            spawn:loopSpawn()
        end, "spawn:loopSpawn")
    end)

    TriggerAddAction(Trig_upgradeCreeps, function()
        debugfunc(function()
            spawn:upgradeCreeps()
        end, "spawn:upgradeCreeps()")
    end)
end

--
-- Triggers
--

-- Camera Setup
function init_AutoZoom()

    -- DisableTrigger(Trig_AutoZoom)
    TriggerRegisterTimerEventPeriodic(Trig_AutoZoom, 3.00)
    TriggerAddAction(Trig_AutoZoom, function()
        local i = 1
        local ug = CreateGroup()

        while (i <= 12) do
            ug = GetUnitsInRangeOfLocAll(1350, GetCameraTargetPositionLoc())
            SetCameraFieldForPlayer(ConvertedPlayer(i), CAMERA_FIELD_TARGET_DISTANCE,
                (1400.00 + (1.00 * I2R(CountUnitsInGroup(ug)))), 6.00)
            DestroyGroup(ug)
            i = i + 1
        end
    end)
end


function CAST_aiHero(triggerUnit)
    if IsUnitInGroup(triggerUnit, ai.heroGroup) then
        local heroName = indexer:get(triggerUnit).heroName
        ai:castSpell(heroName)
    end
end


-- Add unit to index then order to move if unit is computer controlled and a correct unit
function addUnitsToIndex(unit)

    indexer:add(unit)

    if IsUnitType(unit, UNIT_TYPE_STRUCTURE) == false and IsUnitType(unit, UNIT_TYPE_HERO) == false and
        (IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPallied) or
            IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPfederation)) then
        indexer:order(unit)
    end

end

-- Order starting units to attack
function orderStartingUnits()
    local g = CreateGroup()
    local u

    g = GetUnitsInRectAll(GetPlayableMapRect())
    while true do
        u = FirstOfGroup(g)
        if u == nil then
            break
        end

        debugfunc(function()

            indexer:add(u)
            if not (IsUnitType(u, UNIT_TYPE_STRUCTURE)) and not (IsUnitType(u, UNIT_TYPE_HERO)) and
                (IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPallied) or
                    IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPfederation)) then

                indexer:order(u)
            end
        end, "Index")

        GroupRemoveUnit(g, u)
    end
    DestroyGroup(g)
end

-- Tell unit to keep Attack-Moving to it's indexed destination
function unitKeepMoving(unit)
    if GetOwningPlayer(unit) ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) and IsUnitType(unit, UNIT_TYPE_HERO) == false and
        UnitHasBuffBJ(unit, FourCC("B006")) == false and GetUnitTypeId(unit) ~= FourCC("h00M") and GetUnitTypeId(unit) ~=
        FourCC("h00M") and GetUnitTypeId(unit) ~= FourCC("h000") and GetUnitTypeId(unit) ~= FourCC("h00V") and
        GetUnitTypeId(unit) ~= FourCC("h00O") and
        (IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPallied) == true or
            IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPfederation) == true) then
        PolledWait(0.5)
        indexer:order(unit, "attack")
    end
end

