maintainer        "Eric Winter"
maintainer_email  "eric@webicus.com"
license           "Apache 2.0"
description       "dumps static hosts into known hosts."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.2.3"
recipe            "ssh_known_hosts", "Dyanmically generates /etc/ssh/known_hosts based on search indexes"
