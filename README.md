# openstack-APIs

Every normalized OpenStack project's API is documented and referenced by the [API guide](https://developer.openstack.org/api-guide/quick-start/index.html). This has provided the opportunity to get OpenStack APIs schema for SDKs consumption.

On the long run maybe the schema will reside into respective Openstack project source repos.

## APIs Definitions
The rich variety of OpenStack projects requires lots of Application Program Interfaces to handle.  
Maintaining and extending those APIs implies a structural complexity challenge.  
Therefore the more automated the process, the better.  

Thanks to the help of Phoenix project which has provided a standard for OpenStack APIs reference.  

The APIs interface definitions are generated automatically from the API-ref reference manuals (misty-builder) which
allows:
* More consistent APIs
* More recent APIs definitions
* Easier addition of a new service's API

## To regenerate API(s) schema
The APIs schema can be regenerated from their respective API reference using the command:  
`./fetch`

Use the module otpion to process only one or few projects:    
`./fetch -m cinder -m neutron`
