import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from argparse import ArgumentParser


def parse_args():
    parser = ArgumentParser()
    parser.add_argument("-s", "--single")
    parser.add_argument("-d", "--double")
    parser.add_argument("-o", "--output")
    return parser.parse_args()


def main():
    args = parse_args()

    single = pd.read_csv(args.single, delimiter=",")
    double = pd.read_csv(args.double, delimiter=",")

    speedup = double["Wall time"] / single["Wall time"]

    fig, ax = plt.subplots(figsize=(4, 3))
    ax.plot(speedup, "s-k")
    ax.set_xticks(
        np.arange(len(single)),
        [f"{nx} $\\times$ {ny}" for nx, ny in zip(single["itot"], single["jtot"])],
        rotation=45
    )
    ax.set_xlabel("Grid size ($N_x \\times N_y$)")
    ax.set_ylim(0.5, 2.5)
    ax.set_ylabel("Speedup [-]")
    ax.set_yticks([0.5, 1.0, 1.5, 2.0, 2.5])

    fig.savefig(args.output)


if __name__ == "__main__":
    main()
