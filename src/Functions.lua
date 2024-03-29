---This contains all of the generic functions that can be used.  A lot of it is to make handlefree versions of normal blizzard commands 
---Returns true if the value is found in the table. Author: KickKing
---@param table table
---@param element any
---@return boolean @true if found, false if not
function TableContains(table, element)
	for _, value in pairs(table) do if value == element then return true end end
	return false
end

---Remove a value from a table
---@param table table
---@param value any
---@return boolean @true if successful
function TableRemoveValue(table, value) return table.remove(table, TableFind(table, value)) end

---comment
---@param unit unit
---@param ability SPELL
---@param add boolean
---@param aif abilityintegerfield
---@param level integer
---@return integer
function GetAbilityInteger(unit, ability, add, aif, level)

	if GetUnitAbilityLevel(unit, ability.id) == 0 and add then
		UnitAddAbility(unit, ability.id)
		UnitMakeAbilityPermanent(unit, true, ability.id)
	end

	return BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(unit, ability.id), aif, level)
end

---comment
---@param unit unit
---@param ability SPELL
---@param add boolean
---@param arf abilityrealfield
---@param level integer
---@return real
function GetAbilityReal(unit, ability, add, arf, level)

	if GetUnitAbilityLevel(unit, ability.id) == 0 and add then
		UnitAddAbility(unit, ability.id)
		UnitMakeAbilityPermanent(unit, true, ability.id)
	end

	return BlzGetAbilityRealLevelField(BlzGetUnitAbility(unit, ability.id), arf, level)
end

---Add Ability to Unit and set the Integer field
---@param unit unit
---@param ability SPELL
---@param add boolean
---@param aif abilityintegerfield
---@param level integer
---@param amount integer
---@return boolean
function SetAbilityInteger(unit, ability, add, aif, level, amount)

	if GetUnitAbilityLevel(unit, ability.id) == 0 and add then
		UnitAddAbility(unit, ability.id)
		UnitMakeAbilityPermanent(unit, true, ability.id)
	end

	BlzSetAbilityIntegerLevelField(BlzGetUnitAbility(unit, ability.id), aif, level, amount)
	IncUnitAbilityLevel(unit, ability.id)
	DecUnitAbilityLevel(unit, ability.id)

	return true
end

---Add Ability to Unit and set the Integer field
---@param unit unit
---@param ability SPELL
---@param add boolean
---@param aif abilityintegerfield
---@param level integer
---@param amount integer
---@return boolean
function IncAbilityInteger(unit, ability, add, aif, level, amount)

	if GetUnitAbilityLevel(unit, ability.id) == 0 and add then
		UnitAddAbility(unit, ability.id)
		UnitMakeAbilityPermanent(unit, true, ability.id)
	end

	amount = GetAbilityInteger(unit, ability, add, aif, level) + amount

	BlzSetAbilityIntegerLevelField(BlzGetUnitAbility(unit, ability.id), aif, level, amount)
	IncUnitAbilityLevel(unit, ability.id)
	DecUnitAbilityLevel(unit, ability.id)

	return true
end

---Add Ability to Unit and set the Real field
---@param unit unit
---@param ability SPELL
---@param add boolean
---@param arf abilityrealfield
---@param level integer
---@param amount real
---@return boolean
function SetAbilityReal(unit, ability, add, arf, level, amount)

	if GetUnitAbilityLevel(unit, ability.id) == 0 and add then
		UnitAddAbility(unit, ability.id)
		UnitMakeAbilityPermanent(unit, true, ability.id)
	end

	BlzSetAbilityRealLevelField(BlzGetUnitAbility(unit, ability.id), arf, level, amount)
	IncUnitAbilityLevel(unit, ability.id)
	DecUnitAbilityLevel(unit, ability.id)

	return true
end

---Add Ability to Unit and set the Real field
---@param unit unit
---@param ability SPELL
---@param add boolean
---@param arf abilityrealfield
---@param level integer
---@param amount real
---@return boolean
function IncAbilityReal(unit, ability, add, arf, level, amount)

	if GetUnitAbilityLevel(unit, ability.id) == 0 and add then
		UnitAddAbility(unit, ability.id)
		UnitMakeAbilityPermanent(unit, true, ability.id)
	end

	amount = GetAbilityReal(unit, ability, add, arf, level) + amount

	BlzSetAbilityRealLevelField(BlzGetUnitAbility(unit, ability.id), arf, level, amount)
	IncUnitAbilityLevel(unit, ability.id)
	DecUnitAbilityLevel(unit, ability.id)

	return true
end

---Find the index of a value in a table.
---@param tab table
---@param el any
---@return number @Returns the index
function TableFind(tab, el) for index, value in pairs(tab) do if value == el then return index end end end

---Get the distance between 2 sets of Coordinates (Not handles used)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function DistanceBetweenCoordinates(x1, y1, x2, y2) return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1))) end

