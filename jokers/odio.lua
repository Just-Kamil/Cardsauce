local jokerInfo = {
	name = 'Odious Joker',
	config = {
		extra = {
			form = "odio",
			formNum = 1
		}
	},
	rarity = 3,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	streamer = "other",
}

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_odio" })
end

function jokerInfo.in_pool(self, args)
	if G.GAME.round_resets.ante < 9 then
		return true
	end
end

local forms = {
	[1] = "odio",
	[2] = "odio2",
	[3] = "odio3",
	[4] = "odio4",
	[5] = "odio5",
	[6] = "odio6",
	[7] = "odio7",
	[8] = "odio8",
	[9] = "odio9"
}

for i = 1, #forms do
	if forms[i] then
		SMODS.Atlas({ key = forms[i], path ="jokers/"..forms[i]..".png", px = 71, py = 95 })
	end
end

local function updateSprite(card)
	if card.ability.extra.form then
		if card.config.center.atlas ~= card.ability.extra.form then
			card.config.center.atlas = "csau_"..card.ability.extra.form
			card:set_sprites(card.config.center)
		end
	end
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = "j_csau_"..card.ability.extra.form or self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	localize{type = 'descriptions', key = "j_csau_"..card.ability.extra.form or self.key, set = self.set, nodes = desc_nodes, vars = {}}
end

function jokerInfo.calculate(self, card, context)
	if context.setting_blind and G.GAME.blind.boss and not card.debuff and not (context.blueprint_card or card).getting_sliced and not context.blueprint_card then
		if not card.ability.extra.form ~= "odio9" and G.GAME.round_resets.ante ~= 1 then
			local form = forms[G.GAME.round_resets.ante]
			local trigger = true
			if trigger then
				trigger = false
				card.ability.extra.form = form
				card:juice_up(1, 1)
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_'..card.ability.extra.form), colour = G.C.PURPLE, no_juice = true})
				updateSprite(card)
				if card.ability.extra.form == "odio3" or card.ability.extra.form == "odio6" or card.ability.extra.form == "odio8" then
					local tarot, loops
					if card.ability.extra.form == "odio3" then
						tarot = 'c_emperor'
						loops = 2
					elseif card.ability.extra.form == "odio6" then
						tarot = 'c_strength'
						loops = 3
					elseif card.ability.extra.form == "odio8" then
						tarot = 'c_death'
						loops = 4
					end
					for i = 1, loops do
						local _card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, tarot, 'car')
						_card:set_edition({negative = true}, true, true)
						_card:add_to_deck()
						G.consumeables:emplace(_card)
						G.GAME.consumeable_buffer = 0
					end
				end
			end
		end
	end
	if context.end_of_round and G.GAME.blind.boss and not context.other_card then
		if not card.getting_sliced and card.ability.extra.form ~= "odio9" then
			if G.GAME.round_resets.ante == 8 then
				local form = forms[9]
				local trigger = true
				if trigger then
					trigger = false
					card.ability.extra.form = form
					updateSprite(card)
					card:juice_up(1, 1)
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_'..card.ability.extra.form), colour = G.C.PURPLE, no_juice = true})
				end
				check_for_unlock({ type = "final_odio" })
			else
				local beforeForm = card.ability.extra.form
				local form = forms[1]
				local trigger = true
				if trigger then
					trigger = false
					card.ability.extra.form = form
					updateSprite(card)
					if beforeForm ~= forms[1] then
						card:juice_up(1, 1)
					end
				end
			end
		end
	end
	if context.individual and context.cardarea == G.play and not card.debuff then
		if card.ability.extra.form == "odio2" then
			local big_card = nil
			for k, v in ipairs(context.full_hand) do
				if not big_card or v.base.nominal > big_card.base.nominal then big_card = v end
			end
			sendDebugMessage("Biggest scoring card value: "..big_card.base.nominal)
			if not big_card.debuff and context.other_card == big_card then
				return {
					mult = big_card.base.nominal,
					card = big_card,
				}
			end
		end
	end
	if context.joker_main and context.cardarea == G.jokers then
		if card.ability.extra.form == "odio4" then
			local empty_hand_slots = 5 - #context.full_hand
			send(empty_hand_slots)
			local slot_mult = empty_hand_slots * 5
			if slot_mult > 0 then
				return {
					message = localize { type = 'variable', key = 'a_mult', vars = {slot_mult} },
					mult_mod = slot_mult,
				}
			end
		end
	end
	if context.cardarea == G.jokers and context.before and not card.debuff then
		if card.ability.extra.form == "odio5" then
			local faces = {}
			for k, v in ipairs(context.scoring_hand) do
				if v:is_face() then
					faces[#faces+1] = v
					v:set_ability(G.P_CENTERS.m_glass, nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					}))
				end
			end
			if #faces > 0 then
				return {
					message = localize('k_glass'),
					colour = G.C.RED,
					card = card
				}
			end
		end
	end
	if context.other_joker and card ~= context.other_joker then
		if card.ability.extra.form == "odio7" then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			}))
			return {
				message = localize{type='variable',key='a_xmult',vars={1.5}},
				Xmult_mod = 1.5
			}
		end
	end
	if context.selling_self then
		if card.ability.extra.form == "odio9" then
			if G.STATE == G.STATES.SELECTING_HAND then
				G.GAME.chips = G.GAME.blind.chips
				G.STATE = G.STATES.HAND_PLAYED
				G.STATE_COMPLETE = true
				end_round()
			end
		end
	end
end

function jokerInfo.update(self, card)
	if G.screenwipe then
		updateSprite(card)
	end
end

return jokerInfo
	