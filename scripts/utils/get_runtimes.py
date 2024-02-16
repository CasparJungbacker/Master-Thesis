import argparse
import pandas as pd

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", nargs="+", required=True)
    parser.add_argument("-o", "--output", required=True)
    return parser.parse_args()


def find_looptime(file):
    with open(file, "r") as f:
        for line in f:
            if line.startswith(" Time loop"):
                return float(line.replace(" ", "").split(":")[1])


def find_gridsize(file):
    itot, jtot = None, None
    with open(file, "r") as f:
        for line in f:
            if line.startswith(" ITOT") and itot is None:
                itot = int(line.split("=")[1].strip(" ,\n"))
            elif line.startswith(" JTOT") and jtot is None:
                jtot = int(line.split("=")[1].strip(" ,\n"))
    return (itot, jtot)

def main():
    args = parse_args()
    
    gridsizes = list(map(find_gridsize, args.input))
    looptimes = list(map(find_looptime, args.input))
    

    df = pd.DataFrame(gridsizes, columns=["itot", "jtot"], dtype=int)
    df["Wall time"] = looptimes
    df.to_csv(args.output)


if __name__ == "__main__":
    main()