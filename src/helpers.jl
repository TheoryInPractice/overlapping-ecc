using SparseArrays


"""
This converts a hypergraph in incidence matrix form to hyperedge list form.
Incidence matrix form:  H[e,u] = 1  iff node u is in hyperedge e
Edgelist form: Hyperedges[j] = array of nodes in hyperedge j
nodelist == true: means you actually want to get a map from node IDs to hyperedge ids
"""
function incidence2elist(H::SparseArrays.SparseMatrixCSC{Float64,Int64},nodelist::Bool=false)
    if ~nodelist
        # unless you want the node2edge map, transpose first
        H = SparseArrays.sparse(H')
    end
    rp = H.rowval
    ci = H.colptr
    nz = H.nzval
    Hyperedges = Vector{Vector{Int64}}()
    n,m = size(H)

    for i = 1:m
        startedge = ci[i]
        endedge = ci[i+1]-1
        nodes = rp[startedge:endedge]
        mult = nz[startedge:endedge]
        edge = Vector{Int64}()
        # need to adjust for multiplicities
        for t = 1:length(nodes)
            node = nodes[t]
            for k = 1:mult[t]
                push!(edge,node)
            end
        end

        push!(Hyperedges,edge)
    end
    return Hyperedges
end
