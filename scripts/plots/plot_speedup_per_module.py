import matplotlib.pyplot as plt
import pandas as pd

from argparse import ArgumentParser


def parse_args():
    parser = ArgumentParser()
    parser.add_argument("-i", "--input")
    parser.add_argument("-o", "--output")
    return parser.parse_args()


def main():
    args = parse_args()

    df = pd.read_csv(args.input, delimiter=";", index_col=0)

    df = df.transpose()
    df["Other"] = df["Total"] - df.iloc[:, 0:-1].sum(axis=1)
    df = df.transpose()
    df.drop("Total", inplace=True)

    df["Speedup"] = df["single"] / df["multi"]

    df = df.sort_values(by="Speedup")

    fig, ax = plt.subplots(figsize=(4,3))
    ax.barh(df.index, df["Speedup"], color="#0077BB")
    ax.set_xlabel("$t_{w,\\text{1 GPU}}/t_{w,\\text{4 GPUs}}$", fontsize=12)
    ax.axvline(4, color="black", label="Ideal")
    ax.legend(loc="upper left", bbox_to_anchor=(1.04, 1), borderaxespad=0)

    fig.savefig(args.output)
    

if __name__ == "__main__":
    main()
