local AS = unpack(AddOnSkins)
local AddOnName = ...
local format, gsub, strmatch, strfind, floor = format, gsub, strmatch, strfind, floor
local tinsert, pairs, ipairs, unpack, select, pcall = tinsert, pairs, ipairs, unpack, select, pcall
local GetAddOnInfo = GetAddOnInfo

AddOnSkins_Options = {
	['EmbedCoolLine'] = false,
	['EmbedOoC'] = false, 
	['EmbedOmen'] = false, 
	['EmbedRecount'] = false, 
	['EmbedSexyCooldown'] = false,
	['EmbedSkada'] = false, 
	['EmbedTinyDPS'] = false,
	['EmbedSystem'] = false,
	['EmbedSystemDual'] = false,
	['EmbedMain'] = 'Skada',
	['EmbedLeft'] = 'Skada',
	['EmbedRight'] = 'Skada',
	['EmbedLeftWidth'] = 200,
	['EmbedBelowTop'] = false,
	['RecountBackdrop'] = true,
	['SkadaBackdrop'] = true,
	['OmenBackdrop'] = true,
	['TransparentEmbed'] = false,
	['MiscFixes'] = true,
	['DBMSkinHalf'] = false,
	['DBMFont'] = 'Tukui',
	['DBMFontSize'] = 12,
	['DBMFontFlag'] = 'OUTLINE',
	['ParchmentRemover'] = false,
	['EmbedLeftChat'] = false,
	['WeakAuraAuraBar'] = false,
	['WeakAuraIconCooldown'] = true,
	['AuctionHouse'] = true,
	['IntegrateMyRolePlayTooltip'] = true,
}

AS.skins = {}
AS.events = {}
AS.register = {}
AS.TicketTracker = 'http://git.tukui.org/Azilroka/addonskins'
AS.FrameLocks = {}
AS.MyClass = select(2, UnitClass('player'))
AS.MyName = UnitName('player')
AS.MyRealm = GetRealmName()
AS.Noop = function() return end
AS.TexCoords = {.08, .92, .08, .92}

function AS:OrderedPairs(t, f)
	local a = {}
	for n in pairs(t) do tinsert(a, n) end
	sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
			else return a[i], t[a[i]]
		end
	end
	return iter
end

function AS:CheckAddOn(addon)
	return select(4, GetAddOnInfo(addon))
end

function AS:Print(string)
	print(format('%s %s', AS.Title, string))
end

function AS:Round(num, idp)
	local mult = 10^(idp or 0)
	return floor(num * mult + 0.5) / mult
end

function AS:PrintURL(url)
	return format("|cFFFFFFFF[|Hurl:%s|h%s|h]|r", url, url)
end

function AS:SkinTexture(frame)
	frame:SetTexCoord(unpack(AS.TexCoords))
end

function AS:CheckOption(optionName, ...)
	for i = 1,select('#', ...) do
		local addon = select(i, ...)
		if not addon then break end
		if not IsAddOnLoaded(addon) then return false end
	end
	return AddOnSkins_Options[optionName]
end

function AS:SetOption(optionName, value)
	AddOnSkins_Options[optionName] = value
end

function AS:DisableOption(optionName)
	AS:SetOption(optionName, false)
end

function AS:EnableOption(optionName)
	AS:SetOption(optionName, true)
end

function AS:ToggleOption(optionName)
	AddOnSkins_Options[optionName] = not AddOnSkins_Options[optionName]
end

function AS:RegisterSkin(skinName, skinFunc, ...)
	local events = {}
	local priority = 1
	for i = 1,select('#', ...) do
		local event = select(i, ...)
		if not event then break end
		if type(event) == 'number' then
			priority = event
		else
			events[event] = true
		end
	end
	local registerMe = { func = skinFunc, events = events, priority = priority }
	if not AS.register[skinName] then AS.register[skinName] = {} end
	AS.register[skinName][skinFunc] = registerMe
end

function AS:RegisterForPetBattleHide(frame)
	if frame.IsVisible and frame:GetName() then
		AS.FrameLocks[frame:GetName()] = { shown = false }
	end
end

function AS:AddNonPetBattleFrames()
	for frame,data in pairs(AS.FrameLocks) do
		if data.shown then
			_G[frame]:Show()
		end
	end
end

function AS:RemoveNonPetBattleFrames()
	for frame,data in pairs(AS.FrameLocks) do
		if _G[frame]:IsVisible() then
			data.shown = true
			_G[frame]:Hide()
		else
			data.shown = false
		end
	end
end

