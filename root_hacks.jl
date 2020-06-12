using UpROOT
using DataFrames
using PyCall

# This is identical to the version of UpROOT, but that one fails because UpROOT
# doesn't import the DataFrames package.
function read_ttree(tree::PyObject, branchnames::Array{<:AbstractString})
    tree_data = tree.arrays(branchnames)

    df = DataFrame()
    for bn in branchnames
        df[!, Symbol(bn)] = UpROOT.py2jl(tree_data[bn])
    end

    df
end

# Since UpROOT doesn't export read_ttree
function read_ttree(filename::AbstractString, treename::AbstractString, branchnames::Array{<:AbstractString})
    tree = TFile(filename)[treename]
    read_ttree(UpROOT.pyobj(tree), branchnames)
end
