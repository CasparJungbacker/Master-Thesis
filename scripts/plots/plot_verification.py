import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import argparse
import xarray as xr
import glob


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", help="profile.txt", required=True)
    parser.add_argument("-o", "--output", help="output file name", required=True)
    return parser.parse_args()


def main():
    # Vanilla runs
    runs = glob.glob(
        "/Users/caspar/Developer/mscthesis/data/cases/bomex/output-gcc/run*/tmser.001.nc"
    )

    # Load cases
    ensemble = xr.open_mfdataset(runs, combine="nested", concat_dim="run")
    nvidia = xr.open_dataset(
        "/Users/caspar/Developer/mscthesis/data/cases/bomex/output-nvidia/tmser.001.nc"
    )

    # Calculate ensemble mean and spread
    mean = ensemble["zi"].mean(dim="run")
    var = ensemble["zi"].var(dim="run")

    fig, ax = plt.subplots()
    mean.plot.line(x="time", ax=ax)
    ax.fill_between(
        x=var["time"], y1=(2 * np.sqrt(var)) + mean, y2=(-2 * np.sqrt(var)) + mean
    )
    nvidia["zi"].plot(x="time", ax=ax)

    plt.show()


if __name__ == "__main__":
    main()
