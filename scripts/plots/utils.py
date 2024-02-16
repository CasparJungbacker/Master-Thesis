import argparse

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", nargs="+", required=True)
    parser.add_argument("-o", "--output", required=True)
    return parser.parse_args()

CPU_COLOR = "#0077BB"
GPU_COLOR = "#EE7733"