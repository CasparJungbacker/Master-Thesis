import numpy as np
import matplotlib.pyplot as plt

from utils import parse_args

NGPUS = [1, 2, 4, 8, 16]


def read_times(files):
    times = []
    for file in files:
        with open(file, "r") as f:
            for line in f:
                if line.startswith(" Time loop"):
                    times.append(float(line.replace(" ", "").split(":")[1]))
                    break
    return times


def plot_scaling(time, name):
    fig, ax = plt.subplots(figsize=(4, 3))

    ax.plot(NGPUS, np.array(time) / 100, "s-", color="#4477AA")
    ax.plot(np.arange(1, 17, 1), (time[0] / 100) / np.arange(1, 17, 1), "k", label="Ideal")
    # ax.plot(NGPUS, NGPUS, "-k", label="Ideal")

    ax.set_xlabel("Number of GPUs")
    ax.set_ylabel("Wall-clock time per timestep [$s$]")
    ax.set_yscale("log")
    ax.set_xscale("log", base=2)
    ax.set_xticks(NGPUS, NGPUS)
    ax.legend()

    fig.savefig(name)


def main():
    args = parse_args()

    times = read_times(sorted(args.input))

    plot_scaling(times, args.output)


if __name__ == "__main__":
    main()
