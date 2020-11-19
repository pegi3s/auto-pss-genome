# Auto-PSS-Genome [![license](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/pegi3s/auto-pss-genome) [![dockerhub](https://img.shields.io/badge/hub-docker-blue)](https://hub.docker.com/r/pegi3s/auto-pss-genome) [![compihub](https://img.shields.io/badge/hub-compi-blue)](https://www.sing-group.org/compihub/explore/5faa52ccf05e940c9c2762e4)
> **Auto-PSS-Genome** (Automatic Positively Selected Sites Genome) is a [Compi](https://www.sing-group.org/compi/) pipeline to automatically identify positively selected amino acid sites using three different methods, namely CodeML, omegaMap, and FUBAR in complete genomes (FASTA files containing all coding sequences). A Docker image is available for this pipeline in [this Docker Hub repository](https://hub.docker.com/r/pegi3s/auto-pss-genome).

## Auto-PSS-Genome repositories

- [GitHub](https://github.com/pegi3s/auto-pss-genome)
- [DockerHub](https://hub.docker.com/r/pegi3s/auto-pss-genome)
- [CompiHub](https://www.sing-group.org/compihub/explore/5faa52ccf05e940c9c2762e4)

# What does Auto-PSS-Genome do?

**Auto-PSS-Genome** (Automatic Positively Selected Sites Genome) is a [Compi](https://www.sing-group.org/compi/) pipeline to automatically identify positively selected amino acid sites (PSS) using three different methods, namely CodeML, omegaMap, and FUBAR in complete genomes (FASTA files containing all coding sequences).
 
This process comprises the following steps:

1. Use the [**GenomeFastScreen**](https://github.com/pegi3s/pss-genome-fs) pipeline to quickly identify genes that likely show PSS.
2. Apply the [**CheckCDS**](https://github.com/pegi3s/check-cds) to the files that failed to be analyzed by GenomeFastScreen in order to try to convert them into valid CDS files.
3. Reanalyze such files using GenomeFastScreen.
4. Finally, perform a more detailed analysis of all the genes that likely show PSS using the [**IPSSA**](https://github.com/pegi3s/ipssa) pipeline.

# Using the Auto-PSS-Genome image in Linux
In order to use the Auto-PSS-Genome image, create first a directory in your local file system (`auto_pss_genome_project` in the example) with the following structure: 

```bash
auto_pss_genome_project/
├── input
│   ├── 1.fasta
│   ├── 2.fasta
│   ├── .
│   ├── .
│   ├── .
│   └── n.fasta
│
├── global
│   └── global-reference-file.fasta
│
├── pss-genome-fs.params
├── ipssa-project.params
└── check-cds.params
```

Where:

- The input FASTA files to be analized must be placed in the `auto_pss_genome_project/input` directory.
- Optionally, the global reference FASTA file for the GenomeFastScreen pipeline must be placed at `auto_pss_genome_project/global/global-reference-file.fasta`.
- The `pss-genome-fs.params` file contains the Compi parameters file for the GenomeFastScreen pipeline.
- The `ipssa-project.params` file contains the Compi parameters file for the IPSSA pipeline.
- The `check-cds.params` file contains the Compi parameters file for the CheckCDS pipeline.

You can populate the Auto-PSS-Genome project directory, including sample Compi parameter files with default values, running the following command (here, you only need to set `AUTO_PSS_GENOME_PD` to the right path in your local file system):

```bash
AUTO_PSS_GENOME_PD=/path/to/auto_pss_genome_project

docker run --user "$(id -u):$(id -g)" --rm -v ${AUTO_PSS_GENOME_PD}:/working_dir pegi3s/auto-pss-genome init-working-dir.sh /working_dir
```

Now, you should:

1. Put the input FASTA files in the `auto_pss_genome_project/input` directory.
2. If required, put the global reference FASTA file in the `auto_pss_genome_project/global` directory.
3. Edit the parameters of the GenomeFastScreen pipeline in the `pss-genome-fs.params` file. Here it is mandatory to set the `reference_file` to be the name of a file in the `auto_pss_genome_project/input` directory and `blast_type`. Optionally, set the `global_reference_file` value (and remove the `#` at the beginning of the line).
4. Edit the parameters of the CheckCDS pipeline in the `check-cds.params` file. Here you only need to provide the reference word (case insensitive) in the sequence headers to identify the reference sequences when trying to create valid CDS files.
5. Check the values of the parameters of the IPSSA pipeline in the `ipssa-project.params` file. This file contains the default recommended values for this pipeline and may need to be adjusted.

Once this structure and files are ready, you should run and adapt the following commands to run the entire pipeline. Here, you only need to set `AUTO_PSS_GENOME_PD` to the right path in your local file system and `COMPI_NUM_TASKS` to the maximum number of parallel tasks that can be run. Note that the `--host_working_dir` is mandatory and must point to the pipeline working directory in the host machine.

```bash
AUTO_PSS_GENOME_PD=/path/to/auto_pss_genome_project
COMPI_NUM_TASKS=6

docker run --rm -v /tmp:/tmp -v /var/run/docker.sock:/var/run/docker.sock -v ${AUTO_PSS_GENOME_PD}:/working_dir --rm pegi3s/auto-pss-genome /compi run -o --logs /working_dir/logs --num-tasks ${COMPI_NUM_TASKS} -- --host_working_dir ${AUTO_PSS_GENOME_PD} --compi_num_tasks ${COMPI_NUM_TASKS}
```

# Test data

The sample data is available [here](https://github.com/pegi3s/auto-pss-genome/raw/master/resources/test-data/auto-pss-genome-m-haemophylum.zip). Download and uncompress it, and move the directory named `auto-pss-genome-m-haemophylum`, where you will find:

- A directory called `auto-pss-genome-project`, that contains the structure described previously.
- A file called `run.sh`, that contains the following commands (where you should adapt the `AUTO_PSS_GENOME_PD` path) to test the pipeline:

```bash
AUTO_PSS_GENOME_PD=/path/to/auto-pss-genome-project
COMPI_NUM_TASKS=8

docker run --rm -v /tmp:/tmp -v /var/run/docker.sock:/var/run/docker.sock -v ${AUTO_PSS_GENOME_PD}:/working_dir --rm pegi3s/auto-pss-genome /compi run -o --logs /working_dir/logs --num-tasks ${COMPI_NUM_TASKS} -- --host_working_dir ${AUTO_PSS_GENOME_PD} --compi_num_tasks ${COMPI_NUM_TASKS}
```

## Running times

- ≈ 11.5 hours - 50 parallel tasks - Ubuntu 18.04.2 LTS, 96 CPUs (AMD EPYC™ 7401 @ 2GHz), 1TB of RAM and SSD disk.

# For Developers

## Building the Docker image

To build the Docker image, [`compi-dk`](https://www.sing-group.org/compi/#downloads) is required. Once you have it installed, simply run `compi-dk build` from the project directory to build the Docker image. The image will be created with the name specified in the `compi.project` file (i.e. `pegi3s/auto-pss-genome:latest`). This file also specifies the version of compi that goes into the Docker image.
