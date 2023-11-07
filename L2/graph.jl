struct Edge
    u::Int
    v::Int
    w::Float64
end

struct Graph
    n::Int
    V::Vector{Int}
    E::Vector{Edge}
    M::Matrix{Float64}
end

function genGraph(n::Int, dist::Function)
    vertices = Vector{Int}()
    edges = Vector{Edge}()
    matrix = fill(Inf,n,n)
    for i in 1:n
        push!(vertices, i)
        for j in i+1:n
            weight = dist()
            push!(edges, Edge(i,j,weight))
            matrix[i,j] = weight
            matrix[j,i] = weight
        end
    end
    return Graph(n, vertices, edges, matrix)
end

function _graphFormat(g::Graph)
    _string = "$(g.n)\n"
    _string *= "$(g.V)\n"
    for i in 1:g.n
        _string *= "$(g.E[i])\n"
    end
    for i in 1:g.n
        _string *= "$(g.M[i,:])\n"
    end
    return _string
end

Base.show(io::IO, g::Graph) = print(io, _graphFormat(g))