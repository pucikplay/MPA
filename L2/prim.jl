include("graph.jl")

using DataStructures

function prim(g::Graph)
    s = rand(1:g.n)
    T = Tree(Vector{Edge}(), Set{Int}([s]))
    pq = PriorityQueue{Edge, Float64}()
    for i in 1:g.n
        enqueue!(pq, Edge(s, i, g.M[s,i]), g.M[s,i])
    end

    while getTreeSize(T) < g.n
        edge = dequeue!(pq)
        u = edge.v
        if !isInTree(T,u)
            addEdge(T, edge)
            for v in 1:g.n
                e = Edge(u, v, g.M[u,v])
                if !isInTree(T,v) && !haskey(pq, e)
                    enqueue!(pq, e, g.M[u,v])
                end
            end
        end
    end

    return T
end