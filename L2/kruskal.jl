include("graph.jl")

Base.isless(e1::Edge, e2::Edge) = isless(e1.w, e2.w)

function union(S::Array{Int}, a::Int, b::Int)
    if a < b
        old = b
        new = a
    else
        old = a
        new = b
    end
    for i in 1:length(S)
        if S[i] == old
            S[i] = new
        end
    end
end

function kruskal(g::Graph)
    set = zeros(Int, g.n)
    for v in g.V
        set[v] = v
    end
    F = Tree(Vector{Edge}(), Set{Int}())
    E = sort(g.E)
    
    idx = 1
    while getTreeEdgeNumber(F) < g.n - 1
        e = E[idx]
        if set[e.u] != set[e.v]
            addEdge(F, e)
            union(set, set[e.u], set[e.v])
        end
        idx += 1
    end

    return F
end