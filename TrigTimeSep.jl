using UpROOT
using DataFrames

# This should not be necessary once UpROOT.jl has been bugfixed.
include("root_hacks.jl")

DATAFILE = "/global/projecta/projectdirs/dayabay/data/dropbox/p17b/lz3.skim.6/recon.Neutrino.0021221.Physics.EH1-Merged.P17B-P._0001.root"

function read_times(fname)
    branches = ["context.mDetId",
                "context.mTimeStamp.mSec",
                "context.mTimeStamp.mNanoSec"]
    df = read_ttree(fname, "Event/Data/CalibStats", branches)
    rename!(df, ["det", "s", "ns"])
end
