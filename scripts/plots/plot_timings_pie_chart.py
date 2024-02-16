import pandas as pd
import matplotlib.pyplot as plt
import argparse


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", required=True)
    parser.add_argument("-o", "--output", required=True)
    return parser.parse_args()


def main():
    args = parse_args()

    df = pd.read_csv(args.input, delimiter=";")

    total = df["total"].iloc[-1]
    other = total - df["total"].iloc[:-1].sum()

    values = df["total"].iloc[:-1].to_list()
    values.append(other)
    labels = df["Subroutine"].iloc[:-1].to_list()
    labels.append("Other")

    fig, ax = plt.subplots()
    ax.pie(values, labels=labels, autopct="%1.1f%%")

    fig.savefig(args.output)


if __name__ == "__main__":
    main()
