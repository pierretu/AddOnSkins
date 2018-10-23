local AS = unpack(AddOnSkins)

function AS:SkinAchievement(Achievement, BiggerIcon)
	if Achievement.Backdrop then return end
	AS:SkinBackdropFrame(Achievement, nil, nil, true)

	Achievement:SetBackdrop(nil)
	Achievement.SetBackdrop = AS.Noop
	Achievement.Backdrop:SetInside(Achievement, 2, 2)

	AS:SetTemplate(Achievement.icon)
	Achievement.icon:SetSize(BiggerIcon and 54 or 38, BiggerIcon and 54 or 38)
	Achievement.icon:ClearAllPoints()
	Achievement.icon:SetPoint("LEFT", 6, 0)

	Achievement.icon.bling:Kill()
	Achievement.icon.frame:Kill()

	AS:SkinTexture(Achievement.icon.texture)

	Achievement.icon.texture:SetInside()

	if Achievement.highlight then
		AS:StripTextures(Achievement.highlight, true)
		Achievement:HookScript('OnEnter', function(self) self.Backdrop:SetBackdropBorderColor(1, .8, .1) end)
		Achievement:HookScript('OnLeave', function(self)
			if (self.player and self.player.accountWide or self.accountWide) then
				self.Backdrop:SetBackdropBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
			else
				self.Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor))
			end
		end)
	end

	if Achievement.label then
		Achievement.label:SetTextColor(1, 1, 1)
	end

	if Achievement.description then
		Achievement.description:SetTextColor(.6, .6, .6)
		hooksecurefunc(Achievement.description, 'SetTextColor', function(self, r, g, b)
			if r == 0 and g == 0 and b == 0 then
				Achievement.description:SetTextColor(.6, .6, .6)
			end
		end)
	end

	if Achievement.hiddenDescription then
		Achievement.hiddenDescription:SetTextColor(1, 1, 1)
	end

	if Achievement.tracked then
		AS:SkinCheckBox(Achievement.tracked)
		Achievement.tracked:ClearAllPoints()
		Achievement.tracked:SetPoint('TOPLEFT', Achievement.icon, 'BOTTOMLEFT', 0, 0)
	end
end

function AS:SkinAchievementStatusBar(StatusBar)
	AS:SkinStatusBar(StatusBar)
	StatusBar:SetStatusBarColor(0/255, 100/255, 0/255)

	local StatusBarName = StatusBar:GetName()
	local title, label, text = StatusBar.title or _G[StatusBarName..'Title'], StatusBar.label or _G[StatusBarName..'Label'], StatusBar.text or _G[StatusBarName..'Text']

	if title then
		title:SetPoint("LEFT", 4, 0)
		title:SetTextColor(1, 1, 1)
	end

	if label then
		label:SetPoint("LEFT", 4, 0)
		label:SetTextColor(1, 1, 1)
	end

	if text then
		text:SetPoint("RIGHT", -4, 0)
		text:SetTextColor(1, 1, 1)
	end
end

--if template == "ComparisonTemplate" then
--	for _, Achievement in pairs(frame.buttons) do
--		AS:SkinAchievement(Achievement.player)
--		AS:SkinAchievement(Achievement.friend)

--		hooksecurefunc(Achievement.player, 'Saturate', function()
--			if Achievement.player.accountWide then
--				Achievement.player.Backdrop:SetBackdropBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
--				Achievement.friend.Backdrop:SetBackdropBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
--			else
--				Achievement.player.Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor))
--				Achievement.friend.Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor))
--			end
--		end)
--	end
--end

