
using SparseArrays
using LinearAlgebra
using StatsBase
using Clustering

"""
EDGECATCLUSOBJ

Returns the number of mistakes made by a clustering in an instance of Categorical Edge
Clustering.
"""
function EdgeCatClusObj(EdgeList::Union{Array{Int64,2},Vector{Vector{Int64}}},EdgeColors::Array{Int64,1},c::Vector)
    n = length(c); Mistakes = 0
    for i = 1:size(EdgeList,1)
        if size(EdgeList,2) == 2
            edge = EdgeList[i,:]
        else
            edge = EdgeList[i]
        end
        for v in edge
            if c[v] != EdgeColors[i]
                Mistakes += 1
                break
            end
        end
    end
    return Mistakes
end

"""
SIMPLEROUND

A simple deterministic algorithm for rounding the LP relaxation of the Categorical Edge
Clustering objective. Guaranteed to be a 2-approximation for any problem.
"""
function SimpleRound(EdgeList::Union{Array{Int64,2},Vector{Vector{Int64}}},EdgeColors::Array{Int64,1},X::Array{Float64,2},LPval::Float64)
    C = rowmin(X)
    c = C[:,2]
    RoundScore = EdgeCatClusObj(EdgeList,EdgeColors,c)
    RoundRatio = RoundScore/LPval
    return c, RoundScore, RoundRatio
end


"""
Julia doesn't seem to have a nice way to extract the entry of the minimum value
in each row of a matrix and return it as an n x 2 matrix. So here it is.
"""
function rowmin(X::Array{Float64,2})
    n = size(X,1); Y = zeros(n,2)
    for i = 1:n
        g = findmin(X[i,:])
        Y[i,1] = g[1]; Y[i,2] = g[2]
    end
    return Y
end

function rowmax(X::Array{Float64,2})
    n = size(X,1)
    Y = zeros(n,2)
    for i = 1:n
        g = findmax(X[i,:])
        Y[i,1] = g[1]
        Y[i,2] = g[2]
    end
    return Y
end

function get_color_degree(EdgeList::Vector{Vector{Int64}},EdgeColors::Vector{Int64},n::Int64, k::Int64 = -1)
    if k == -1  # if k wasn't provided
        k = round.(Int64,maximum(EdgeColors))
    end
    ColorDegree = zeros(k,n)
    M = length(EdgeColors)
    for t = 1:M
        edge = EdgeList[t]
        color = EdgeColors[t]
        for node in edge
            ColorDegree[color,node] += 1
        end
    end
    return ColorDegree
end

function get_useless_assignments(EdgeList::Vector{Vector{Int64}},EdgeColors::Vector{Int64}, cl::Vector{Vector{Int64}})
    n = length(cl)
    color_degrees = get_color_degree(EdgeList, EdgeColors, n)
    k = round.(Int64,maximum(EdgeColors))

    # initialize
    total_useless_assignments = 0
    useless_assignments_per_node = zeros(n)
    useless_assignments = Vector{Vector{Int64}}()
    for i = 1:n
        push!(useless_assignments, Vector{Int64}())
    end

    satisfied_edge_list, satisfied_edge_colors, satisfied_indices = get_satisfied_edges(EdgeList, EdgeColors, cl)
    satisfied_color_degrees = get_color_degree(satisfied_edge_list, satisfied_edge_colors, n, k)

    # now count useless assignments
    # do not penalize assignments of c to v where v has c-degree 0. In practice these
    # assignments can always be avoided - implementation detail.
    for node = 1:n
        for color in cl[node]
            if color_degrees[color, node] != 0
                if satisfied_color_degrees[color, node] == 0
                    total_useless_assignments += 1
                    useless_assignments_per_node[node] += 1
                    push!(useless_assignments[node], color)
                end
            end
        end
    end
    return total_useless_assignments, useless_assignments_per_node, useless_assignments
end

function get_unused_nodes(EdgeList::Vector{Vector{Int64}},EdgeColors::Vector{Int64}, cl::Vector{Vector{Int64}})
    n = length(cl)
    satisfied_edge_list, satisfied_edge_colors, satisfied_indices = get_satisfied_edges(EdgeList, EdgeColors, cl)
    Msat = length(satisfied_edge_colors)

    satisfied_edges_per_node = zeros(n)
    for i = 1:Msat
        edge = satisfied_edge_list[i]
        color = satisfied_edge_colors[i]
        for v in edge
            satisfied_edges_per_node[v] += 1
        end
    end

    unused_node_list = Vector{Int64}()
    unused_node_count = 0
    for i = 1:n
        if satisfied_edges_per_node[i] == 0
            push!(unused_node_list, i)
            unused_node_count += 1
        end
    end
    return unused_node_count, unused_node_list, satisfied_edges_per_node
end

function compare_clusterings(EdgeList::Vector{Vector{Int64}},EdgeColors::Vector{Int64}, A::Vector{Vector{Int64}}, B::Vector{Vector{Int64}})
    n = length(A)
    foo, bar, A_sat_indices = get_satisfied_edges(EdgeList, EdgeColors, A)
    foo, bar, B_sat_indices = get_satisfied_edges(EdgeList, EdgeColors, B)

    A_sat_indices = Set(A_sat_indices)
    B_sat_indices = Set(B_sat_indices)

    AminusB = setdiff(A_sat_indices, B_sat_indices)
    BminusA = setdiff(B_sat_indices, A_sat_indices)
    AsymdiffB = symdiff(A_sat_indices, B_sat_indices)
    
    return AminusB, BminusA, AsymdiffB
end

function get_satisfied_edges(EdgeList::Vector{Vector{Int64}},EdgeColors::Vector{Int64}, cl::Vector{Vector{Int64}})
    satisfied_edge_list = Vector{Vector{Int64}}()
    satisfied_edge_colors = Vector{Int64}()
    satisfied_indices = Vector{Int64}()
    M = length(EdgeColors)
    for i = 1:M
        push!(satisfied_edge_list, Vector{Int64}())
        edge = EdgeList[i]
        satisfied = true
        for v in edge
            if !(EdgeColors[i] in cl[v])
                satisfied = false
                break
            end
        end
        if satisfied
            push!(satisfied_edge_list, edge)
            push!(satisfied_edge_colors, EdgeColors[i])
            push!(satisfied_indices, i)
        end
    end
        
    return satisfied_edge_list, satisfied_edge_colors, satisfied_indices
end

function MaxHyperedgeSize(EdgeList::Vector{Vector{Int64}})
    M = length(EdgeList)
    msize = 0
    for j = 1:M
        mnew = length(EdgeList[j])
        if mnew > msize
            msize = mnew
        end
    end
    return msize
end
