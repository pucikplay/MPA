struct Point
    x::Float64
    y::Float64
end

function cmpY(a::Point, b::Point)::Float64
    return a.y - b.y
end

function dist(a::Point, b::Point)::Float64
    return sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

function findStrip(points::Array{Point}, midY::Float64, d::Float64)::Array{Point}
    S = points[findall(p -> p.y >= midY - d && p.y <= midY + d, points)]
    sort!(S, by = p -> p.x)
    return S
end

# Internal function returning closest pair of points
function _closestPair(points::Array{Point})
    n = length(points)
    # Trivial cases
    if n < 2
        return Inf, 0
    end
    if n == 2
        return dist(points[1], points[2]), 1
    end
    # Divide points into two equal sets
    m = n ÷ 2
    dL, cmpL = _closestPair(points[1:m])
    dR, cmpR = _closestPair(points[m+1:n])
    d = min(dL, dR)
    # Check point in strip 2d wide
    midY = (points[m].y + points[m + 1].y) / 2
    S = findStrip(points, midX, d)
    cmp = 0
    for i in eachindex(S)
        for j in i+1:min(length(S), i+7)
            cmp += 1
            d = min(d, dist(S[i], S[j]))
        end
    end

    return d, cmpL + cmpR + cmp
end

# External function with preprocessing
function closestPair(points::Array{Point})
    sort!(points, by = p -> p.x)
    return _closestPair(points)
end

function closestPairNaive(points::Array{Point})
    min_dist = Inf
    for i in eachindex(points)
        for j in eachindex(points)
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

function getRandomPoints(n::Int, dist)::(Array{Point})
    return [Point(dist(), dist()) for _ in 1:n]
end