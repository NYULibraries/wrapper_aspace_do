This is a wrapper script that uses scripts from [here](https://github.com/NYULibraries/aspace-do-update) to update ArchivesSpace with handle urls and usage statements. 

Clone the repo from [here](https://github.com/NYULibraries/aspace-do-update).

To run, you need to first set up your credentials [files](https://github.com/NYULibraries/aspace-do-update#credentials-files) and then export an ENV [variable](https://github.com/NYULibraries/aspace-do-update#usage) to point to the credentials file that you want to use.

Create a gemset from the aspace-do-update scripts.

Once that is done, create a file with a list of directories from the wip that needs to be updated in ASpace.

We are to update ACM that we are running the script. 

Use the gemset and call the wrapper script with the following parameters:
`ruby run_aspace_do.rb list_of_dirs.txt wip_path`

So, for example:
`ruby run_aspace_do.rb nitrates.txt /path/to/wip/`



