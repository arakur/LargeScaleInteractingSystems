module Interactions_Plot

    import ..States
    import ..Interactions_Init: Interaction

    import Graphs: DiGraph, add_edge!
    import TikzGraphs
    import Plots: plot, quiver!
    import LaTeXStrings

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

    export
        interaction_plot

end # module Interactions_Plot

