# How to store the password in a file with config
## An example of a .yml file is a config.yml file:

library(config)
default:
uid: "my-name"
pwd: "my-password"
  
## And to recall the information back from its directory:
  
config <- config::get(file = "conf/config.yml")
config$uid
config$pwd