-- **Credit** KickKing
-- get distance without locations
---Get Distance between two units.  (Doesn't leak)
---@param unitA unit
---@param unitB unit
---@return number
function DistanceBetweenUnits(unitA, unitB)
	return DistanceBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

--- get angle between two sets of coordinates without locations
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number @angle between 0 and 360
function AngleBetweenCoordinates(x1, y1, x2, y2) return bj_RADTODEG * Atan2(y2 - y1, x2 - x1) end

---get angle between two units without locations
---@param unitA unit @Unit 1
---@param unitB unit @Unit 2
---@return number @angle between 0 and 360
function AngleBetweenUnits(unitA, unitB)
	return AngleBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

---Polar projection from point (Doesn't Leak)
---@param x number
---@param y number
---@param dist number
---@param angle number
---@return number @x
---@return number @y
function PolarProjectionCoordinates(x, y, dist, angle)
	local newX = x + dist * Cos(angle * bj_DEGTORAD)
	local newY = y + dist * Sin(angle * bj_DEGTORAD)
	return newX, newY
end

---raps your code in a "Try" loop so you can see errors printed in the log at runtime.  Author: Planetary
---@param func function
function try(func) -- Turn on runtime logging
	local passed, data = pcall(function()
		func()
		return "func " .. " passed"
	end)
	if not passed then print("|cffff0000[ERROR]|r", passed, data) end
end

---Converts integer formated types into the 4 digit strings (Opposite of FourCC()) Author: Taysen
---@param num integer
---@return string
function CC2Four(num) -- Convert from Handle ID to Four Char
	return string.pack(">I4", num)
end

--- Get a random xy in the specified rect
---@param rect rect
---@return real @X
---@return real @Y
function GetRandomCoordinatesInRect(rect)
	return GetRandomReal(GetRectMinX(rect), GetRectMaxX(rect)), GetRandomReal(GetRectMinY(rect), GetRectMaxY(rect))
end

---Get a random xy in the specified datapoints
---@param xMin number
---@param xMax number
---@param yMin number
---@param yMax number
---@return real @X
---@return real @Y
function GetRandomCoordinatesInPoints(xMin, xMax, yMin, yMax) return GetRandomReal(xMin, xMax),
                                                                     GetRandomReal(yMin, yMax) end

do
	local data = {}
	function SetTimerData(whichTimer, dat) data[whichTimer] = dat end

	-- GetData functionality doesn't even require an argument.
	function GetTimerData(whichTimer)
		if not whichTimer then whichTimer = GetExpiredTimer() end
		return data[whichTimer]
	end

	-- NewTimer functionality includes optional parameter to pass data to timer.
	function NewTimer(dat)
		local t = CreateTimer()
		if dat then data[t] = dat end
		return t
	end

	-- Release functionality doesn't even need for you to pass the expired timer.
	-- as an arg. It also returns the user data passed.
	function ReleaseTimer(whichTimer)
		if not whichTimer then whichTimer = GetExpiredTimer() end
		local dat = data[whichTimer]
		data[whichTimer] = nil
		PauseTimer(whichTimer)
		DestroyTimer(whichTimer)
		return dat
	end

	local oldWait = PolledWait
	function PolledWait(duration)
		local thread = coroutine.running()
		if thread then
			TimerStart(NewTimer(thread), duration, false, function() coroutine.resume(ReleaseTimer()) end)
			coroutine.yield(thread)
		else
			oldWait(duration)
		end
	end

	local oldTSA = TriggerSleepAction
	function TriggerSleepAction(duration) PolledWait(duration) end

	local thread
	local oldSync = SyncSelections
	function SyncSelectionsHelper()
		local t = thread
		oldSync()
		coroutine.resume(t)
	end
	function SyncSelections()
		thread = coroutine.running()
		if thread then
			ExecuteFunc("SyncSelectionsHelper")
			coroutine.yield(thread)
		else
			oldSync()
		end
	end

	if not EnableWaits then -- Added this check to ensure compatibilitys with Lua Fast Triggers
		local oldAction = TriggerAddAction
		function TriggerAddAction(whichTrig, userAction)
			oldAction(whichTrig, function() coroutine.resume(coroutine.create(function() userAction() end)) end)
		end
	end
end

---Pushback and Damage Units in Group
---@param g group
---@param castingUnit unit
---@param x real
---@param y real
---@param aoe integer
---@param damage integer
---@param tick real
---@param duration real
---@param factor real
---@return boolean
function PushbackUnits(g, castingUnit, x, y, aoe, damage, tick, duration, factor)
	local u, uX, uY, distance, angle, newDistance, uNewX, uNewY

	local loopTimes = duration / tick
	local damageTick = damage / loopTimes

	if CountUnitsInGroup(g) > 0 then
		for i = 1, loopTimes do

			ForGroup(g, function()
				u = GetEnumUnit()

				if IsUnitAliveBJ(u) then

					if i == 1 then PauseUnit(u, true) end

					uX = GetUnitX(u)
					uY = GetUnitY(u)

					distance = DistanceBetweenCoordinates(x, y, uX, uY)
					angle = AngleBetweenCoordinates(x, y, uX, uY)

					newDistance = ((aoe + 80) - distance) * 0.13 * factor

					uNewX, uNewY = PolarProjectionCoordinates(uX, uY, newDistance, angle)

					-- if IsTerrainPathable(uNewX, uNewY, PATHING_TYPE_WALKABILITY) then
					SetUnitX(u, uNewX)
					SetUnitY(u, uNewY)
					-- end

					if damage > 0 then UnitDamageTargetBJ(castingUnit, u, damageTick, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC) end

					if i >= loopTimes - 1 then PauseUnit(u, false) end
				else
					PauseUnit(u, false)
					GroupRemoveUnit(g, u)
				end
			end)

			PolledWait(tick)
		end
	end
	DestroyGroup(g)

	return true
end

---A system that allow you to duplicate the functionality of auto-filling in the Object Editor
---@param level             number @How many Levels or iterations to use for this
---@param base              number @The number to start with
---@param previousFactor    number @Multiply the previous level by this value
---@param levelFactor       number @This value exponential adds to itself every level
---@param constant          number @This gets added every level
---@return                  number @The calculated Value
function ValueFactor(level, base, previousFactor, levelFactor, constant)

	local value = base

	if level > 1 then for i = 2, level do value = (value * previousFactor) + (i * levelFactor) + (constant) end end

	return value
end
