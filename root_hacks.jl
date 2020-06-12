using TypedTables

# Original definition is in UpROOT/ttree.jl.
# We've simply replaced "df[Symbol(bn)]" with "df[!, Symbol(bn)]" in order to
# silence a warning.
function read_ttree(tree::TTree, branchnames::Array{<:AbstractString})
    tree_data = UpROOT.pyobj(tree).arrays(branchnames)

    df = DataFrame()
    for bn in branchnames
        df[!, Symbol(bn)] = UpROOT.py2jl(tree_data[bn])
    end

    df
end

# Add a version of read_ttree that reads all branches instead of a
# user-specified subset.
read_ttree(tree::TTree) = read_ttree(tree, branches_of(tree))
branches_of(tree::TTree) = [String(k) for k in keys(tree[1])]

# fix needed to make Table from CalibStats
# getindex was choking on "jobId.m_data[4]"

# preventing "pretty" printing of tree, etc. Workaround for a bug in UpROOT,
# which doesn't like it when branches aren't all the same length.

# Workaround for a bug that prevents CalibStats from being printed in the Julia
# REPL.
function Base.getindex(tree::TTree, idxs::AbstractUnitRange)
    @boundscheck checkbounds(tree, idxs)
    cols = UpROOT.pyobj(tree).arrays(entrystart = first(idxs) - 1, entrystop = last(idxs))
    # Hack to get rid of static-sized arrays:
    cols = Dict(k => v for (k, v) in cols
                if findfirst("[", k) === nothing)

    Table(UpROOT._dict2nt(cols)) # fails if branches aren't all the same length
end

