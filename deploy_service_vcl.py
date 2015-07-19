import sys
import requests
import json


def deploy_service_vcl(self, service_id, version_to, x_file, activate=0, version_from= 0, clone=0):

    # upload specific service VCL
    # if the version in progress is already cloned, enter 0 for second/fourth argument,
    # else enter 1 to clone new version and the version_from


    headers = {'Fastly-Key': 'KEY',
                'Accept': 'application/json',
                'Content-Type': 'application/x-www-form-urlencoded'}

    # clone service version
    if clone == 0:
        pass
    else:
         url = "https://api.fastly.com/service/" + str(service_id) + "/version/" + str(version_from) + "/clone"
         r = requests.put(url, headers=headers)

        print url
        print r.text


    # upload file for service
    vcl_file = open(str(x_file))
    vcl_data = {'content': vcl_file.read(),
                'main': 'false',
                'name': str(x_file)}

    url = "https://api.fastly.com/service/" + str(service_id) + "/version/" + str(version_to) + "/vcl"
    r = requests.post(url, data=vcl_data, headers=headers)

    print url
    print r.text

if __name__ == "__main__":
     deploy_service_vcl(*sys.argv)