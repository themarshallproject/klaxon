## Modify environment variables

edit env_local.list (found in the docker_example directory) and use your own values for things like database_url, admin_email, etc. 


## Build the image from The Marshall Project's github repo (using the develop branch)

`docker build --network host -t klaxon https://github.com/themarshallproject/klaxon.git#develop`


## Run it on your local machine as a daemon

cd into the docker_example directory in this repo and run the following. You only need to be in this directory because we used a relative path to the env_local.list file.

`docker run -p 8885:3000 --name klaxon_local --env-file ./env_local.list --restart unless-stopped -d klaxon`


## View the app

Go to your browser and hit `127.0.0.1:8885` .



