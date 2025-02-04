local jokerInfo = {
    name = "The Dud",
    config = {},
    rarity = 1,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist20", set = "Other"}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { colours = {get_stake_col(4)} }}
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_dud" })
end

function jokerInfo.calculate(self, card, context)
    if context.selling_self then
        local pool = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.eternal or v.ability.perishable or v.ability.rental then
                pool[#pool+1] = v
            end
        end
        if #pool > 0 then
            local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('dud_choice'))
            for k, v in pairs(G.jokers.cards) do
                if v == chosen_joker then
                    if v.ability.eternal then
                        v.ability.eternal = false
                    end
                    if v.ability.perishable then
                        v.ability.perishable = false
                    end
                    if v.ability.rental then
                        v.ability.rental = false
                    end
                end
                v:juice_up()
            end
        end
    end
end

return jokerInfo