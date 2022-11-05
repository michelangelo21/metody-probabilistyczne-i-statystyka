using Distributions
using Plots
using StatsPlots
import Random
Random.Xoshiro()
Random.seed!(42)
plotlyjs()

function approximate_integral(foo::Function, a::Number, b::Number, n::Int, M::Number)
    """
    Approximates the integral of a function foo on the interval [a, b] using the Monte Carlo method.
    """
    x = rand(Uniform(a, b), n)
    y = rand(Uniform(0, M), n)

    C = count(y .≤ foo.(x))

    approximated_integral = C / n * (b - a) * M
    return approximated_integral
end

approximate_integral(x -> ∛x, 0, 8, 50, 10)

maximum(∛x for x in 0:0.0001:8)

foo(x) = ∛x # =12
foo(x) = sin(x) # =2
foo(x) = 4 * x * (1 - x)^3 # =0.2


a = 0
b = 8
# M = 10 * maximum(foo(x) for x in a:0.001:b)
M = 2

true_integral = 12

k = 50

ns = 50:50:5000
integrals(n) = [approximate_integral(foo, a, b, n, M) for _ in 1:k]
results = [integrals(n) for n in ns]

scatter(collect(Iterators.flatten(ones(k) * ns')),
    collect(Iterators.flatten(results)),
    marker=(1, :blue, stroke(0)),
    label="single probe"
)
scatter!(ns, mean.(results), marker=(2, :red, stroke(0)), label="mean")
hline!([12], linewidth=2, color=:green, label="true value")
xlabel!("n")
ylabel!("integral")
title!("∫₀⁸ ∛x dx")
savefig

# symbolic integration
using Symbolics
using SymbolicNumericIntegration
@variables x
integrate(cbrt(x))