LinkLuaModifier('modifier_bash_cooldown', 'abilities/bash_cooldown.lua', LUA_MODIFIER_MOTION_NONE)

modifier_bash_cooldown = class({
	IsPurgable = function() return false end,
	GetTexture = function() return 'spirit_breaker_greater_bash' end,
})

function BashCooldown( filterTable )
    local pIndex = filterTable.entindex_parent_const
    local cIndex = filterTable.entindex_caster_const
    local aIndex = filterTable.entindex_ability_const
    if not pIndex or not cIndex or not aIndex then
	return true
    end
	
    local parent = EntIndexToHScript(pIndex)
    local caster = EntIndexToHScript(cIndex)
    local ability = EntIndexToHScript(aIndex)
    local modifierName = filterTable.name_const
    -- Reflect only modifiers created by abilities with 'bash' flag
    if ability:HasAbilityFlag('bash') and
    	-- All bash abilities adds passive modifier on it's caster, so we should ignore it
        parent ~= caster then
        if parent:HasModifier('modifier_bash_cooldown') then
        	-- Unit was bashed in a short time. Don't add this modifier
            return false
        else
        	-- Unit bashed. Add cooldown modifier for 5s, so it won't be bashed again
            parent:AddNewModifier(caster, nil, 'modifier_bash_cooldown', {
                duration = 5
            })
        end
    end
    return true
end
