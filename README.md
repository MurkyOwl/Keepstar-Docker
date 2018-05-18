# Keepstar docker-compose
[Keepstar Discord Auth](https://github.com/shibdib/keepstar)

not so neatly packaged in a docker-compose, 



run `bash <(curl -fsSL https://git.io/vpbj1)` to start the docker based installation.



## Docker SSL-Support

You can configure nginx in your server to serve the docker-based instances web server via SSL with the following example nginx configuration used for a `www.keepstar.dev` domain:

````conf
server {
    listen 80;
    server_name keepstar.dev www.keepstar.dev *.keepstar.dev;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name keepstar.dev www.keepstar.dev *.keepstar.dev;
    charset utf-8;
    client_max_body_size 128M;

    ssl_certificate ~/keepstar.dev.crt;
    ssl_certificate_key ~/keepstar.dev.key;

    location / {
      access_log off;
      proxy_pass http://127.0.0.1:8080;
      proxy_redirect off;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-Proto https;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
````

Certificates should be managed using `certbot` which you can read more about [here](https://letsencrypt.org/getting-started/).
