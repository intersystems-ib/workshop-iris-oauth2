FROM nginx AS run
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY dist/angular-auth-demo /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
