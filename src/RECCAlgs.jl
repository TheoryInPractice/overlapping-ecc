using SparseArrays
using LinearAlgebra
using StatsBase
using JuMP
using Gurobi
using Clustering
using DataStructures

gurobi_env = Gurobi.Env()

"""
RECCCanonicalLP
Solves the Robust Edge-Colored Clustering LP relaxation

Input:
    EdgeList = the edge list of a LO-ECC instance
    EdgeColors = the edge colors
    n = number of vertices in the instance
    b = global budget for vertex deletions
    optimalflag = True iff you want a solution to the integer program. Defaults to false.
    outputflag = 1 for verbose output from Gurobi. Defaults to 0.

Output:
    LPval = The LP relaxation objective score. This is a lower bound on OPT (equal if you set optimalflag=true)
    X = The distance labels from solving the objective
    Z = The node deletion veriables
    runtime = Solver runtime
"""
function RECCLP(EdgeList::Vector{Vector{Int64}}, EdgeColors::Array{Int64, 1}, n::Int64, b::Int64, optimalflag::Bool=false,outputflag::Int64=0)
    k = maximum(EdgeColors)
    M = length(EdgeList)

    m = Model(optimizer_with_attributes(() -> Gurobi.Optimizer(gurobi_env), "OutputFlag" => outputflag))

    # Variables for nodes and edges
    @variable(m, y[1:M])

    @objective(m, Min, sum(y[i] for i=1:M))

    if optimalflag
        @variable(m, x[1:n,1:k],Bin)
        @variable(m, z[1:n],Bin)
    else
        @variable(m, x[1:n, 1:k])
        @constraint(m,x .<= ones(n,k))
        @constraint(m,x .>= zeros(n,k))
        @constraint(m,y .<= ones(M))
        @constraint(m,y .>= zeros(M))

        @variable(m, z[1:n])
        @constraint(m, z .>= zeros(n))
        @constraint(m, z .<= ones(n))
    end
    @constraint(m, sum(z[i] for i = 1:n) <= b)

    for i = 1:n
        @constraint(m, sum(x[i,j] for j = 1:k) >= k - 1)
    end

    for e = 1:M
        color = EdgeColors[e]
        edge = EdgeList[e]

        # For every node in the edge, there's a constraint for the
        # node-color variable
        for v = edge
            @constraint(m, y[e] >= x[v,color] - z[v])
        end
    end
    start = time()
    JuMP.optimize!(m)
    runtime = time()-start

    # Return clustering and objective value
    X = JuMP.value.(x)
    Z = JuMP.value.(z)
    LPval= JuMP.objective_value(m)

    return LPval, X, Z, runtime
end

"""
RECCRound
Returns a rounded clustering for the RECC objective

Inputs:
    EdgeList = the edge list of a LO-ECC instance
    EdgeColors = the edge colors
    X = the distance labels from solving the LP relaxation
    Z = the node deletion labels from solving the LP relaxation
    LPval = the objective score from solving the LP relaxation
    b = the global budget for node deletions

Output:
    c = The cluster assignments
    RoundScore = The Go-ECC objective score of the rounded clustering c.
    RoundRatio = The approximation ratio of RoundScore with respect to LPval
    RoundBudgetScore = The number of extra assignments in c
    RoundBudgetRatio = The approximation ratio of RoundBudgetScore with respect to b
"""

function RECCRound(EdgeList::Union{Array{Int64,2}, Vector{Vector{Int64}}}, EdgeColors::Array{Int64, 1}, X::Array{Float64,2}, Z::Array{Float64, 1}, LPval::Float64, b::Int64)
    c = Vector{Vector{Int64}}()
    n = size(X, 1)
    for i = 1:n
        colors = Vector{Int64}()
        if Z[i] >= 1/3
            for j = 1:maximum(EdgeColors)
                push!(colors, j)
            end
        else
            push!(colors, sortperm(X[i,:])[1])
        end
        push!(c, colors)
    end
    RoundScore = OverlappingEdgeCatClusObj(EdgeList, EdgeColors, c)
    RoundRatio = 1
    if LPval != 0
        RoundRatio = RoundScore/LPval
    end
    RoundBudgetScore = 0
    for i = 1:n
        if Z[i] >= 1/3
            RoundBudgetScore += 1
        end
    end
    RoundBudgetRatio = RoundBudgetScore/b

    return c, RoundScore, RoundRatio, RoundBudgetScore, RoundBudgetRatio
end



"""
OverlappingEdgeCatClusObj

Returns the number of mistakes made by an overlapping clustering in an instance of
a Categorical Edge Clustering problem.
"""
function OverlappingEdgeCatClusObj(EdgeList::Union{Array{Int64,2}, Vector{Vector{Int64}}}, EdgeColors::Array{Int64,1}, c::Vector{Vector{Int64}})
    n = length(c)
    mistakes = 0
    for i = 1:size(EdgeList,1)
        if size(EdgeList,2) == 2
            edge = EdgeList[i,:]
        else
            edge = EdgeList[i]
        end
        for v in edge
            if !(EdgeColors[i] in c[v])
                mistakes += 1
                break
            end
        end
    end
    return mistakes
end

"""
GreedyRobust
Returns a clustering according to the R-ECC greedy algorithm. Each node is
assigned its most frequent color, and then b nodes are assigned every color,
minimizing total node-edge disagreements.

Input:
    EdgeList = the edges
    EdgeColors = the edge colors
    n = number of nodes
    k = number of colors
    b = the global for extra cluster assignments

Outputs:
    greedy_c = the cluster assignments
"""

function GreedyRobust(EdgeList::Vector{Vector{Int64}},EdgeColors::Vector{Int64},n::Int64,k::Int64,b::Int64)
    
    # maintain a priority queue of color degrees for each node
    ColorDegree = Vector{PriorityQueue{Int64, Int64}}()

    # initialize priority queues
    for i = 1:n
        push!(ColorDegree, PriorityQueue{Int64, Int64}(Base.Order.Reverse))
        for j = 1:k
            ColorDegree[i][j] = 0
        end
    end

    # populate color degrees
    for t = 1:length(EdgeList)
        edge = EdgeList[t]
        color = EdgeColors[t]
        for node in edge
            ColorDegree[node][color] += 1
        end
    end

    # every node gets its most frequent color
    greedy_c = Vector{Vector{Int64}}()
    for i = 1:n
        push!(greedy_c, Vector{Int64}())
        push!(greedy_c[i], dequeue!(ColorDegree[i]))
    end

    # form a global priority queue for remaining mistakes per node
    global_queue = PriorityQueue{Int64, Int64}(Base.Order.Reverse)
    for i = 1:n
        global_queue[i] = 0
        for j = 1:k-1
            color, count = peek(ColorDegree[i])
            global_queue[i] += count
            dequeue!(ColorDegree[i])
        end
    end

    # rainbow b nodes
    b = min(b, n)  # simplification
    for i = 1:b
        greedy_c[dequeue!(global_queue)] = 1:k
    end
    return greedy_c
end
