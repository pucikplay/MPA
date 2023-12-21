using Statistics
using Distributions
using DataFrames
using CSV

include("utils.jl")

nMin = 10
nMax = 6000
step = 20
reps = 1000

test = false

N = [n for n in nMin:step:nMax]
dists = [rand, myDist, truncNormal, truncNormalBump]

struct Record
    n::Int
    cmps::Vector{Int}
    cmpsx::Vector{Int}
    time::Vector{Float64}
    dists::Vector{Float64}
end

records = Vector{Record}()

for dist in dists
    empty!(records)
    for n in N
        println(n)
        record = Record(n, Vector{Int}(), Vector{Int}(), Vector{Float64}(), Vector{Float64}())
        for _ in 1:reps
            points = getRandomPoints(n, dist)
            time = @elapsed d, cmps, cmpsx = closestPair(points)
            if test
                dNaive = closestPairNaive(points)
                if d != dNaive
                    println("ERROR: $d != $dNaive")
                end
            end
            push!(record.cmps, cmps)
            push!(record.cmpsx, cmpsx)
            push!(record.time, time)
            push!(record.dists, d)
        end
        push!(records, record)
    end

    function getStatistics(record)
        cmps = record.cmps
        minC = minimum(cmps)
        maxC = maximum(cmps)
        EC = mean(cmps)
        cmps_diff = [abs(c - EC) for c in cmps]
        expC = sort(cmps_diff)[Int(floor(0.95 * length(cmps)))]
        VC = var(cmps)
        chbshvC = sqrt(VC/0.05)
        kurtC = kurtosis(cmps)

        times = record.time
        minT = minimum(times)
        maxT = maximum(times)
        ET = mean(times)
        times_diff = [abs(t - ET) for t in times]
        expT = sort(times_diff)[Int(floor(0.95 * length(times)))]

        dists = record.dists
        minD = minimum(dists)
        maxD = maximum(dists)
        ED = mean(dists)

        cmpsx = record.cmpsx
        minCX = minimum(cmpsx)
        maxCX = maximum(cmpsx)
        ECX = mean(cmpsx)

        return [Int(record.n), Int(minC), Int(maxC), EC, expC, chbshvC, kurtC, minT, maxT, ET, expT, minD, maxD, ED, Int(minCX), Int(maxCX), ECX]
    end

    data = reduce(hcat, [getStatistics(record) for record in records])
    
    stats = DataFrame(data', ["n", "minC", "maxC", "meanC", "expC", "chbshvC", "kurtC", "minT", "maxT", "meanT", "expT", "minD", "maxD", "meanD", "minCX", "maxCX", "meanCX"])

    CSV.write("$dist.csv", stats)
end