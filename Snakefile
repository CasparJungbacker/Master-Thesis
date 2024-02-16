import os

HERE = os.getcwd()
PLOT_DIR = os.path.join(HERE, "doc", "images", "plots")

def aggregate_grid_sizes(wildcards):
	sysdir = os.path.join(HERE, "data", "benchmarks", "walltime", wildcards.system, wildcards.precision)
	grid_sizes = [os.path.join(sysdir, _, "output_" +  wildcards.processor + ".txt") \
					for _ in os.listdir(sysdir) if os.path.isdir(os.path.join(sysdir, _))]
	return sorted(grid_sizes)

def aggregate_ensemble_members(wildcards):
	ensembledir = os.path.join(HERE, "data", "ensembles", "members")
	members = [os.path.join(ensembledir, wildcards.processor, _, wildcards.file + ".001.nc") \
			   for _ in os.listdir(os.path.join(ensembledir, wildcards.processor)) \
			   if os.path.isdir(os.path.join(ensembledir, wildcards.processor, _))]
	return members

wildcard_constraints:
	system="[a-z]+",
	precision="[a-z]+"

rule all:
	input:
		"doc/images/plots/speedup_snellius.svg",
		"doc/images/plots/speedup_wiske.svg",
		"doc/images/plots/strong_scaling.svg",
		"doc/images/plots/verify_profiles.svg",
		"doc/images/plots/weak_scaling.svg"

rule walltimes:
	input:
		expand("data/benchmarks/walltime/{system}/doubleprecision/walltime_{system}_{processor}_doubleprecision.csv", 
			   system=["snellius", "wiske"], 
			   processor=["gpu", "single_cpu", "multi_cpu"]),
		"data/benchmarks/walltime/wiske/singleprecision/walltime_wiske_gpu_singleprecision.csv"

rule plots:
	input:
		expand(os.path.join(PLOT_DIR, "speedup_{system}.svg"), system=["snellius", "wiske"]),
		"doc/images/plots/strong_scaling.svg"

rule aggregate_walltime:
	input:
		script="scripts/utils/get_runtimes.py",
		files=aggregate_grid_sizes
	output:
		"data/benchmarks/walltime/{system}/{precision}/walltime_{system}_{processor}_{precision}.csv"
	shell:
		"python {input.script} -i {input.files} -o {output}"

rule generate_ensemble:
	input:
		aggregate_ensemble_members
	output:
		"data/ensembles/{file}.{processor}.nc"
	shell:
		"ncecat {input} -O {output}"

rule plot_speedup:
	input:
		script="scripts/plots/plot_speedup.py",
		mplrc="matplotlibrc",
		timing_single_core="data/benchmarks/walltime/{system}/doubleprecision/walltime_{system}_single_cpu_doubleprecision.csv",
		timing_multi_core="data/benchmarks/walltime/{system}/doubleprecision/walltime_{system}_multi_cpu_doubleprecision.csv",
		timing_gpu="data/benchmarks/walltime/{system}/doubleprecision/walltime_{system}_gpu_doubleprecision.csv"
	output:
		"doc/images/plots/speedup_{system}.svg"
	shell:
		"""
		python {input.script} \
			-s {input.timing_single_core} \
			-m {input.timing_multi_core} \
			-g {input.timing_gpu} \
			-o {output}
		"""

rule plot_strong_scaling:
	input:
		script="scripts/plots/plot_strong_scaling.py",
		mplrc="matplotlibrc",
		run_output=expand("data/benchmarks/strongscaling/output_{ngpus}.txt",
			ngpus=glob_wildcards("data/benchmarks/strongscaling/output_{ngpus}.txt").ngpus)
	output:
		"doc/images/plots/strong_scaling.svg"
	shell:
		"python {input.script} -i {input.run_output} -o {output}"

rule plot_verification:
	input:
		script="scripts/plots/plot_verification.py",
		mplrc="matplotlibrc",
		profiles_cpu="data/ensembles/profiles.cpu.nc",
		profiles_gpu="data/ensembles/profiles.gpu.nc"
	output:
		"doc/images/plots/verify_profiles.svg"
	shell:
		"python {input.script} -c {input.profiles_cpu} -g {input.profiles_gpu} -o {output}"

rule plot_weak_scaling:
	input:
		script="scripts/plots/plot_weak_scaling.py",
		mplrc="matplotlibrc",
		output_pencils=expand("data/benchmarks/weakscaling/pencils/output_{ngpus}.txt",
			ngpus=glob_wildcards("data/benchmarks/weakscaling/pencils/output_{ngpus}.txt").ngpus),
		output_slabs=expand("data/benchmarks/weakscaling/slabs/output_{ngpus}.txt",
			ngpus=glob_wildcards("data/benchmarks/weakscaling/slabs/output_{ngpus}.txt").ngpus),
	output:
		"doc/images/plots/weak_scaling.svg"
	shell:
		"""
		python {input.script} \
			-p {input.output_pencils} \
			-s {input.output_slabs} \
			-o {output}
		"""
	