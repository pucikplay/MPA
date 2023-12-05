include("../L2/graph.jl")
include("../L2/prim.jl")

struct Node
    id::Int
    children::Vector{Int}
end

struct TREE
    root::Int
    nodes::Vector{Node}
end

# recursive function for adding vertices to tree
function addToTree(v::Int, adjList::Array{Vector{Int}}, nodes::Vector{Node}, marked::Array{Bool})
    for u in adjList[v]
        if !marked[u]
            push!(nodes[v].children, u)
        end
    end
    marked[v] = true
    for child in nodes[v].children
        addToTree(child, adjList, nodes, marked)
    end
end

# transform tree from list of edges to linked nodes
function treeTransform(t::Tree, v::Int, adjList::Array{Vector{Int}})
    n = getTreeSize(t)
    nodes = [Node(i, Vector{Int}()) for i in 1:n]
    marked = fill(false, n)
    addToTree(v, adjList, nodes, marked)
    return TREE(v, nodes)
end

# counting sort-like function calculating number of rounds based on nodes children
function countSortCalc(arr::Array{Int})
    valMax = maximum(arr)
    countArr = zeros(valMax + length(arr))
    for val in arr
        countArr[val + 1] += 1
    end

    for i in eachindex(countArr)
        for j in 1:(countArr[i]-1)
            countArr[Int(i + j)] += 1
        end
    end

    idx = length(countArr)
    while countArr[idx] == 0
        idx -= 1
    end

    return idx - 1
end

# recursive function for calculating min no. of rounds
function recCalcRounds(T::TREE, v::Int)
    if length(T.nodes[v].children) == 0
        return 0
    end
    ch_rounds = [recCalcRounds(T, child) for child in T.nodes[v].children]
    valMax = countSortCalc(ch_rounds)

    return valMax + 1
end

function calcRounds(T::TREE)
    return recCalcRounds(T, T.root)
end