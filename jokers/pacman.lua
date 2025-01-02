local jokerInfo = {
	name = 'PAC-MAN Incident',
	config = {
		extra = {
			mult = 0,
			mult_mod = 5
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
	return { vars = {card.ability.extra.mult} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_pacman" })
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
		if G.GAME.chips <= (G.GAME.blind.chips * 1.1) then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT})
		end
	end
	if context.joker_main and context.cardarea == G.jokers and card.ability.extra.mult > 0 then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
			mult_mod = card.ability.extra.mult, 
		}
	end
end

return jokerInfo
	