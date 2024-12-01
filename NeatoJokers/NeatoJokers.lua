SMODS.Atlas {
    key = "NeatoJokers",
    path = "NeatoJokers.png",
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "jokerOTY", 
    name = "Joker of the Year",
    loc_txt = {
        name = "Joker of the Year",
        text = { "Retriggers all cards",
                "with a {C:attention}seal{} when played",
            },
    }, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = { repetitions = 1}},
    rarity = 3,
    atlas = "NeatoJokers",
    pos = {x = 0, y = 0},
    cost = 7, 
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:get_seal() then
                return {
                  message = localize('k_again_ex'),
                  repetitions = card.ability.extra.repetitions,
                  card = card
                }
              end
            end
        end
}

SMODS.Joker {
    key = "icecreamsandwich", 
    name = "Ice Cream Sandwich",
    loc_txt = {
        name = "Ice Cream Sandwich",
        text = {"{X:mult,C:white} X#1# {} Mult",
                "loses {X:mult,C:white} X#2# {} Mult per",
                "round played"},
    }, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {Xmult = 5, extra = 1},
    rarity = 2,
    atlas = "NeatoJokers",
    pos = {x = 1, y = 0},
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.Xmult, card.ability.extra}}
      end, 
    calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.game_over and not context.blueprint then
            if card.ability.Xmult - card.ability.extra <= 1 then 
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
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.Xmult = card.ability.Xmult - card.ability.extra
                return {
                    message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra}},
                    colour = G.C.RED
                }
                end
            end
        end
}

SMODS.Joker {
    key = 'neato_frostedprimerib'
    loc_txt = {
        name = 'Frosted Prime Rib',
        text = {
            "For the next 22 hands", -- NOTE: should this be paramatised?
            "every played card permanently gains"
            "{C:chips}+#2#{} Chips and {C:mult}+#3#{} Mult",
            "each time it is played.",
            "{C:inactive}(Currently {C:chips}#3#{C:inactive} hands left)"
        }
    },
    config = { extra  = { hands = 22, chip_mod = 2, mult_mod = 1, } }
    loc_vars = function( self, info_queue, card )
        return { vars = { card.ability.extra.chip_mod, card.ability.extra.mult_mod, card.ability.extra.hands } }
    end,
    rarity = 2,
    atlas = "NeatoJokers",
    pos = { x = 000, y = 000 }, -- TODO: get real pos values from sprite sheet
    cost = 5, --TODO: deduce reasonable cost
    calculate = function( self, card, context )
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.mult = context.other_card.ability.mult or 0
            context.other_card.ability.mult = context.other_card.ability.mult + self.ability.extra.mult_mod
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + self.ability.extra.chip_mod
        end
        elseif context.after and not context.blueprint then
            self.ability.extra.hands = self.ability.extra.hands - 1
            if card.ability.extra.hands <= 0 then
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
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}