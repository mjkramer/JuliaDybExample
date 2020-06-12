using UpROOT
using DataFrames
using DataFramesMeta
using Plots
using Printf

# Tell Plots.jl to use the pyplot (matplotlib) backend
pyplot()

# This should not be necessary once UpROOT.jl has been bugfixed.
include("root_hacks.jl")

DATA_FILE = "/global/projecta/projectdirs/dayabay/data/dropbox/p17b/lz3.skim.6/recon.Neutrino.0021221.Physics.EH1-Merged.P17B-P._0001.root"

# Read the trigger times of a bunch of events
function read_times(fname)
    branches = ["context.mDetId",
                "context.mTimeStamp.mSec",
                "context.mTimeStamp.mNanoSec"]
    df = read_ttree(fname, "Event/Data/CalibStats", branches)
    rename!(df, ["det", "s", "ns"]) # less unwieldy
end

# Get an array of time differences between adjacent triggers for a given
# detector.
function time_diffs(df, det)
    # Get an Nx2 matrix of s/ns timestamps for this detector
    times = @where(df, :det .== det)[!, [:s, :ns]] |> Matrix
    # Subtract adjacent rows
    deltas = times[2:end, :] - times[1:end-1, :]
    # Convert from (s, ns) to (ns)
    1_000_000_000 * deltas[:, 1] + deltas[:, 2]
end

function plot_diffs(dt)
    loglim = (2, 8)
    bins = [10^x for x in loglim[1]:0.025:loglim[2]]
    ticks = [10^x for x in loglim[1]:0.5:loglim[2]]
    labels = [@sprintf("%.2g", t) for t in ticks]

    stephist(dt,
             normalize = :density,
             bins = bins,
             xlim = (bins[1], bins[end]),
             xticks = (ticks, labels),
             xscale = :log10,
             yscale = :log10,
             legend = false,
             title = "Time difference between triggers",
             xlabel = "nanosec")
end

# Plot the time difference between adjacent triggers for EH1-AD1 in run 21221
# file 1.
function example_plot()
    df = read_times(DATA_FILE)
    dt = time_diffs(df, 1)
    plot_diffs(dt)
end