local AcceptFrame
function AS:AcceptFrame(MainText, Function)
	if not AcceptFrame then
		AcceptFrame = CreateFrame('Frame', nil, UIParent)
		AcceptFrame:SetTemplate('Transparent')
		AcceptFrame:SetSize(250, 70)
		AcceptFrame:SetPoint('CENTER', UIParent, 'CENTER')
		AcceptFrame:SetFrameStrata('DIALOG')
		AcceptFrame:FontString('Text', AS.Font, 14)
		AcceptFrame.Text:SetPoint('TOP', AcceptFrame, 'TOP', 0, -10)
		AcceptFrame.Accept = CreateFrame('Button', nil, AcceptFrame)
		AS:SkinButton(AcceptFrame.Accept)
		AcceptFrame.Accept:SetSize(70, 25)
		AcceptFrame.Accept:SetPoint('RIGHT', AcceptFrame, 'BOTTOM', -10, 20)
		AcceptFrame.Accept:FontString('Text', AS.Font, 12)
		AcceptFrame.Accept.Text:SetPoint('CENTER')
		AcceptFrame.Accept.Text:SetText(YES)
		AcceptFrame.Close = CreateFrame('Button', nil, AcceptFrame)
		AS:SkinButton(AcceptFrame.Close)
		AcceptFrame.Close:SetSize(70, 25)
		AcceptFrame.Close:SetPoint('LEFT', AcceptFrame, 'BOTTOM', 10, 20)
		AcceptFrame.Close:SetScript('OnClick', function(self) self:GetParent():Hide() end)
		AcceptFrame.Close:FontString('Text', AS.Font, 12)
		AcceptFrame.Close.Text:SetPoint('CENTER')
		AcceptFrame.Close.Text:SetText(NO)
	end
	AcceptFrame.Text:SetText(MainText)
	AcceptFrame.Accept:SetScript('OnClick', Function)
	AcceptFrame:Show()
end

function AS:StartSkinning(event)
	for skin, alldata in pairs(AS.register) do
		for _, data in pairs(alldata) do
			if AS:CheckOption(skin) == nil then AS:EnableOption(skin) end
			AS:RegisteredSkin(skin, data.priority, data.func, data.events)
		end
	end

	for skin, funcs in pairs(self.skins) do
		if self:CheckOption(skin) then
			for _, func in ipairs(funcs) do
				self:CallSkin(skin, func, event)
			end
		end
	end

	self:EmbedInit()
	self:Ace3Options()
	self:Print(format("by |cFFFF7D0AAzilroka|r - Version: |cFF1784D1%s|r Loaded!", self.Version))
	self:UnregisterEvent(event)
end

function AS:CallSkin(skin, func, event, ...)
	local pass, error = pcall(func, self, event, ...)
	if not pass then
		local message = '%s %s: |cfFFF0000There was an error in the|r |cff0AFFFF%s|r |cffFF0000skin|r.  Please report this to Azilroka immediately @ %s'
		local errormessage = '%s Error: %s'
		local Skin = gsub(skin, 'Skin', '')
		print(format(message, AS.Title, AS.Version, Skin, AS:PrintURL(AS.TicketTracker)))
		print(format(errormessage, Skin, error))
	end
end

local function GenerateEventFunction(event)
	local eventHandler = function(self, event, ...)
		for skin, funcs in pairs(AS.skins) do
			if AS:CheckOption(skin) and AS.events[event][skin] then
				local args = {}
				for i = 1, select('#', ...) do
					local arg = select(i, ...)
					if not arg then break end
					tinsert(args, arg)
				end
				for _, func in ipairs(funcs) do
					AS:CallSkin(skin, func, event, unpack(args))
				end
			end
		end
	end
	return eventHandler
end

function AS:RegisteredSkin(skinName, priority, func, events)
	local events = events
	for c, _ in pairs(events) do
		if strfind(c, '%[') then
			local conflict = strmatch(c, '%[([!%w_]+)%]')
			if AS:CheckAddOn(conflict) then return end
		end
	end
	if not self.skins[skinName] then self.skins[skinName] = {} end
	self.skins[skinName][priority] = func
	for event, _ in pairs(events) do
		if not strfind(event, '%[') then
			if not self.events[event] then
				self[event] = GenerateEventFunction(event)
				self:RegisterEvent(event); 
				self.events[event] = {} 
			end
			self.events[event][skinName] = true
		end
	end
end

function AS:UnregisterEvent(skinName, event)
	if not self.events[event] then return end
	if not self.events[event][skinName] then return end
	self.events[event][skinName] = nil
	local found = false
	for skin,_ in pairs(self.events[event]) do
		if skin then
			found = true
			break
		end
	end
	if not found then
		self.frame:UnregisterEvent(event)
	end
end

function AS:Init(event, addon)
	if addon == AddOnName then
		self:RegisterEvent('PET_BATTLE_CLOSE', 'AddNonPetBattleFrames')
		self:RegisterEvent('PET_BATTLE_OPENING_START', 'RemoveNonPetBattleFrames')
		self:RegisterEvent('PLAYER_ENTERING_WORLD', 'StartSkinning')
		self:UnregisterEvent(event)
	end
end

AS:RegisterEvent('ADDON_LOADED', 'Init')