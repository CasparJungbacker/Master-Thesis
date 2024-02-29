import matplotlib.pyplot as plt
import xarray as xr
import pandas as pd
import numpy as n
import os

from string import ascii_lowercase
from matplotlib.lines import Line2D
from matplotlib.patches import Patch
from netCDF4 import Dataset
from argparse import ArgumentParser

def parse_args():
    parser = ArgumentParser()
    parser.add_argument("-c", "--cpu", required=True)
    parser.add_argument("-g", "--gpu", required=True)
    parser.add_argument("-o", "--output", required=True)
    return parser.parse_args()


def get_vertical_coordinate_type(var):
    # zt or zm?
    is_zt = "zt" in var.coords.keys()
    is_zm = "zm" in var.coords.keys()
    return is_zt * "zt" + is_zm * "zm" # If only you could do this in Fortran...


def load_and_convert_time(nc):
    # load nc file as xarray object and convert times to timedelta
    ds = xr.open_dataset(
        xr.backends.NetCDF4DataStore(Dataset(nc, "r"))
    )
    ds["time"] = pd.TimedeltaIndex(ds["time"].values, "s")
    ds = ds.resample(
        time="1h", offset=pd.Timedelta(-10, unit="min")
    ).mean()
    return ds


def plot_variable(old, new, ax):
    mean_old = old.mean(dim="record")
    mean_new = new.mean(dim="record")
    std = old.std(dim="record")

    coord = get_vertical_coordinate_type(old)

    ax.plot(mean_old, old[coord], color="#4477AA")
    ax.fill_betweenx(
        y=old[coord], x1=mean_old - 2 * std, x2=mean_old + 2 * std,
        color="#4477AA",
        alpha=0.5
    )
    ax.plot(mean_new, old[coord], color="#EE6677")


def main():
    args = parse_args()
    old = load_and_convert_time(args.cpu)
    new_run = load_and_convert_time(args.gpu)

    vars = ["thl", "qt", "wthlt", "wqlt"]
    latex = dict(
        thl="$\\overline{\\theta}_l$",
        qt="$\\overline{q_t}$",
        wthlt="$w^\\prime \\theta_l^\\prime$",
        wqlt="$w^\\prime q_l^\\prime$")
 
    fig, ax = plt.subplots(2, 2, figsize=(5, 6), constrained_layout=True)
    ax = ax.flatten()
 
    for ivar, var in enumerate(vars):
        plot_variable(
            old[var].isel(time=-1),
            new_run[var].isel(time=-1),
            ax[ivar]
        )
        ax[ivar].set_title("(" + ascii_lowercase[ivar] + ")", loc="left")
        ax[ivar].set_ylabel("z [m]")
        ax[ivar].set_xlabel(f"{latex[var]} [{old[var].units}]")
        plt.legend()
    
    legend = [Line2D([0], [0], color="#4477AA", label="DALES v4.4.1 ensemble mean"),
              Line2D([0], [0], color="#EE6677", label="DALES OpenACC ensemble mean"),
              Patch(facecolor="#4477AA", alpha=0.5, label="DALES v4.4.1 ensemble standard deviation")]

    fig.legend(handles=legend, loc='outside lower center', borderaxespad=0)

    fig.savefig(args.output)
 
 
if __name__ == "__main__":
    main()
