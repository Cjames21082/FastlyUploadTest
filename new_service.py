# Fastly APIs used for Beta:

from config_cass import *

def service_test():
# Create a service
      # vcl_data ={'name' : 'service_3'}

      # url = fastly_api + "/service"
      # r = requests.post(url, data=vcl_data, headers=headers)

      # print r.text
      # print r.status_code

# Add a domain
      # vcl_data ={'name' : 'fast.wohlers.org'}

      # url = fastly_api + "/service/service_id/version/version-number/domain"
      # r = requests.post(url, data=vcl_data, headers=headers)

      # print r.text
      # print r.status_code

# List domains/backend for a service/version
        # url = fastly_api + "/service/2uVMAGXeWLu72CbQSlXyy/version/version-number/backend"
        # r = requests.get(url, headers=headers)

        # print r.text
        # print r.status_code

# Add a backend
        # vcl_data ={'address': 'foo-2.testly.com',
        #            'name' : 'test-backend3',
        #            'port' :'40'}

        # url = fastly_api + "/service/service_id/version/version-number/backend"
        # r = requests.post(url, data=vcl_data, headers=headers)

        # print r.text
        # print r.status_code

# Get version
        # url = fastly_api + "/service/service_id/version/version-number"
        # r = requests.get(url, headers=headers)

        # print r.text
        # print r.status_code

# Validate a version
    # url = fastly_api + "/service/service_id/version/version-number/validate"
    # r = requests.get(url, headers=headers)

    # print r.text
    # print r.status_code

# activate/deactivate a version
    # url = fastly_api + "/service/service_id/version/version-number/deactivate"
    # r = requests.put(url, headers=headers)

    # print r.text
    # print r.status_code

# delete a service
    # url = fastly_api + "/service/service_id"
    # r = requests.delete(url, headers=headers)

    # print r.text
    # print r.status_code

# get stats by service
# provides data by datacenter
    # url = fastly_api + "/service/1JU4Fn5JaHxofNEo2sncfC/stats/summary?year=2015&month=10"
    # r = requests.get(url, headers=headers)

    # print r.text
    # print r.status_code

# get historical stats by service
    # url = fastly_api + "/stats/service/1JU4Fn5JaHxofNEo2sncfC?from=1000+day+ago"
    # r = requests.get(url, headers=headers)

    # print r.text
    # print r.status_code

# get usage information aggregated by service and grouped by service & region
    url = fastly_api + "/stats/usage_by_service?from=1%2F1%2F2014&to=1%2F1%2F2015"
    r = requests.get(url, headers=headers)

    print r.text
    print r.status_code






if __name__ == "__main__":
     service_test()