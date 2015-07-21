#FastlyUploadTest

Python Files:

* Config:
  * Common files and expressions that can be removed from the individual python scripts

* Activate
  * To prevent bad deployments, this is a separate file and function

* Deploy_VCL
  * The goal of this file is the walk the user through creating a new version or editing the current version (not activated)
    * params needs to initiate script is just the service_id
    * User first determines if they need to clone
    * Then user can upload the device_detect file
    * Next user can update the master vcl
    * Lastly, the user upload service specific files. the files name is an input variable within the script and call accordingly
    * The final call check version status for errors

  Note: More common files can be added (i.e Caching Rules)

  The script can be tested on my account: cassandra Fastly-Test, service: Videos
  The Fastly Key will need to be updated




