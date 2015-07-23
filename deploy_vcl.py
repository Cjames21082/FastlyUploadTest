from config import *

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



def upload_file(service_id, version, input_file):
      # common pattern
      service_version = "service/" + str(service_id) + "/version"

      vcl_file = open(input_file)
      if input_file == "master":
         vcl_data = {'content': vcl_file.read(),
                     'name': input_file,
                      'main': 'true'}
      else:
         vcl_data = {'content': vcl_file.read(),
                     'main': 'false',
                     'name': input_file}

      url = fastly_api + service_version + "/" + version + "/vcl"
      r = requests.post(url, data=vcl_data, headers=headers)

      print r.url
      if "Duplicate" in r.text:
        url = fastly_api + service_version + "/" + version + "/vcl/" + input_file
        r = requests.put(url, data=vcl_data, headers=headers)

        print r.url


      print  input_file + " Uploaded:\n\n" + r.text
      print "==========================="




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

    # Determine if device_detect needs to be updated/uploaded
    device_detect = raw_input("Upload device_detect file? (Y/N) ")

    # upload file for device_detect.vcl
    if device_detect.lower() == "y":
      input_file = "device_detect"
      upload_file(service_id, version, input_file)


    # determine if master.vcl needs to be updated/uploaded
    continue_master = raw_input("Continue with Master VCL upload?(Y/N) ")


    if continue_master.lower() == "y":
    # set master vcl
      input_file = "master"
      upload_file(service_id, version, input_file)



    # upload VCL files specific to services
    continue_service_upload = raw_input("Upload another service file?(Y/N) ")


    while continue_service_upload.lower() == "y":

     # upload file for service
     input_file = raw_input("Enter file name: ")
     upload_file(service_id, version, input_file)

     continue_service_upload = raw_input("Upload another service file?(Y/N) ")

    print " Done loading files. Checking Verison Status:\n\n"
    print "==========================="

    # Check status of version
    url = fastly_api + service_version + "/" + version + "/validate"
    r = requests.get(url, headers=headers)

    print " Version Status:\n\n" + r.text
    print "==========================="



if __name__ == "__main__":
     deploy_vcl(*sys.argv)