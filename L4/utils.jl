using Statistics

struct Point
    x::Float64
    y::Float64
end

function cmpX(a::Point, b::Point)::Float64
    return a.x - b.x
end

function dist(a::Point, b::Point)::Float64
    return sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

# Internal function returning closest pair of points
function _closestPair(points::Array{Point})
    n = length(points)
    # Trivial cases
    if n < 2
        return Inf, 0, 0
    end
    if n == 2
        return dist(points[1], points[2]), 1, 0
    end

    # Divide points into two equal sets
    y_values = [p.y for p in points]
    medianY = median(y_values)

    setL = [p for p in points if p.y <= medianY]
    setR = [p for p in points if p.y > medianY]

    # Recursively find minimal distances in halves
    dL, cmpL, cmpxL = _closestPair(setL)
    dR, cmpR, cmpxR = _closestPair(setR)
    d = min(dL, dR)

    # Check point in strip 2d wide
    S = [p for p in points if p.y >= medianY - d && p.y <= medianY + d]
    cmp = 0
    cmpx = 0
    for i in eachindex(S)
        j = i - 1
        while j >= 1 && cmpX(S[i], S[j]) < d
            cmp += 1
            cmpx += 1
            d = min(d, dist(S[i], S[j]))
            j -= 1
        end
        if j >= 1
            cmpx += 1
        end
    end

    return d, cmpL + cmpR + cmp, cmpxL + cmpxR + cmpx
end

# External function with preprocessing
function closestPair(points::Array{Point})
    sort!(points, by = p -> p.x)
    return _closestPair(points)
end

function closestPairNaive(points::Array{Point})
    min_dist = Inf
    for i in eachindex(points)
        for j in i+1:length(points)
            min_dist = min(min_dist, dist(points[i], points[j]))
        end
    end

    return min_dist
end

function myDist()
    unif = rand()
    return sin(unif * pi/2)^2
end

d = Truncated(Normal(0, 1), 0, 1)
function truncNormal()
    return rand(d)
end

d = Truncated(Normal(0.5, 0.5), 0, 1)
function truncNormalBump()
    return rand(d)
end

function getRandomPoints(n::Int, dist)::(Array{Point})
    return [Point(dist(), dist()) for _ in 1:n]
end