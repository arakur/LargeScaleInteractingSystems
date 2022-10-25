module Interactions_Init

    import ..States: StateSet

    struct Interaction
        state_set :: StateSet
        map # :: Int × Int → Int × Int
            # as State × State → State × State

        Interaction(state_set, map) = new(state_set, map)
    end

    export Interaction

end # module Interactions_Init