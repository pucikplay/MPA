using Statistics
using Base.Threads
using TickTock
using Distributions
using DataFrames
using CSV
include("propagation.jl")

nMin = 20
nMax = 2000
step = 40
reps = 200

N = [n for n in nMin:step:nMax]

function myDist()
    unif = rand()
    return sin(unif * pi/2)^2
end

struct Record
    n::Int
    rounds::Vector{Int}
    time::Vector{Float64}
    depth::Vector{Int}
end

records = Vector{Record}()

for n in N
    println(n)
    record = Record(n, Vector{Int}(), Vector{Float64}(), Vector{Int}())
    for _ in 1:reps
        graph = genGraph(n, myDist)
        tree = prim(graph)
        adjList = getAdjList(tree)
        for v in 1:n
            T = treeTransform(tree, v, adjList)
            time = @elapsed rounds, depth = calcRounds(T)
            push!(record.rounds, rounds)
            push!(record.time, time)
            push!(record.depth, depth)
        end
    end
    push!(records, record)
end

function getStatistics(record)
    times = record.time
    minT = minimum(times)
    maxT = maximum(times)
    ET = mean(times)
    times_diff = [abs(t - ET) for t in times]
    expT = sort(times_diff)[Int(floor(0.95 * length(times)))]
    depth = record.depth
    minD = minimum(depth)
    maxD = maximum(depth)
    ED = mean(record.depth)
    rounds = record.rounds
    minR = minimum(rounds)
    maxR = maximum(rounds)
    E = mean(rounds)
    rounds_diff = [abs(r - E) for r in rounds]
    experiment = sort(rounds_diff)[Int(floor(0.95 * length(rounds)))]
    V = var(rounds)
    chebyshev = sqrt(V/0.05)
    kurt = kurtosis(rounds)

    return [Int(record.n), Int(minR), Int(maxR), E, experiment, chebyshev, kurt, ET, expT, Int(minD), Int(maxD), ED]
end

data = reduce(hcat, [getStatistics(record) for record in records])

stats = DataFrame(data', ["n", "min", "max", "mean", "exp", "chbshv", "kurt", "time", "expT", "minD", "maxD", "depth"])

CSV.write("L3/data_myDist.csv", stats)