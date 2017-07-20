local MR_PlayerName = nil;
local MobResistMenuObjects = {}

function MobResist_OnLoad()
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_AURA");
	DEFAULT_CHAT_FRAME:AddMessage("Mob Resist, by Armilus. /MR show and /MR hide to show/hide display.", 1, 1, 0.5);
	SLASH_MR1 = "/MR";
	SlashCmdList["MR"] = MobResist_Command;
end

function MobResist_Init()
	MR_PlayerName = UnitName("player").." of "..GetCVar("realmName");

	if (MOBRESIST_CONFIG == nil) then
		MOBRESIST_CONFIG = {};
	end
	
	if (MOBRESIST_CONFIG[MR_PlayerName] == nil) then
		MOBRESIST_CONFIG[MR_PlayerName] = false;
	end
	
	if (MOBRESIST_CONFIG[MR_PlayerName]) then
		MobResistDisplay:Show();
	end
end

function MobResist_OnEvent()
	if (event == "PLAYER_TARGET_CHANGED") then
		Update();
	elseif (event == "VARIABLES_LOADED") then
		MobResist_Init();
	elseif (event == "UNIT_AURA" and MR_Target ~= nil) then
		Update();
	end
end

function MobResist_Command(arg)
	local args = {}
	for v in string.gfind(arg, "[^ ]+") do
		tinsert(args, v)
	end

	local c = table.getn(args);
	
	if c == 0 then
		return;
	end
	
	local arg1 = args[1];
	
	if arg1 == "reset" then
		MobResistDisplay:SetPoint("TOPLEFT", 960, -540);
	end
	
	if arg1 and arg1 == "show" then
		MobResistDisplay:Show();
		MOBRESIST_CONFIG[MR_PlayerName] = true;
	elseif arg1 == "hide" then
		MobResistDisplay:Hide();
		MOBRESIST_CONFIG[MR_PlayerName] = false;
	elseif arg1 == "report" then
		if c == 2 then
			arg2 = args[2];
		else
			arg2 = "s";
		end
		
		Report(arg2);
			
	end
end

function TargetCheck(unit)
	local n = UnitName("target");
	if not n or UnitIsPlayer(unit) then -- or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then 
		MR_Target = nil;
		return false;
	else
		MR_Target = unit
		return true;
	end
end

function Update()
	local NameText = getglobal("MobResistFrameTitleText");
	local ArmorText = getglobal("TargetArmorText");
	local HolyText = getglobal("TargetHolyText");
	local FireText = getglobal("TargetFireText");
	local NatureText = getglobal("TargetNatureText");
	local FrostText = getglobal("TargetFrostText");
	local ShadowText = getglobal("TargetShadowText");
	local ArcaneText = getglobal("TargetArcaneText");
	if (TargetCheck("target")) then
		MobResistDisplay:Show();
		--NameText:SetText(GetTargetName());
		ArmorText:SetText(GetArmor());
		ArmorText:SetTextColor(0.5, 0.5, 0.5);
		HolyText:SetText(GetHoly());
		HolyText:SetTextColor(1, 1, 0);
		FireText:SetText(GetFire());
		FireText:SetTextColor(1, 0, 0);
		NatureText:SetText(GetNature());
		NatureText:SetTextColor(0, 1, 0);
		FrostText:SetText(GetFrost());
		FrostText:SetTextColor(0, 0, 1);
		ShadowText:SetText(GetShadow());
		ShadowText:SetTextColor(0.5, 0, 1);
		ArcaneText:SetText(GetArcane());
		ArcaneText:SetTextColor(1, 1, 1);
	else
		MobResistDisplay:Hide();
		NameText:SetText("")
		ArmorText:SetText("");
		HolyText:SetText("");
		FireText:SetText("");
		NatureText:SetText("");
		FrostText:SetText("");
		ShadowText:SetText("");
		ArcaneText:SetText("");
	end
	
	

end

function GetTargetName()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitName(MR_Target);
end

function GetArmor()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitResistance(MR_Target, 0);
end

function GetHoly()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitResistance(MR_Target, 1);
end

function GetFire()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitResistance(MR_Target, 2);
end

function GetNature()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitResistance(MR_Target, 3);
end

function GetFrost()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitResistance(MR_Target, 4);
end

function GetShadow()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitResistance(MR_Target, 5);
end

function GetArcane()
	if TargetCheck("target") ~= true then
		return "";
	end
	
	return UnitResistance(MR_Target, 6)
end

function Report(channel)
	if TargetCheck("target") ~= true then
		return;
	end
	
	local message = "("..GetTargetName().."): "..GetArmor().."arm, "..GetHoly().."hol, "..GetFire().."fir, "..GetNature().."nat, "..GetFrost().."fro, "..GetShadow().."sha, "..GetArcane().."arc.";

	if channel == "s" or channel == "S" or channel == "say" then
		SendChatMessage(message, "SAY", GetDefaultLanguage("player"));
	elseif channel == "y" or channel == "Y" or channel == "yell" then
		SendChatMessage(message, "YELL", GetDefaultLanguage("player"));
	elseif channel == "ra" or channel == "RA" or channel == "raid" then
		SendChatMessage(message, "RAID", GetDefaultLanguage("player"));
	elseif channel == "bg" or channel == "BG" or channel == "battleground" then
		SendChatMessage(message, "BATTLEGROUND", GetDefaultLanguage("player"));
	elseif channel == "p" or channel == "P" or channel == "party" then
		SendChatMessage(message, "PARTY", GetDefaultLanguage("player"));
	elseif channel == "g" or channel == "G" or channel == "guild" then
		SendChatMessage(message, "GUILD", GetDefaultLanguage("player"));
	end
end