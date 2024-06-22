local jokerInfo = {
	name = 'Another Light',
	config = {},
	text = {
		"If {C:attention}poker hand{} is a {C:attention}Flush{},",
		"create a {C:purple}Tarot{} card",
		"for that suit",
		"{C:inactive}(Must have room){}",
	},
	rarity = 2,
	cost = 7,
	canBlueprint = true,
	canEternal = true
}

--[[
function jokerInfo.locDef(self)
	return { G.GAME.probabilities.normal }
end

function jokerInfo.init(self)

end
]]--

function jokerInfo.tooltip(self, info_queue)
	info_queue[#info_queue+1] = {key = "guestartist6", set = "Other"}
end

function jokerInfo.calculate(self, context)
	if context.cardarea == G.jokers and context.before and not self.debuff then
		if context.scoring_name == "Flush" then
			local flush_type = 'Spades'
			for k, v in ipairs(context.scoring_hand) do
				if v.ability.name ~= 'Wild Card' then 
					flush_type = v.base.suit
				end
			end
			local flush_tarot = 'c_world'
			if flush_type == 'Hearts' then flush_tarot = 'c_sun' end
			if flush_type == 'Clubs' then flush_tarot = 'c_moon' end
			if flush_type == 'Diamonds' then flush_tarot = 'c_star' end
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						G.E_MANAGER:add_event(Event({
							func = function() 
								local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, flush_tarot, 'car')
								card:add_to_deck()
								G.consumeables:emplace(card)
								G.GAME.consumeable_buffer = 0
								return true
							end}))   
							card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "+1 Tarot", colour = G.C.PURPLE})                       
						return true
					end)}))
			end
		end
	end
end



return jokerInfo
	