module Interactions_Examples

using ..States
using ..Interactions_Init

"""
Return the interaction of the multi-color exclusion process.
"""
function multi_color_exclusion_interaction(color_num::Int)::Interaction
    state_size = color_num + 1
    Interaction(StateSet(state_size), (s, t) -> (t, s))
end

"""
Return the interaction of the generalized exclusion process.
"""
function generalized_exclusion_interaction(max_num::Int)::Interaction
    state_size = max_num + 1
    Interaction(StateSet(state_size), (s, t) ->
        if s > 0 && t + 1 < state_size
            (s - 1, t + 1)
        else
            (s, t)
        end
    )
end

"""
Return the interaction of the lattice gas process.
"""
function lattice_gas_interaction(max_energy::Int)::Interaction
    state_size = max_energy + 1
    Interaction(StateSet(state_size), (s, t) ->
        if s > 0 && t == 0
            (t, s)
        elseif s > 1 && t > 0 && t + 1 < state_size
            (s - 1, t + 1)
        else
            (s, t)
        end
    )
end

"""
Return the interaction of the spin process.
"""
function spin_interaction()::Interaction
    state_size = 3
    Interaction(StateSet(state_size), (s, t) ->
        if s == 0 && t == 0
            (2, 1)
        elseif s == 2 && t == 1
            (1, 2)
        elseif s == 1 && t == 2
            (0, 0)
        else
            (t, s)
        end
    )
end

"""
Return the interaction of the Glauber model.
"""
function glauber_model_interaction()::Interaction
    state_size = 2
    Interaction(StateSet(state_size), (s, t) ->
        (1 - s, t)
    )
end

export
    multi_color_exclusion_interaction,
    generalized_exclusion_interaction,
    lattice_gas_interaction,
    spin_interaction,
    glauber_model_interaction

end # module Interactions_Examples