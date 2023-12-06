using Statistics
using Base.Threads
using TickTock
using Distributions
using DataFrames
using CSV
include("propagation.jl")

nMin = 10
nMax = 1000
step = 30
reps = 100

N = [n for n in nMin:step:nMax]

function myDist()
    unif = rand()
    return sin(unif * pi/2)^2
end

struct Record
    n::Int
    rounds::Vector{Int}
end

records = Vector{Record}()

Threads.@threads for n in N
    println(n)
    record = Record(n, Vector{Int}())
    for _ in 1:reps
        graph = genGraph(n, myDist)
        tree = prim(graph)
        adjList = getAdjList(tree)
        for v in 1:n
            T = treeTransform(tree, v, adjList)
            rounds = calcRounds(T)
            push!(record.rounds, rounds)
        end
    end
    push!(records, record)
end

function getStatistics(record)
    rounds = record.rounds
    minR = minimum(rounds)
    maxR = maximum(rounds)
    E = mean(rounds)
    rounds_diff = [abs(r - E) for r in rounds]
    experiment = sort(rounds_diff)[Int(floor(0.95 * length(rounds)))]
    V = var(rounds)
    chebyshev = sqrt(V/0.05)
    kurt = kurtosis(rounds)

    return [Int(record.n), Int(minR), Int(maxR), E, experiment, chebyshev, kurt]
end

data = reduce(hcat, [getStatistics(record) for record in records])

stats = DataFrame(data', ["n", "min", "max", "mean", "exp", "chbshv", "kurt"])

CSV.write("L3/data_myDist.csv", stats)