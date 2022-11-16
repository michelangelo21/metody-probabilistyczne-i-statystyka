"""
Metody Probabilistyczne i Statystyka
Zadanie 1
"""

using Distributions
using Plots
using StatsPlots
using LaTeXStrings
using JLD2, FileIO
import Random
Random.Xoshiro(42) # seed

struct BallsnBinsStats
    n::Int64 # number of bins
    B::Int64 # birthday paradox
    U::Int64 # empty bins after n balls
    L::Int64 # maximum load after n balls
    C::Int64 # every bin has at least one ball
    D::Int64 # every bin has at least two balls
end


function balls_and_bins(n)
    """
    Simulates the balls and bins problem.
    """
    bins = zeros(Int, n)

    Bₙ = Uₙ = Lₙ = Cₙ = Dₙ = 0
    m = 0
    while Dₙ == 0
        m += 1

        bin_number = rand(DiscreteUniform(1, n))
        bins[bin_number] += 1

        if Bₙ == 0 && bins[bin_number] == 2
            Bₙ = m
        end
        if m == n
            Uₙ = count(b -> b == 0, bins)
            Lₙ = maximum(bins)
        end
        if Cₙ == 0 && bins[bin_number] == 1 && all(b -> b >= 1, bins)
            Cₙ = m
        end
        if Cₙ != 0 && bins[bin_number] == 2 && all(b -> b >= 2, bins)
            Dₙ = m
        end
    end
    return BallsnBinsStats(n, Bₙ, Uₙ, Lₙ, Cₙ, Dₙ)
end

# @profview balls_and_bins(100_000)
# @benchmark balls_and_bins(100_000)
n = 1000:1000:100_000
k = 50
results = [balls_and_bins(i) for i in n, _ in 1:k]

# save("ex2/results/results.jld2", "results", results)
# results = load("ex2/results/results.jld2", "results")

b = mean([r.B for r in results], dims=2)
u = mean([r.U for r in results], dims=2)
l = mean([r.L for r in results], dims=2)
c = mean([r.C for r in results], dims=2)
d = mean([r.D for r in results], dims=2)

scatter(n, b ./ n, xlabel="n", label=:none, title=L"\frac{b(n)}{n}")
scatter(n, b ./ sqrt.(n), xlabel="n", title=L"\frac{b(n)}{\sqrt{n}}", label=:none, label=:none)

scatter(n, u ./ n, xlabel="n", label=:none, title=L"\frac{u(n)}{n}")

scatter(n, l ./ log.(n), xlabel="n", label=:none, title=L"\frac{l(n)}{\ln{n}}")
scatter(n, l ./ (log.(n) ./ log.(log.(n))), label=:none, title=L"\frac{l(n)}{(\ln n)/\ln{\ln{n}}}")
scatter(n, l ./ log.(log.(n)), label=:none, title=L"\frac{l(n)}{\ln{\ln{n}}}")

scatter(n, c ./ n, xlabel="n", label=:none, title=L"\frac{c(n)}{n}")
scatter(n, c ./ (n .* log.(n)), xlabel="n", label=:none, title=L"\frac{c(n)}{n\ln{n}}")
scatter(n, c ./ n .^ 2, xlabel="n", label=:none, title=L"\frac{c(n)}{n^2}")

scatter(n, d ./ n, xlabel="n", label=:none, title=L"\frac{d(n)}{n}")
scatter(n, d ./ (n .* log.(n)), xlabel="n", label=:none, title=L"\frac{d(n)}{n\ln{n}}")
scatter(n, d ./ n .^ 2, xlabel="n", label=:none, title=L"\frac{d(n)}{n^2}")

scatter(n, (d - c) ./ n, xlabel="n", label=:none, title=L"\frac{d(n) - c(n)}{n}")
scatter(n, (d - c) ./ (n .* log.(n)), xlabel="n", label=:none, title=L"\frac{d(n) - c(n)}{n\ln{n}}")
scatter(n, (d - c) ./ (n .* log.(log.(n))), xlabel="n", label=:none, title=L"\frac{d(n) - c(n)}{n\ln{\ln{n}}}")
