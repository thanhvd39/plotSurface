Simulated Brain Data for GUI Testing
====================================

This directory contains simulated brain weight data for testing the Brain Surface Plot GUI.
All data is generated for the Schaefer 200 parcellation (200 brain regions).

Files:
------
schaefer200_weights.* - Basic simulated brain network pattern
age_related_weights.* - Simulated age-related brain changes
gender_diff_weights.* - Simulated gender differences in brain structure
disease_weights.* - Simulated disease effects (e.g., Alzheimer's)
multi_subject_weights.* - Multi-subject data (200 regions x 10 subjects)
tstatistics_weights.* - Data scaled to typical t-statistic ranges (-5 to 5)
zscores_weights.* - Data scaled to z-score ranges (-3 to 3)
effect_sizes_weights.* - Data scaled to effect size ranges (-2 to 2)
sparse_activation_weights.* - Sparse activation pattern (70% zeros)

File formats:
- .mat files: MATLAB format, can be loaded directly in GUI
- .csv files: Comma-separated values, compatible with most software

Usage in GUI:
1. Start the GUI: launch_gui()
2. Click "Browse Weight File" and select any .mat or .csv file
3. Choose visualization options and click "Generate Plot"
