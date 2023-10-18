# Preparing B+ submission files

Since `pegi3s/auto-pss-genome:1.11.0` there are included several scripts to help in preparing B+ submission files. 

To use them, you should adapt and run the following command:
```shell
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /your/data/dir:/data pegi3s/auto-pss-genome <bpos_option> /your/data/dir
```

In this command, you should replace:

- `/your/data/dir` to point to the working directory where the `ipssa_project` folder and the `ipssa-project.params` are located (appears twice).
- `<bpos_option>` to the name of the script to be run, one of `bpos_codeml.sh`, `bpos_fubar.sh` or `bpos_omegamap.sh`, depending on whether you want to prepare codeML, FUBAR or Omegamap projects for submission to B+.
    
Depending on the selected option a folder named either `codeml_projects`, `fubar_projects` or `omegamap_projects` will be created, containing the `tar.gz` file(s) ready to be submitted to B+.
