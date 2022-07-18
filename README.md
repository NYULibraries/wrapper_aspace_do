This is a wrapper script that uses scripts from [here](https://github.com/NYULibraries/aspace-do-update) to update ArchivesSpace with handle urls and usage statements. 

Clone the repo from [here](https://github.com/NYULibraries/aspace-do-update).

To run, you need to first set up your credentials [files](https://github.com/NYULibraries/aspace-do-update#credentials-files) and then export an ENV [variable](https://github.com/NYULibraries/aspace-do-update#usage) to point to the credentials file that you want to use.

Create a gemset from the aspace-do-update scripts.

Once that is done, create a file with a list of directories from the wip that needs to be updated in ASpace.

We are to update ACM that we are running the script. 

Export the path to the aspace-do-update executable in the environment variable: `RUN_ASPACE_DO_UPDATER_PATH`
e.g., `$ export RUN_ASPACE_DO_UPDATER_PATH=/path/to/aspace-do-update/bin/aspace-do-update`

Use the gemset and call the wrapper script with the following parameters:
`ruby run_aspace_do.rb <list_of_dirs.txt> <type-of-service> <wip_path>`

##### Acceptable parameters for <type-of-service> are:
* audio-service
* video-service
* image-service
* image-thumbnail 

So, for example:
`$ ruby run_aspace_do.rb nitrates.txt 'image-service' /path/to/wip/` 
where `nitrates.txt` contains a list of directories like so:
```
dir1
dir2
```


##### Testing:
`$ rake`
