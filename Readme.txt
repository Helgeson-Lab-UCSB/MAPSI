Use script "run_patrick_data.m" as a template for running MAPSI on scattering
Script will automatically run and spit out inferred OPDFs for data in "patrick_data"

Ensure that data is organized similar to the text file in the folder "patrick_data"
with columns Qx, Qy, Qz, I, std I

Plot data with script "plot_figures.m"

"slurm-serial.job" is an example script for running the code on POD