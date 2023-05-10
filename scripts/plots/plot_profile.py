import argparse
import pandas as pd
import matplotlib.pyplot as plt

from pathlib import Path


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", help="profile.txt", required=True)
    parser.add_argument("-o", "--output", help="output file name", required=True)
    return parser.parse_args()


def parse_profile(filename: str | Path) -> pd.DataFrame:
    """Reads the (flat) gprof profile and converts it to a DataFrame"""
    # Column names
    cols = [
        "% time",
        "cumulative seconds",
        "self seconds",
        "calls",
        "self s/call",
        "total s/call",
        "name",
    ]
    df = pd.read_csv(filename, header=0, names=cols, delim_whitespace=True, skiprows=4)
    return df


def plot_profile(df: pd.DataFrame, figname: str, num: int = 10) -> None:
    """Plots a histogram"""
    fig, ax = plt.subplots()
    df[:num].plot("name", "self seconds", kind="barh", ax=ax, legend=False)
    ax.set_xlabel("Runtime (s)")
    fig.savefig(figname, bbox_inches="tight")


def main():
    args = parse_args()

    df = parse_profile(args.input)
    plot_profile(df, args.output)


if __name__ == "__main__":
    main()
