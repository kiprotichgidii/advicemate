# Using the officical Nginx image as the base image
FROM nginx:latest
# Create app directory
RUN mkdir -p /var/www/advicemate
# Copy the static files into the container
COPY index.html /var/www/advicemate/
COPY styles.css /var/www/advicemate/
COPY images/ /var/www/advicemate/images/
COPY app.js /var/www/advicemate/
# Copy custom nginx configuration file to the container
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 5000
EXPOSE 5000
# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]