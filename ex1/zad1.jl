"""
Metody Probabilistyczne i Statystyka
Zadanie 1
Wyznaczanie wartści całki metodą Monte Carlo.
"""

using Distributions
using Plots
using StatsPlots
using LaTeXStrings
import Random
Random.Xoshiro(42) # seed

function approximate_integral(foo::Function, a, b, n::Int, M)
    """
    Approximates the integral of a function foo on the interval [a, b] using the Monte Carlo method.
    """
    x = rand(Uniform(a, b), n)
    y = rand(Uniform(0, M), n)

    C = count(y .≤ foo.(x))

    # @assert all(foo.(x) .≤ M)

    approximated_integral = C / n * (b - a) * M
    return approximated_integral
end

foo1(x) = ∛x # =12
foo2(x) = sin(x) # =2
foo3(x) = 4 * x * (1 - x)^3 # =0.2
foo4(x) = 2 * √(1 - x^2) # =π

foos = [foo1, foo2, foo3, foo4]

as = [0, 0, 0, -1]
bs = [8, π, 1, 1]

true_integrals = [12, 2, 0.2, π]

titles = [L"\int_0^8 \sqrt[3]{x} dx", L"\int_0^{\pi} \sin(x) dx", L"\int_0^1 4x(1-x)^3 dx", L"\pi"]

for (i, (foo, a, b, true_integral, title)) in enumerate(zip(foos, as, bs, true_integrals, titles))
    M = 2 * maximum(foo(x) for x in a:0.001:b)

    k = 50

    ns = 50:50:5000
    integrals(n) = [approximate_integral(foo, a, b, n, M) for _ in 1:k]
    results = [integrals(n) for n in ns]

    scatter(collect(Iterators.flatten(ones(k) * ns')),
        collect(Iterators.flatten(results)),
        marker=(1, :blue, stroke(0)),
        label="single probe",
        dpi=300
    )
    scatter!(ns, mean.(results), yerror=std.(results), marker=(4, :red, stroke(1, 0.2, :red)), label="mean ± std")
    hline!([true_integral], linewidth=2, color=:green, label="true value")

    xlabel!("n")
    # ylabel!("integral")
    title!(title)

    savefig("./ex1/results/z1_$i.png")
end

# std
integrals(n) = [approximate_integral(foo4, -1, 1, n, 4) for _ in 1:50]
results = [integrals(n) for n in 50:50:5000]
plot(50:50:5000, std.(results))
