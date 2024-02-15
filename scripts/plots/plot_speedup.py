import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--singlecore")
    parser.add_argument("-m", "--multicore")
    parser.add_argument("-g", "--gpu")
    parser.add_argument("-o", "--output", required=True)
    return parser.parse_args()


def combine_data(singlecore, multicore, gpu):
    df = pd.DataFrame()
    df["itot"] = singlecore.itot
    df["jtot"] = singlecore.jtot
    df["wtime_singlecore"] = singlecore["Wall time"]
    df["wtime_multicore"] = multicore["Wall time"]
    df["wtime_gpu"] = gpu["Wall time"]
    df["speedup_singlecore_multicore"] = df["wtime_singlecore"] / df["wtime_multicore"]
    df["speedup_singlecore_gpu"] = df["wtime_singlecore"] / df["wtime_gpu"]
    df["speedup_multicore_gpu"] = df["wtime_multicore"] / df["wtime_gpu"]
    return df


def main():
    args = parse_args()

    singlecore = pd.read_csv(args.singlecore, delimiter=",")
    multicore = pd.read_csv(args.multicore, delimiter=",")
    gpu = pd.read_csv(args.gpu, delimiter=",")

    df = combine_data(singlecore, multicore, gpu)
    
    num_cores = 128 if "snellius" in args.singlecore else 8

    x = np.arange(len(df["itot"]))
    width = 0.25

    fig = plt.figure(figsize=(5, 4))
    gs = fig.add_gridspec(2, 1, hspace=0, wspace=0)

    (ax1, ax2) = gs.subplots(sharex="col")

    ax1.plot(df["speedup_multicore_gpu"], "^-", color="#000000", linewidth="1",
             label=f"GPU vs {num_cores} CPUs")
    ax1.set_ylabel("Speedup [-]")
    ax1.legend(loc="upper left", bbox_to_anchor=(1.04, 1), borderaxespad=0)

    ax2.bar(x - width, df["wtime_singlecore"] / 100, width, label="1 CPU", color="#4477AA")
    ax2.bar(x, df["wtime_multicore"] / 100, width, label=f"{num_cores} CPUs", color="#66CCEE")
    ax2.bar(x + width, df["wtime_gpu"] / 100, width, label="1 GPU", color="#EE6677")
    ax2.set_xticks(
        x,
        [f"{nx} $\\times$ {ny}" for nx, ny in zip(df["itot"], df["jtot"])],
        rotation=45
    )
    ax2.set_yscale("log")
    ax2.set_ylabel("Wall clock time\nper full timestep[$s$]")
    ax2.set_xlabel("$N_x \\times N_y$")
    ax2.legend(loc="upper left", bbox_to_anchor=(1.04, 1), borderaxespad=0)

    fig.savefig(args.output)


if __name__ == "__main__":
    main()
