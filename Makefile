BASE_DIR := $(CURDIR)

# Plot the timings as a pie chart
TIMINGS := $(wildcard data/timings/*.csv)
TIMINGS_PLOTS := $(patsubst data/timings/%.csv,doc/images/timings/%.svg,$(TIMINGS))

OUTPUT_STRONGSCALING = $(wildcard benchmarks/strongscaling/output*.txt)
OUTPUT_WEAKSCALING_PENCILS = $(wildcard benchmarks/weakscaling/pencils/output*.txt)
OUTPUT_WEAKSCALING_SLABS = $(wildcard benchmarks/weakscaling/slabs/output*.txt)

WALLTIME_SNELLIUS_CPU = ${sort ${shell find benchmarks/walltime/snellius -type f -name "output_cpu.txt"}}
WALLTIME_SNELLIUS_GPU = ${sort ${shell find benchmarks/walltime/snellius -type f -name "output_gpu.txt"}}
WALLTIME_CSV = data/walltimes/walltime_snellius_cpu.csv data/walltimes/walltime_snellius_gpu.csv

PLOTS = doc/images/top500_accelerators.svg doc/images/qt_thl_vs_height.svg doc/images/strong_scaling_gpu.svg\
	    doc/images/weak_scaling_gpu.svg doc/images/speedup_snellius.svg doc/images/weak_scaling_nodes.svg

.PHONY: all clean

all: plots data

##############################

plots: $(PLOTS)

cleanplots: 
	rm -f $(PLOTS)

$(TIMINGS_PLOTS): doc/images/timings/%.svg: data/timings/%.csv scripts/plots/plot_timings_pie_chart.py
	python scripts/plots/plot_timings_pie_chart.py -i $< -o $@

doc/images/top500_accelerators.svg: data/TOP500_history.csv scripts/plots/plot_top500.py
	python scripts/plots/plot_top500.py -i $< -o $@

doc/images/qt_thl_vs_height.svg: data/cases/bomex/fielddump.nc scripts/plots/plot_qt_thl_vs_height.py
	python scripts/plots/plot_qt_thl_vs_height.py -i $< -o $@

doc/images/strong_scaling_gpu.svg: $(OUTPUT_STRONGSCALING) scripts/plots/plot_strong_scaling.py
	python scripts/plots/plot_strong_scaling.py -i $(OUTPUT_STRONGSCALING) -o $@

doc/images/weak_scaling_gpu.svg: $(OUTPUT_WEAKSCALING_PENCILS) $(OUTPUT_WEAKSCALING_SLABS) scripts/plots/plot_weak_scaling.py
	python scripts/plots/plot_weak_scaling.py -p $(OUTPUT_WEAKSCALING_PENCILS) -s $(OUTPUT_WEAKSCALING_SLABS) -o $@

doc/images/weak_scaling_nodes.svg: $(OUTPUT_WEAKSCALING_PENCILS) $(OUTPUT_WEAKSCALING_SLABS) scripts/plots/plot_weak_scaling_nodes.py
	python scripts/plots/plot_weak_scaling_nodes.py -p $(OUTPUT_WEAKSCALING_PENCILS) -s $(OUTPUT_WEAKSCALING_SLABS) -o $@

doc/images/speedup_snellius.svg: $(WALLTIME_CSV) scripts/plots/plot_speedup_snellius.py
	python scripts/plots/plot_speedup_snellius.py -i $(WALLTIME_CSV) -o $@

##############################

data: $(WALLTIME_CSV)

cleandata:
	rm -f $(WALLTIME_CSV)

data/walltimes/walltime_snellius_cpu.csv: $(WALLTIME_SNELLIUS_CPU) scripts/utils/get_runtimes.py
	python scripts/utils/get_runtimes.py -i $(WALLTIME_SNELLIUS_CPU) -s snellius -o $@

data/walltimes/walltime_snellius_gpu.csv: $(WALLTIME_SNELLIUS_GPU) scripts/utils/get_runtimes.py
	python scripts/utils/get_runtimes.py -i $(WALLTIME_SNELLIUS_GPU) -s snellius -o $@

clean: cleandata
	rm -f $(PROFILE_HISTS)
	rm -f $(WALLTIME_PLOTS)
	rm -f $(TIMINGS_PLOTS)
