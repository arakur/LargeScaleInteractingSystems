module Locales

    using ..States

    abstract type Locale end

    function state_set(locale :: Locale) :: States.StateSet end

    #

    """
        A toric locale of one dimensional.
    """
    struct TorusLocale1D <: Locale
        state_set :: States.StateSet
        range :: Int
    end

    function state_set(locale :: TorusLocale1D) :: States.StateSet
        locale.state_set
    end

    #

    struct TorusLocale1DConfig
        state_array :: Vector{States.State}
    end

    function configurations(locale :: TorusLocale1D) :: Vector{TorusLocale1DConfig}
        [x for x in Base.Iterators.product(Base.Iterators.repeat(States.val_range(locale.state_set), locale.range)...)]
    end
end # module