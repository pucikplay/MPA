# structs used in graph
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

struct Tree
    E::Vector{Edge}
    V::Set{Int}
end

# generates a undirected clique graph with edge weights according to dist()
function genGraph(n::Int, dist::Function)
    vertices = Vector{Int}()
    edges = Vector{Edge}()
    matrix = Matrix{Float64}(undef,n,n)
    fill!(matrix, Inf)
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

# check if v is in tree
function isInTree(t::Tree, v::Int)
    if v in t.V
        return true
    end
    return false
end

# add edge to a tree
function addEdge(t::Tree, e::Edge)
    push!(t.E, e)
    push!(t.V, e.v)
end

# sum edge weight of tree
function getTreeWeight(t::Tree)
    return sum([e.w for e in t.E])
end

# get size of a tree
function getTreeSize(t::Tree)
    return length(t.V)
end

# get no of edges in a tree
function getTreeEdgeNumber(t::Tree)
    return length(t.E)
end

# return a tree in form of a adjacency list
function getAdjList(t::Tree)
    adjList = [Vector{Int}() for _ in 1:getTreeSize(t)]
    for e in t.E
        push!(adjList[e.u], e.v)
        push!(adjList[e.v], e.u)
    end
    return adjList
end

# display format functions
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

function _treeFormat(t::Tree)
    _string = ""
    for i in 1:length(t.E)
        _string *= "$(t.E[i])\n"
    end
    return _string
end

Base.show(io::IO, g::Graph) = print(io, _graphFormat(g))
Base.show(io::IO, t::Tree) = print(io, _treeFormat(t))