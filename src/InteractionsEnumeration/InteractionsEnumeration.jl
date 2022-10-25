module InteractionsEnumeration

    using ..States: StateSet, val_range
    using ..Interactions: Interaction
    using JuMP
    using ConstraintSolver
    const CS = ConstraintSolver # synonym

    function enumerate_interactions(state_set :: StateSet, time_limit = Inf) :: Vector{Interaction}
        m = Model(optimizer_with_attributes(CS.Optimizer, "all_solutions" => true, "time_limit" => time_limit))
    
        state_size = state_set.size

        @variable(m, 0 <= φ1[0:state_size-1, 0:state_size-1] <= state_size - 1, Int)
        @variable(m, 0 <= φ2[0:state_size-1, 0:state_size-1] <= state_size - 1, Int)
    
        for s in val_range(state_set)
            for t in val_range(state_set)
                for s1 in val_range(state_set)
                    for t1 in val_range(state_set)
                        b1 = @variable(m, binary=true)
                        b2 = @variable(m, binary=true)
                        @constraint(m, b1 := {φ1[s,t] != s || φ2[s,t] != t})
                        @constraint(m, b2 := {φ1[s,t] == s1 && φ2[s,t] == t1})
                        @constraint(m, b1 => {b2 => {φ1[t1,s1] == t && φ2[t1,s1] == s}})
                    end
                end
            end
        end

        optimize!(m)

        num_sols = MOI.get(m, MOI.ResultCount())
        
        interactions = []
        for sol in 1:num_sols
            push!(interactions, Interaction(state_set, (s, t) -> (Int(JuMP.value.(φ1; result=sol)[s, t]), Int(JuMP.value.(φ2; result=sol)[s, t]))))
        end

        interactions
    end

end # module