from shortcuts import *


def activate(self, service_id):

  # common pattern
  service_version = "service/" + str(service_id) + "/version"

  # get latest version
  url = fastly_api + service_version
  r = requests.get(url, headers=headers)


  version = ((r.content.split("{")[-1]).split(",")[2]).split(":")[-1]

  print "Checking Working Verison : " + version
  print "==========================="

  # Check status of version
  url = fastly_api + service_version + "/" + version + "/validate"
  r = requests.get(url, headers=headers)

  print " Version Status:\n" + r.text
  print "==========================="


  # Activate Version
  activate_version = raw_input("Activate Version?(Y/N)")

  if activate_version.lower() == "y":
     url = fastly_api + service_version + "/" + version + "/activate"
     r = requests.get(url, headers=headers)

     print " Version " + version + " Activated:\n" + r.text
  else:
  	print "Goodbye"

  print "==========================="

if __name__ == "__main__":
     activate(*sys.argv)