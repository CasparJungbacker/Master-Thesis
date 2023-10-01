import numpy as np
import pandas as pd
import argparse
import matplotlib.pyplot as plt


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", required=True)
    parser.add_argument("-o", "--output", required=True)
    return parser.parse_args()


def main():
    args = parse_args()

    df = pd.read_csv(args.input, delimiter=";")
    df["speedup"] = df["cpu"] / df["gpu"]

    x = np.arange(len(df["itot"]))
    width = 0.25

    fig = plt.figure()
    gs = fig.add_gridspec(2, 1, hspace=0, wspace=0)

    (ax1, ax2) = gs.subplots(sharex="col")

    ax1.plot(df["speedup"], "^-")
    ax1.set_ylabel("Speedup [-]")

    ax2.bar(x - width / 2, df["cpu"], width)
    ax2.bar(x + width / 2, df["gpu"], width)
    ax2.set_xticks(
        x,
        [f"{nx} $\\times$ {ny}" for nx, ny in zip(df["itot"], df["jtot"])],
    )
    ax2.set_yscale("log")
    ax2.set_ylabel("Wall clock time [$s$]")
    ax2.set_xlabel("$N_x \\times N_y$")

    fig.savefig(args.output)


if __name__ == "__main__":
    main()
