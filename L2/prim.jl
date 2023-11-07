include("graph.jl")

function primAlg(g::Graph)
    s = rand(1:g.n)
    T = Vector{Edge}()
    pq = PriorityQueue{Edge, Float64}()
    for edge in g.M[s,:]
        if !isnothing(edge)
            push!(pq, edge)
        end
    end

    while !isempty(pq)
        edge = popfirst!(pq)
        addEdge(T, edge)
        for e in g.M[edge.v,:]
            if !isInTree(T,e.v)
                push!(pq, e)
            end
        end
    end

    return T
end