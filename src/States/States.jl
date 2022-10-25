module States

import Base.range

struct StateSet
    size  :: Int

    StateSet(size) = new(size)
end

function non_base_size(state_set :: StateSet)
    return state_set.size - 1
end

function val_range(state_set :: StateSet) 
    0:state_set.size-1
end

#

struct State
    val :: Int

    State(state_set, val) = val >= 0 && val < state_set.size ? new(val) : Nothing
end

function Base.show(io :: IO, state :: State)
    if state.val == 0
        print(io, "*")
    else
        print(io, "s", state.val)
    end
end

"""
    base(state_set :: StateSet) :: State

    The base state which is the state with value 0.
"""
function base(state_set :: StateSet) :: State
    return State(state_set, 0)
end

struct NonBase
    index :: Int

    NonBase(s :: State) = s.val == 0 ? Nothing : new(s.val) 
end

function Base.show(io :: IO, nb :: NonBase)
    print(io, "s", Int(nb.index))
end

export
    StateSet

end # module
