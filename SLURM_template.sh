 #!/bin/bash
 #This file is a submission script to request the ISAAC resources from Slurm 
 #SBATCH -J job			       #The name of the job
 #SBATCH -A ACF-UTK0011                            # The project account to be charged
 #SBATCH --nodes=1                                      # Number of nodes
 #SBATCH --ntasks-per-node=48                   # cpus per node 
 #SBATCH --partition=campus                     # If not specified then default is "campus"
 #SBATCH --time=0-01:00:00                       # Wall time (days-hh:mm:ss)
 #SBATCH --error=job.e%J		      # The file where run time errors will be dumped
 #SBATCH --output=job.o%J		      # The file where the output of the terminal will be dumped

 # Now list your executable command/commands.
 # Example for code compiled with a software module:
 module load example/test

#always start with cd to change to where you want files to be stored
