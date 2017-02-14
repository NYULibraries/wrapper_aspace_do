This is a wrapper script that uses scripts from here: https://github.com/NYULibraries/aspace-do-update to update ArchivesSpace with handle urls and usage statements. 

To run, you need to first set up your credentials files like this: https://github.com/NYULibraries/aspace-do-update#credentials-files and then export an ENV variable to point to the credentials file that you want to use: https://github.com/NYULibraries/aspace-do-update#usage

Create a gemset from the aspace-do-update scripts.

Once that is done, create a file with a list of directories from the wip that needs to be updated in ASpace.

We are to update someone that we are running the script. The wrapper script has an email method, so it needs the email address as an argument.

Use the gemset and call the wrapper script with the following parameters:
`ruby run_aspace_do.rb list_of_dirs.txt email_address collection_name wip_path`

So, for example:
`ruby run_aspace_do.rb nitrates.txt "someone[at]domain.com" "Sylvester Manor" /path/to/wip/`



