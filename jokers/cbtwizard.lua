local jokerInfo = {
    name = "CBT Wizard",
    config = {
        extra = {
            x_mult = 0.5,
            cash = 15
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel"
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist22", set = "Other"}
    return { vars = {card.ability.extra.x_mult, card.ability.extra.cash} }
end

function jokerInfo.calculate(self,card,context)
    -- Add X0.5 Mult when a hand is played
    if context.joker_main then
        return {
            x_mult_mod = card.ability.extra.x_mult
        }
    end
    if context.end_of_round and not card.debuff and not context.individual and not context.repetition then
        return {
            dollars = card.ability.extra.cash,
            colour = G.C.MONEY

        }
    end
end

return jokerInfo