local mod	= DBM:NewMod("CharlgaRazorflank", "DBM-Party-Classic", 11)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("@file-date-integer@")
mod:SetCreatureID(4421)
--mod:SetEncounterID(1661)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 8292",
	"SPELL_CAST_SUCCESS 8358",
	"SPELL_AURA_APPLIED 8361"
)

local warningPurity				= mod:NewTargetNoFilterAnnounce(8361, 2)
local warningManaSpike			= mod:NewSpellAnnounce(8358, 2)

local specWarnChainBolt			= mod:NewSpecialWarningInterrupt(8292, "HasInterrupt", nil, nil, 1, 2)

local timerChainBoltCD			= mod:NewAITimer(180, 8292, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)

function mod:OnCombatStart(delay)
	timerChainBoltCD:Start(1-delay)
end

do
	local ChainBolt = DBM:GetSpellInfo(8292)
	function mod:SPELL_CAST_START(args)
		--if args.spellId == 8292 then
		if args.spellName == ChainBolt and args:IsSrcTypeHostile() then
			timerChainBoltCD:Start()
			if self:CheckInterruptFilter(args.sourceGUID, false, true) then
				specWarnChainBolt:Show(args.sourceName)
				specWarnChainBolt:Play("kickcast")
			end
		end
	end
end

do
	local ManaSpike = DBM:GetSpellInfo(8358)
	function mod:SPELL_CAST_SUCCESS(args)
		--if args.spellId == 8358 then
		if args.spellName == ManaSpike then
			warningManaSpike:Show()
		end
	end
end

do
	local Purity = DBM:GetSpellInfo(8361)
	function mod:SPELL_AURA_APPLIED(args)
		--if args.spellId == 8361 then
		if args.spellName == Purity then
			warningPurity:Show(args.destName)
		end
	end
end