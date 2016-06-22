from config_cass import *
#from config import *
import sys
import glob
import errno
import os

path = '/Users/cassandra/FastlyUploadTest/vcl/*.vcl'


def get_version(service_id):
    # common pattern
    service_version = "service/" + str(service_id) + "/version"

    # get latest version
    url = fastly_api + service_version
    r = requests.get(url, headers=headers)

    version_from = ((r.content.split("{")[-1]).split(",")[2]).split(":")[-1]
    version_to = str(int(version_from) + 1)
    version_status = ((r.content.split("{")[-1]).split(",")[3]).split(":")[-1]

    if version_status == "null":
       state = "not activated"
    elif version_status == "true":
       state = "activated"
    else:
        state = "unknown"

    # determine if cloning is necessary to update VCL configuration
    clone_answer = raw_input("Latest version is %s. Do you want to clone version?( Y/N) " %(state))

    return (clone_answer, version_from, version_to)



def upload_file(service_id, version):
      # common pattern
      service_version = "service/" + str(service_id) + "/version"

      directory = glob.glob(path)
      for vcl_file in directory:
          try:
            base = os.path.basename(vcl_file)
            with open(vcl_file) as name:
              #print base
              if base == "master.vcl":
                 vcl_data = {'content': name.read(),
                             'name': base,
                             'main': 'true'}
              else:
                 vcl_data = {'content': name.read(),
                             'main': 'false',
                             'name': base}

              url = fastly_api + service_version + "/" + version + "/vcl"
              r = requests.post(url, data=vcl_data, headers=headers)

              print r.url
              if "Duplicate" in r.text:
                url = fastly_api + service_version + "/" + version + "/vcl/" + base
                #use put instead of post to update the file
                r = requests.put(url, data=vcl_data, headers=headers)

                print r.url


              print "Uploaded:\n\n" + r.text
              print "==========================="

          except IOError as exc:
            if exc.errno != errno.EISDIR:
            # Do not fail if a directory is found, just ignore it.
                raise
                # Propagate other kinds of IOError.





def deploy_vcl(self, service_id):

    # upload common VCL files across all services
    # This includes master_vcl, device_detect

    # common pattern
    service_version = "service/" + str(service_id) + "/version"

    # determine if configuration needs to be cloned
    response = get_version(service_id)

    clone_answer = response[0]
    version_from = response[1]
    version_to   = response[2]

    if clone_answer.lower() == "y":
    # clone service version
      url = fastly_api + service_version + "/" + version_from + "/clone"
      r = requests.put(url, headers=headers)

      version = version_to

      print "Version Cloned:\n\n" + r.text
      print "==========================="

    else:
      version = version_from

    print "Working Version is: " + version

    upload_file(service_id, version)

    print " Done loading files. Checking Verison Status:\n\n"
    print "==========================="

    # Check status of version
    url = fastly_api + service_version + "/" + version + "/validate"
    r = requests.get(url, headers=headers)

    print " Version Status:\n\n" + r.text
    print "==========================="



if __name__ == "__main__":
     deploy_vcl(*sys.argv)