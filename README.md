# Julia Daya Bay example

## Set up

Note: These steps are intended to be run on Cori at NERSC. Other systems and
platforms should work, but you'll need to change, e.g., the value of DATAFILE in
TrigTimeSep.jl to point to a valid Daya Bay reconstructed data file. When
possible I'll point out special considerations for Mac/Windows.

### Installing Julia

[Download](https://julialang.org/downloads/) the latest version of Julia and
follow the [instructions](https://julialang.org/downloads/platform/) for your
platform. For example, on Cori, you would do something like the following
(replacing 1.4.2 with the latest version, of course):

```bash
cd
wget https://julialang-s3.julialang.org/bin/linux/x64/1.4/julia-1.4.2-linux-x86_64.tar.gz
tar xf julia-1.4.2-linux-x86_64.tar.gz
rm julia-1.4.2-linux-x86_64.tar.gz
```

Now Julia can be started by typing out the full path to the executable, e.g.,
`~/julia-1.4.2/bin/julia`. However, it would be more convenient to just type
`julia`. You could add `~/julia-1.4.2/bin` to your PATH, but let's kill two
birds with one stone and use a different solution. Run the following, and put it
in your `~/.bashrc.ext` (or its equivalent) to make it persist:

```bash
alias julia="PYTHON= ~/julia-1.4.2/bin/julia"
```

Setting the PYTHON environment variable to the empty string tells Julia *not* to
use the system's Python + packages, but to manage its own (using `conda`). This
means that you don't have to worry about installing any needed Python packages
(like `UpROOT`), as Julia will do it for you. This is the default on Mac and
Windows, but not on Linux, where we must force it in this way. If you already
have a well-oiled Python 3 environment, you can use it by leaving $PYTHON alone;
just be sure to install UpROOT with pip or conda.

## Running the example

In your terminal, navigate to this directory, and start up Julia. To "activate"
this project, go to the package manager by pressing the `]` key, enter `activate .`
and then exit the package manager by pressing backspace. Then load the analysis
by running `include("TrigTimeSep.jl")`, and finally, run `example_plot()`.

## Making your own project

Create a directory, cd into it, run Julia, press `]` to go to the package
prompt, create/activate the empty project with `activate .`, then add any
desired packages by doing, e.g., `add UpROOT`. You will now have a
`Project.toml` file, containing a list of the packages you added, and a
`Manifest.toml` file, listing (for reproducibility) the exact versions of every
package you added along with those of all their dependencies. If you delete
`Manifest.toml`, the latest versions of all packages will be installed the next
time you activate the project (I think).
