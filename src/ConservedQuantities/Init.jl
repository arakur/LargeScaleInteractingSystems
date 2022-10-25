module ConservedQuantities_Init

    import ..States: non_base_size, val_range
    import ..Interactions: Interaction

    import Nemo: MatrixSpace, ZZ, fmpz_mat, kernel

    """
        conserved_quantities(intr :: Interaction) :: fmpz_mat

        Return the set of assignments of the value of conserved quantities.
    """
    function conserved_quantities(intr :: Interaction) :: fmpz_mat
        mat = zeros(BigInt, 0, non_base_size(intr.state_set))
        for s0 in val_range(intr.state_set), t0 in val_range(intr.state_set)
            (s1, t1) = intr.map(s0, t0)

            vec = zeros(BigInt, non_base_size(intr.state_set))
            for (s, c) in [(s0, 1), (t0, 1), (s1, -1), (t1, -1)]
                if s != 0
                    vec[s] += c
                end
            end
            mat = [mat; vec']
        end

        S = MatrixSpace(ZZ, intr.state_set.size * intr.state_set.size, non_base_size(intr.state_set))
        mat = S(mat)
        kernel(mat)[2]
    end

    #



    # exports

    export
        conserved_quantities

end # module ConservedQuantities_Init