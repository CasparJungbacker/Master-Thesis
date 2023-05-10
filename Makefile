BASE_DIR = $(CURDIR)

# Scripts for plotting
PLOT_SCRIPTS = $(wildcard scripts/plots/*.py)

# gprof plots
PROFILES = $(wildcard data/profiles/*.txt)
PROFILE_HISTS = $(patsubst data/profiles/%.txt,doc/images/profiles/%.png,$(PROFILES))

.PHONY: all clean

all: $(PROFILE_HISTS)

$(PROFILE_HISTS): doc/images/profiles/%.png: data/profiles/%.txt scripts/plots/plot_profile.py
	python scripts/plots/plot_profile.py -i $< -o $@

clean:
	rm -f $(PROFILE_HISTS)