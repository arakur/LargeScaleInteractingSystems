#=

    ℒ f(x) := ∑_{e ∈ E₀; o(e) = x} (f(t(e)) - f(o(e))) p(o(e), t(e)) μ(o(e))

    u_k := (σ_k - 1) 1_{\{0\}}

    f_i : (σ_j - 1) f_i = δ_{i j}

    # 

    E₀ = {e_1, op(e_1), ...}

    ℒ f_i(x) = ∑_{e ∈ E₀; o(e) = x} (f_i(t(e)) - f_i(o(e))) p(o(e), t(e)) μ(o(e))

=#

d = 2

N = [[0, 0], [1, 0], [0, 1], [1, 1]]

# coefficient of p(x0, x1); let p(x,y) := if x==x0 && y==x1 then 1 else 0

x0 = [0, 0]
x1 = [1, 0]

s = 0
for i in 1:d
    # ℒ f_i(x0) = 2 (f_i(x1) - f_i(x0))
    
end
