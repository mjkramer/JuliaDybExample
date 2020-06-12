using UpROOT
using DataFrames
using DataFramesMeta

# This should not be necessary once UpROOT.jl has been bugfixed.
include("root_hacks.jl")

DATAFILE = "/global/projecta/projectdirs/dayabay/data/dropbox/p17b/lz3.skim.6/recon.Neutrino.0021221.Physics.EH1-Merged.P17B-P._0001.root"

# Read the trigger times of a bunch of events
function read_times(fname)
    branches = ["context.mDetId",
                "context.mTimeStamp.mSec",
                "context.mTimeStamp.mNanoSec"]
    df = read_ttree(fname, "Event/Data/CalibStats", branches)
    rename!(df, ["det", "s", "ns"])
end

# Get an array of time differences between adjacent triggers for a given
# detector.
function timediffs(df, det)
    # Get an Nx2 matrix of s/ns timestamps for this detector
    times = @where(df, :det .== det)[!, [:s, :ns]] |> Matrix
    # Subtract adjacent rows
    deltas = times[2:end, :] - times[1:end-1, :]
    # Convert from (s, ns) to (ns)
    1_000_000_000 * deltas[:, 1] + deltas[:, 2]
end
