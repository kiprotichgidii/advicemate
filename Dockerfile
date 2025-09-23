# Using the officical Nginx image as the base image
FROM nginx:alpine
# Copy custom nginx configuration file to the container
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf
# Copy the static files into the container
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/
COPY app.js /usr/share/nginx/html/
# Expose port 80
EXPOSE 80
# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]