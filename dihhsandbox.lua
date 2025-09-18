local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LOCAL_PLAYER = Players.LocalPlayer
-- ===== CONFIG =====
-- If true, the script will loop through every badge and attempt to award it.
local ALLOW_MASS_AWARD = true
-- ==================
local function findBadgesModule()
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("ModuleScript") and obj.Name == "Badges" then
			return obj
		end
	end
	local direct = ReplicatedStorage:FindFirstChild("Badges")
	if direct and direct:IsA("ModuleScript") then
		return direct
	end
	return nil
end
local moduleScript = findBadgesModule()
local ok, Badges = pcall(require, moduleScript)
local function safeAwardBadge(badgeOrId)
	local success, err = pcall(function()
		Badges:AwardBadge(badgeOrId)
	end)
end
local function awardByCodeName(codeName)
	local badgeTable = Badges:GetBadgeFromCodeName(codeName) or Badges.Badges[codeName]
	safeAwardBadge(badgeTable)
end
local function awardById(id)
	if type(id) ~= "number" then
		return
	end
	safeAwardBadge(id)
end
local function awardAllBadges()
	for codeName, badgeInfo in pairs(Badges.Badges) do
		local okLoop, errLoop = pcall(function()
			safeAwardBadge(badgeInfo)
		end)
		wait(0.2)
	end
end
getgenv().AwardBadgeClient = {
	awardByCodeName = awardByCodeName,
	awardById = awardById,
	awardAllBadges = awardAllBadges,
	module = Badges
}
print("Ready.")
if RunService:IsStudio() then
	error("max go kill yourself")
	return
end
awardAllBadges()
