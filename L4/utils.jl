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

function findStrip(points::Array{Point}, midX::Float64, d::Float64)::Array{Point}
    S = points[findall(p -> p.x >= midX - d && p.x <= midX + d, points)]
    sort!(S, by = p -> p.y)
    return S
end

# Internal function returning closest pair of points
function _closestPair(points::Array{Point})
    n = length(points)
    # Trivial cases
    if n == 2
        return dist(points[1], points[2]), 1
    elseif n == 3
        return min(dist(points[1], points[2]), dist(points[1], points[3]), dist(points[2], points[3])), 3
    end
    # Divide points into two equal sets
    m = n ÷ 2
    dL, cmpL = _closestPair(points[1:m])
    dR, cmpR = _closestPair(points[m+1:n])
    d = min(dL, dR)
    # Check point in strip 2d wide
    midX = (points[m].x + points[m + 1].x) / 2
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

function myDist()
    unif = rand()
    return sin(unif * pi/2)^2
end

function getRandomPoints(n::Int, dist)::(Array{Point})
    return [Point(dist(), dist()) for _ in 1:n]
end