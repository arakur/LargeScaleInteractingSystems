module ProbMeasures

    abstract type ProbMeasure{T} end

    function expectation(_ :: ProbMeasure{T}, target) :: Real where {T} end

    function prob(measure :: ProbMeasure{T}, val :: T) :: Real where {T}
        expectation(measure, x -> x == val ? 1 : 0)
    end
    
    #

    struct FiniteProbMeasure{T} <: ProbMeasure{T}
        prob :: Dict{T, <: Real}

        FiniteProbMeasure(rate_dict :: AbstractDict{T, <: Real}) where {T} = begin
            rate_sum = sum([kv.second for kv in rate_dict])
            return new{T}(Dict(kv.first => kv.second / rate_sum for kv in rate_dict))
        end
    end

    function expectation(measure :: FiniteProbMeasure{T}, target) :: Real where {T}
        sum([target(kv.first) * kv.second for kv in measure.prob])
    end

    function prob(measure :: FiniteProbMeasure{T}, val :: T) :: Real where {T}
        get(measure.prob, val, 0)
    end

    #

    measure = FiniteProbMeasure(Dict((1 => 1//1, 2 => 5//1)))

    println(measure)

    println(expectation(measure, x -> x^2))

end # module