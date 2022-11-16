"""
Metody Probabilistyczne i Statystyka
Zadanie 1
"""

using Distributions
using Plots
using StatsPlots
using LaTeXStrings
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

@profview balls_and_bins(100_000)
@benchmark balls_and_bins(100_000)