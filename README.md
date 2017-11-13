# openstack-APIs

Every normalized OpenStack project's API is documented and referenced by the [API guide](https://developer.openstack.org/api-guide/quick-start/index.html). This has provided the opportunity to get OpenStack APIs schemas for SDKs consumption.

On the long run the schema to reside respective Openstack project source repos.

## To regenerate API(s) schema(s)
The APIs schema can be regenerated from their respective API reference using the command:  
`./fetch`

Use the module otpion to process only one or few projects:    
`./fetch -m cinder -m neutron`
