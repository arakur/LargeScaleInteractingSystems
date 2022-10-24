module ConservedQuantities

import Base.range
import Nemo: MatrixSpace, ZZ, fmpz_mat, kernel
import Graphs: DiGraph, add_edge!
import TikzGraphs
import Plots: plot, quiver!
import LaTeXStrings

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

#

struct Interaction
    state_set :: StateSet
    map # :: Int × Int → Int × Int
        # as State × State → State × State

    Interaction(state_set, map) = new(state_set, map)
end

"""
    interaction_plot(intr :: Interaction, mode = :coord)

    Plot the interaction with regarding the mapping as a directed graph.

    mode = :coord: plot the graph with xy-coordinates. (default)
    mode = :graph: plot the graph without aligning the nodes.
"""
function interaction_plot(intr :: Interaction, mode = :coord)
    if mode == :coord

        fixed_x, fixed_y = [], []
        quiver_x, quiver_y = [], []
        quiver_x1, quiver_y1 = [], []
        for s in 0:intr.state_set.size - 1
            for t in 0:intr.state_set.size - 1
                s1, t1 = intr.map(s, t)
            
                if s == s1 && t == t1
                    push!(fixed_x, s)
                    push!(fixed_y, t)
                else
                    slide = abs(s1 - s) * 0.05
    
                    push!(quiver_x, s + slide)
                    push!(quiver_y, t)
                    push!(quiver_x1, s1 - s)
                    push!(quiver_y1, t1 - t)
                end
            end
        end
    
        plot(
            fixed_x,
            fixed_y,
            color = :white,
            seriestype = :scatter,
            markersize = 3,
            legend = false,
            xlabel = "\$s_1\$",
            ylabel = "\$s_2\$",
            xticks = (
                0:intr.state_set.size - 1,
                [i for i in string.(0:intr.state_set.size - 1)]
            ),
            yticks = (
                0:intr.state_set.size - 1,
                [i for i in string.(0:intr.state_set.size - 1)]
            ),
            )
        quiver!(quiver_x, quiver_y, color = :black, quiver=(quiver_x1, quiver_y1))

    elseif mode == :graph

        g = DiGraph(intr.state_set.size * intr.state_set.size)
        loop_dict = Dict()
        vertices = ["(" * s * "," * t * ")" for s in string.(0:intr.state_set.size-1) for t in string.(0:intr.state_set.size-1)]
        for s in 0:intr.state_set.size - 1
            for t in 0:intr.state_set.size - 1
                s1, t1 = intr.map(s, t)
            
                index = s * intr.state_set.size + t + 1
                index1 = s1 * intr.state_set.size + t1 + 1
                if s == s1 && t == t1
                    loop_dict[(index, index)] = "loop below"
                end
                add_edge!(g, index, index1)
            end
        end

        TikzGraphs.plot(g, vertices, edge_styles = loop_dict)

    else
        error("unexpected mode specified; mode must be :coord or :graph")
    end
end

#

"""
    conserved_quantities(intr :: Interaction) :: fmpz_mat

    Return the set of assignments of the value of conserved quantities.
"""
function conserved_quantities(intr :: Interaction) :: fmpz_mat
    mat = zeros(BigInt, 0, non_base_size(intr.state_set))
    for s0 in val_range(intr.state_set)
        for t0 in val_range(intr.state_set)
            (s1, t1) = intr.map(s0, t0)
            vec = zeros(BigInt, non_base_size(intr.state_set))
            for (s, c) in [(s0, 1), (t0, 1), (s1, -1), (t1, -1)]
                if s != 0
                    vec[s] += c
                end
            end
            mat = [mat; vec']
        end
    end

    S = MatrixSpace(ZZ, intr.state_set.size * intr.state_set.size, non_base_size(intr.state_set))
    
    mat = S(mat)
    
    kernel(mat)[2]
end

#

"""
    multi_color_exclusion_interaction(color_num :: Int) :: Interaction

    Return the interaction of the multi-color exclusion process.
"""
function multi_color_exclusion_interaction(color_num :: Int) :: Interaction
    state_size = color_num + 1
    Interaction(StateSet(state_size), (s, t) -> (t, s))
end

"""
    generalized_exclusion_interaction(max_num :: Int) :: Interaction

    Return the interaction of the generalized exclusion process.
"""
function generalized_exclusion_interaction(max_num :: Int) :: Interaction
    state_size = max_num + 1
    Interaction(StateSet(state_size), (s, t) -> 
        if s > 0 && t + 1 < state_size
            (s-1, t+1)
        else
            (s,t)
        end
    )
end

"""
    lattice_gas_interaction(max_energy :: Int) :: Interaction

    Return the interaction of the lattice gas process.
"""
function lattice_gas_interaction(max_energy :: Int) :: Interaction
    state_size = max_energy + 1
    Interaction(StateSet(state_size), (s, t) -> 
        if s > 0 && t == 0
            (t, s)
        elseif s > 1 && t > 0 && t + 1 < state_size
            (s-1, t+1)
        else
            (s, t)
        end
    )
end

"""
    spin_interaction()

    Return the interaction of the spin process.
"""
function spin_interaction() :: Interaction
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
    glauber_model_interaction()

    Return the interaction of the Glauber model.
"""
function glauber_model_interaction() :: Interaction
    state_size = 2
    Interaction(StateSet(state_size), (s, t) -> 
        (1-s, t)
    )
end

# exports

export
    Interaction,
    StateSet,
    interaction_plot,
    conserved_quantities,
    multi_color_exclusion_interaction,
    generalized_exclusion_interaction,
    lattice_gas_interaction,
    spin_interaction,
    glauber_model_interaction

end # module