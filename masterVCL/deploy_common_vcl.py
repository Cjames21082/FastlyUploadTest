import sys
import requests
import json


def deploy_common_vcl(self, service_id, version_from, version_to, master_vcl, device_detect=0):

    # upload common VCL files across all services
    # This includes master_vcl, device_detect

    headers = {'Fastly-Key': 'Key',
                'Accept': 'application/json',
                'Content-Type': 'application/x-www-form-urlencoded'}

    # clone service version
    url = "https://api.fastly.com/service/" + str(service_id) + "/version/" + str(version_from) + "/clone"
    r = requests.put(url, headers=headers)

    print url
    print r.text

    # set master.vcl
    url = "https://api.fastly.com/service/" + str(service_id) + "/version/" + str(version_to) + "/vcl/master/main"
    r = requests.put(url, headers=headers)

    print url
    print r.text

    # upload data for master.vcl
    vcl_file = open(str(master_vcl))
    vcl_data = {'content': vcl_file.read()}

    url = "https://api.fastly.com/service/" + str(service_id) + "/version/" + str(version_to) + "/vcl/master"
    r = requests.put(url, data=vcl_data, headers=headers)

    print url
    print r.text


    # upload file for device_detect.vcl
    # required for creation of new service.
    # No argument needed afterwards for updating
    if device_detect == 0:
        pass
    else:
       vcl_file = open(str(device_detect))
       vcl_data = {'content': vcl_file.read(),
                'main': 'false',
                'name': 'device_detect'}

       url = "https://api.fastly.com/service/" + str(service_id) + "/version/" + str(version_to) + "/vcl"
       r = requests.post(url, data=vcl_data, headers=headers)

       print url
       print r.text

if __name__ == "__main__":
     deploy_common_vcl(*sys.argv)