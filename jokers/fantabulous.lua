local jokerInfo = {
	name = 'Fantabulous Joker',
	config = {
		money_mod = 3,
		sell_val = 40
	},
	rarity = 1,
	cost = 20,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
	return { vars = {card.ability.sell_val, card.ability.money_mod} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_fantabulous" })
	card.sell_cost = card.ability.sell_val
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		card.ability.sell_val = card.ability.sell_val - card.ability.money_mod
		card.sell_cost = card.ability.sell_val
		if not next(SMODS.find_card('j_csau_bunji')) then
			if card.ability.sell_val > 0 then
				return {
					message = localize('k_val_down'),
					colour = G.C.MONEY,
					card = card
				}
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
													 func = function()
														 G.jokers:remove_card(card)
														 card:remove()
														 card = nil
														 return true
													 end
						}))
						return true
					end
				}))
				return {
					message = localize('k_worthless_ex'),
					colour = G.C.MONEY
				}
			end
		end

	end
end

return jokerInfo
	