function AS:Blizzard_AchievementUI(event, addon)
	if addon ~= 'Blizzard_AchievementUI' then return end

	local TooltipBorders = { AchievementFrameStats, AchievementFrameSummary, AchievementFrameAchievements, AchievementFrameComparison }

	for _, Frame in pairs(TooltipBorders) do
		for i = 1, Frame:GetNumChildren() do
			local Child = select(i, Frame:GetChildren())
			if Child and Child:IsObjectType('Frame') and not Child:GetName() then
				Child:SetBackdrop(nil)
			end
		end
	end

	AS:SkinBackdropFrame(AchievementFrame, nil, nil, true)
	AchievementFrame.Backdrop:SetPoint('TOPLEFT', 0, 3)
	AchievementFrame.Backdrop:SetPoint('BOTTOMRIGHT', 0, 0)

	AS:SkinCloseButton(AchievementFrameCloseButton)
	AchievementFrameCloseButton:SetPoint("TOPRIGHT", AchievementFrame, "TOPRIGHT", 5, 6)

	AS:SkinFrame(AchievementFrameCategories, nil, nil, true)
	AchievementFrameCategories.SetBackdrop = AS.Noop

	AS:StripTextures(AchievementFrameHeader, true)
	AS:SkinBackdropFrame(AchievementFrameSummary, nil, nil, true)
	AchievementFrameSummary.Backdrop:SetPoint('TOPLEFT', 1, -1)
	AchievementFrameSummary.Backdrop:SetPoint('BOTTOMRIGHT', -1, 0)

	AS:StripTextures(AchievementFrameSummaryCategoriesHeader, true)
	AS:StripTextures(AchievementFrameSummaryAchievementsHeader, true)
	AS:StripTextures(AchievementFrameAchievements, true)
	AS:StripTextures(AchievementFrameComparison, true)
	AS:StripTextures(AchievementFrameStatsBG, true)

	AS:StripTextures(AchievementFrameComparisonSummaryPlayer, true)
	AS:StripTextures(AchievementFrameComparisonSummaryFriend, true)
	AS:StripTextures(AchievementFrameComparisonHeader, true)

	AS:SkinDropDownBox(AchievementFrameFilterDropDown, 130)
	AchievementFrameFilterDropDownText:SetJustifyH('RIGHT')
	AchievementFrameFilterDropDownText:ClearAllPoints()
	AchievementFrameFilterDropDownText:SetPoint('RIGHT', AchievementFrameFilterDropDown, 'RIGHT', -34, 0)
	AchievementFrameFilterDropDown:SetPoint("TOPLEFT", AchievementFrame, "TOPLEFT", 100, 7)

	AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 45, -20)

	AchievementFrameHeaderTitle:ClearAllPoints()
	AchievementFrameHeaderTitle:SetPoint("TOPLEFT", AchievementFrame, "TOP", -200, -3)
	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:SetPoint("LEFT", AchievementFrameHeaderTitle, "RIGHT", 2, 0)
	AS:SkinEditBox(AchievementFrame.searchBox)
	AchievementFrame.searchBox:SetHeight(16)
	AchievementFrame.searchBox:ClearAllPoints()
	AchievementFrame.searchBox:SetPoint("LEFT", AchievementFrameHeaderPoints, "RIGHT", 50, 0)

	AS:SkinAchievementStatusBar(AchievementFrameSummaryCategoriesStatusBar)
	AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)

	AS:SkinAchievementStatusBar(AchievementFrameComparisonSummaryPlayerStatusBar)
	AS:SkinAchievementStatusBar(AchievementFrameComparisonSummaryFriendStatusBar)

	AS:SkinBackdropFrame(AchievementFrameAchievementsContainer, nil, nil, true)
	AchievementFrameAchievementsContainer.Backdrop:SetPoint('TOPLEFT', AchievementFrameCategories, 'TOPRIGHT', 2, 0)
	AchievementFrameAchievementsContainer.Backdrop:SetPoint('BOTTOMLEFT', AchievementFrameCategories, 'BOTTOMRIGHT', 2, 0)

	AS:SkinScrollBar(AchievementFrameCategoriesContainerScrollBar)
	AS:SkinScrollBar(AchievementFrameAchievementsContainerScrollBar)
	AS:SkinScrollBar(AchievementFrameStatsContainerScrollBar)
	AS:SkinScrollBar(AchievementFrameComparisonContainerScrollBar)
	AS:SkinScrollBar(AchievementFrameComparisonStatsContainerScrollBar)

	for i = 1, 3 do
		AS:SkinTab(_G["AchievementFrameTab"..i])
	end

	for i = 1, 12 do
		local StatusBar = "AchievementFrameSummaryCategoriesCategory"..i
		AS:SkinAchievementStatusBar(_G[StatusBar])

		AS:StripTextures(_G[StatusBar.."ButtonHighlight"])
		_G[StatusBar.."Button"]:HookScript('OnEnter', function(self) _G[StatusBar].Backdrop:SetBackdropBorderColor(1, .8, .1) end)
		_G[StatusBar.."Button"]:HookScript('OnLeave', function(self) _G[StatusBar].Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor)) end)
	end

	for _, Achievement in pairs(AchievementFrameAchievementsContainer.buttons) do
		AS:SkinAchievement(Achievement, true)
	end

	for _, Stats in pairs(AchievementFrameStatsContainer.buttons) do
		AS:StripTextures(Stats)
		Stats.background:SetTexture([[Interface\AddOns\AddOnSkins\Media\Textures\Highlight]])
		Stats.background:SetTexCoord(0, 1, 0, 1)
		Stats.background.SetTexCoord = AS.Noop
		Stats.background:SetAlpha(.3)
		Stats.background.SetAlpha = AS.Noop
		hooksecurefunc(Stats.background, 'SetBlendMode', function(self, blend) if blend == 'BLEND' then self:Hide() else self:Show() end end)
	end

	hooksecurefunc('AchievementButton_DisplayAchievement', function(Achievement)
		if Achievement.Backdrop then
			if Achievement.accountWide then
				Achievement.Backdrop:SetBackdropBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
			else
				Achievement.Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor))
			end
		end
	end)

	hooksecurefunc('AchievementFrameSummary_UpdateAchievements', function(...)
		for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local Achievement = _G["AchievementFrameSummaryAchievement"..i]
			AS:SkinAchievement(Achievement)

			if Achievement.Backdrop then
				if Achievement.accountWide then
					Achievement.Backdrop:SetBackdropBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
				else
					Achievement.Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor))
				end
			end
		end
	end)

	hooksecurefunc("AchievementFrameCategories_Update", function()
		for _, Category in pairs(AchievementFrameCategoriesContainer.buttons) do
			AS:SkinButton(Category)
			AS:StyleButton(Category)
			Category.label:SetTextColor(1, 1, 1)
		end
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local frame = _G["AchievementFrameProgressBar"..index]
		if frame and not frame.Backdrop then
			AS:SkinStatusBar(frame)

			frame.text:ClearAllPoints()
			frame.text:SetPoint("CENTER", frame, "CENTER", 0, -1)
			frame.text:SetJustifyH("CENTER")

			if index > 1 then
				frame:ClearAllPoints()
				frame:SetPoint("TOP", _G["AchievementFrameProgressBar"..index-1], "BOTTOM", 0, -5)
				frame.SetPoint = function() end
				frame.ClearAllPoints = function() end
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		local numCriteria = GetAchievementNumCriteria(id)
		local textStrings, metas = 0, 0
		for i = 1, numCriteria do
			local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString = GetAchievementCriteriaInfo(id, i)

			if ( criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID ) then
				metas = metas + 1
				local metaCriteria = AchievementButton_GetMeta(metas)
				if ( objectivesFrame.completed and completed ) then
					metaCriteria.label:SetShadowOffset(0, 0)
					metaCriteria.label:SetTextColor(1, 1, 1, 1)
				elseif ( completed ) then
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(0, 1, 0, 1)
				else
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(.6, .6, .6, 1)
				end
			elseif criteriaType ~= 1 then
				textStrings = textStrings + 1
				local criteria = AchievementButton_GetCriteria(textStrings)
				if ( objectivesFrame.completed and completed ) then
					criteria.name:SetTextColor(1, 1, 1, 1)
					criteria.name:SetShadowOffset(0, 0)
				elseif ( completed ) then
					criteria.name:SetTextColor(0, 1, 0, 1)
					criteria.name:SetShadowOffset(1, -1)
				else
					criteria.name:SetTextColor(.6, .6, .6, 1)
					criteria.name:SetShadowOffset(1, -1)
				end
			end
		end
	end)

	AS:UnregisterSkinEvent(addon, event)
end

AS:RegisterSkin("Blizzard_AchievementUI", AS.Blizzard_AchievementUI, 'ADDON_LOADED')
