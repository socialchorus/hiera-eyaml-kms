require 'hiera/backend/eyaml/encryptors/kms'
require 'hiera/backend/eyaml/encryptors/awssec'

Hiera::Backend::Eyaml::Encryptors::Kms.register
Hiera::Backend::Eyaml::Encryptors::AWSSec.register
