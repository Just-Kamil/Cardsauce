local jokerInfo = {
    name = 'MyHouse.wad',
    config = {
        extra = {
            x_mult = 0.8,
            x_mult2 =  3
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = 'other'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist22", set = "Other"}
    -- From my testing, pseudorandom only generates integers then appends floats, adding x_mult here shows true range
    return { vars = {card.ability.extra.x_mult, (card.ability.extra.x_mult2 + card.ability.extra.x_mult)} }
end

function jokerInfo.calculate(self,card,context)
    local x_mult = card.ability.extra.x_mult
    local x_mult2 = card.ability.extra.x_mult2
    if context.joker_main then
        if context.scoring_name == "Full House" then
            local calculated_x_mult = pseudorandom("myhouse",x_mult,x_mult2)
            return {
                message = localize{type="varaible", key="x_mult", vars={calculated_x_mult}},
                x_mult_mod = calculated_x_mult
            } 
        end
    end
end

return jokerInfo