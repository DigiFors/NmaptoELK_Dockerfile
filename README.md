# NmaptoELK_Dockerfile

With this Dockerfile you can build an image to visualize your NMAP-Output with Kibana.
After starting the Dockercontainer with
docker run -p 80:80 -p 8000:8000 -t -i <dockercontainerID> 
Use either your local machine (cmd, shell, .etc) or your docker terminal to execute your NMAP command.
Afterwards you can login to kibana via your DockerIP and visualize your NMAPOutput.
The username= kibanaadmin and the password= Start23!
You can change this by editing htpasswd.users which is located at /etc/nginx/htpasswd.users in your Dockercontainer.


