project             = "polar-standard-389516" # project name
region              = "europe-north1" # region
location            = "europe-north1-c" # zone
instance_type       = "e2-medium"
node_count          = "3"
gcp_auth_file       = "./files/key.json" # Service accaunt key for the project
app_name            = "load-cluster" # Name for your app
registry_username   = "apper" # User name Dockerhub
registry_password   = "<password>" # pass Dockerhub
registry_email      = "app@gmail.com" # Mail DockerHub
registry_server     = "docker.io" # -
