```
git clone https://github.com/tropicloud/wp-micro.git
docker build -t wp-micro wp-micro
docker run -it -p 80:80 -p 443:443 -h example.com wp-micro
```