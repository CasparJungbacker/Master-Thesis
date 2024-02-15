import numpy as np
import matplotlib.pyplot as plt
import argparse

NGPUS=[1, 2, 4, 8, 16, 32, 64]

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pencils", nargs="+", required=True)
    parser.add_argument("-s", "--slabs", nargs="+", required=True)
    parser.add_argument("-o", "--output", required=True)
    return parser.parse_args()


def read_times(files):
    times = []
    for file in files:
        with open(file, "r") as f:
            for line in f:
                if line.startswith(" Time loop"):
                    times.append(float(line.replace(" ", "").split(":")[1]))
                    break
    return times


def plot_scaling(slowdowns_pencils, slowdowns_slabs, name):
    fig, ax = plt.subplots(figsize=(4,3))
    
    ax.axhline(1, color="black", label="Ideal")
    ax.plot(NGPUS, slowdowns_pencils, "s-", color="#4477AA", label="Pencil decomposition")
    ax.plot(NGPUS, slowdowns_slabs, "s-", color="#EE6677", label="Slab decomposition")
    ax.set_xscale("log", base=2)
    ax.set_xticks(NGPUS, NGPUS)
    ax.set_xlabel("Number of GPUs")
    ax.set_ylabel("$t_w/t_{w,1\\text{ GPU}}$")
    ax.set_ylim(0., 2.5)
    ax.legend()
    
    fig.savefig(name)


def main():
    args = parse_args()
    
    times_pencils = read_times(sorted(args.pencils))
    times_slabs = read_times(sorted(args.slabs))
    
    slowdowns_pencils = np.array(times_pencils) / times_pencils[0]
    slowdowns_slabs = np.array(times_slabs) / times_slabs[0]
    
    plot_scaling(slowdowns_pencils, slowdowns_slabs, args.output)


if __name__ == "__main__":
    main()