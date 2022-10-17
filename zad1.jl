using Distributions
using Plots
using StatsPlots
import Random
Random.Xoshiro()
Random.seed!(42)

function approximate_integral(foo::Function, a::Number, b::Number, n::Int, M::Number)
    x = rand(Uniform(a, b), n)
    y = rand(Uniform(0, M), n)

    C = count(y .≤ foo.(x))

    approximated_integral = C / n * (b - a) * M
    return approximated_integral
end

approximate_integral(x -> ∛x, 0, 8, 50, 10)

maximum(∛x for x in 0:0.0001:8)

foo(x) = ∛x
foo(x) = sin(x)
foo(x) = 4 * x * (1 - x)^3


n = 50
a = 0
b = 8
# M = 10 * maximum(foo(x) for x in a:0.001:b)
M = 2

k = 50

ns = 50:50:5000
integrals(n) = [approximate_integral(foo, a, b, n, M) for i in 1:k]
results = [integrals(n) for n in ns]

scatter(collect(Iterators.flatten(ones(k) * ns')), collect(Iterators.flatten(results)), label="asdf")

dotplot(ns, results, marker=(:blue, stroke(0)), label="")
scatter!(ns, mean.(results), marker=(:red, stroke(0)), label="mean")

