import argparse
import pandas as pd
import matplotlib.pyplot as plt


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", help="TOP500_history.csv", required=True)
    parser.add_argument("-o", "--output", help="output file name", required=True)
    return parser.parse_args()


def clean_data(df):
    """Remove years that do not have accelerators"""
    drop = (
        (df["Accelerator"].isna() & df["Accelerator/Co-Processor"].isna())
        | (df["Accelerator"] == "None")
        | (df["Accelerator/Co-Processor"] == "None")
    )
    return df[~drop]


def count_accelerators(df):
    df["Datetime"] = pd.to_datetime(df[["Year", "Month", "Day"]])
    return df.groupby(["Datetime"]).count()


def plot_timeseries(df, figname):
    fig, ax = plt.subplots()
    ax.plot(df.index, df["Year"])
    ax.set_xlabel("Year")
    ax.set_ylabel("Number of systems in TOP500 with accelerators")
    fig.savefig(figname)


def main():
    args = parse_args()

    df = pd.read_csv(args.input)
    df = clean_data(df)
    counted = count_accelerators(df)
    plot_timeseries(counted, args.output)


if __name__ == "__main__":
    main()
