<img src="https://github.com/kiprotichgidii/advicemate/blob/main/images/project-preview.png?raw=true"></img>


<h1 align="center">Advice Generator Web App</h1>

## About The Project

<p>The perfect project if you're learning how to interact with 3rd-party APIs. This challenge uses the Advice Slip API to generate random quotes of advice.
The challenge is to build out this advice generator app using the Advice Slip API and get it looking as close to the design as possible.
You can use any tools you like to help you complete the challenge. So if you've got something you'd like to practice, feel free to give it a go.
<br><br>Users should be able to:
<br>1. View the optimal layout depending on their device's screen size.
2. See hover states for all interactive elements on the page.
<br>
3. Generate a new piece of advice by clicking the dice icon.
<br> <p>I do not have access to the Figma sketch so the design is not pixel perfect.</p>


## Built with 

- Semantic HTML5 markup
- CSS custom properties
- Flex
- Grid
- Mobile-first workflow
- Advice Slip API - random quote generator

## Deploying AdviceMate

### Overview

This guide documents the deployment of the AdviceMate web application on a Linux Mint server using Nginx as the web server. AdviceMate is a frontend application that generates random advice quotes using the Advice Slip API.

### Prerequisites

- Linux Mint server with sudo privileges
- Internet connection for downloading packages and API access
- Basic knowledge of terminal commands

### Step 1: System Preparation

#### Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

#### Install Required Software

```bash
# Install Git for repository cloning
sudo apt install git -y

# Install Nginx web server
sudo apt install nginx -y

# Verify Nginx installation
nginx -v
```

### Step 2: Clone the Repository

#### Navigate to Working Directory

```bash
cd ~
```

#### Clone the AdviceMate Repository

```bash
git clone https://github.com/kiprotichgidii/advicemate.git
```

#### Verify Repository Contents

```bash
cd advicemate
ls -la
```

### Step 3: Set Up Web Directory

#### Create Standard Web Directory

```bash
# Create the web directory
sudo mkdir -p /var/www/advicemate
```

#### Copy Application Files

```bash
# Copy all files to the web directory
sudo cp -r /home/cloudspinx/advicemate/* /var/www/advicemate/

# Alternative: Copy from current directory if you're in the advicemate folder
# sudo cp -r ./* /var/www/advicemate/
```

#### Set Proper Ownership and Permissions

```bash
# Set ownership to www-data (Nginx user)
sudo chown -R www-data:www-data /var/www/advicemate

# Set appropriate permissions
sudo chmod -R 755 /var/www/advicemate

# Verify permissions
ls -la /var/www/advicemate/
```

### Step 4: Configure Nginx

#### Create Site Configuration

```bash
sudo nano /etc/nginx/sites-available/advicemate
```

#### Add Configuration Content

```nginx
server {
    listen 80;
    server_name _;
    
    # Document root pointing to web directory
    root /var/www/advicemate;
    index index.html index.htm;
    
    # Main location block
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Security headers
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
    
    # Cache static assets for better performance
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Disable access to hidden files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}
```

#### Enable the Site

```bash
# Create symbolic link to enable the site
sudo ln -s /etc/nginx/sites-available/advicemate /etc/nginx/sites-enabled/

# Verify the link was created
ls -la /etc/nginx/sites-enabled/ | grep advicemate
```

#### Disable Default Nginx Site (Optional)

```bash
# Remove default site to avoid conflicts
sudo unlink /etc/nginx/sites-enabled/default
```

### Step 5: Test and Start Services

#### Test Nginx Configuration

```bash
sudo nginx -t
```

Expected output:
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

#### Reload Nginx Configuration

```bash
sudo systemctl reload nginx
```

#### Ensure Nginx Starts on Boot

```bash
sudo systemctl enable nginx
```

#### Verify Nginx Status

```bash
sudo systemctl status nginx
```

### Step 6: Configure Firewall

#### Check UFW Status

```bash
sudo ufw status
```

#### Allow HTTP Traffic (if firewall is active)

```bash
sudo ufw allow 'Nginx Full'
# Or specifically allow port 80
# sudo ufw allow 80
```

### Step 7: Verify Deployment

#### Test Local Access

```bash
# Test with curl
curl -I http://localhost

# Check if index.html exists
cat /var/www/advicemate/index.html | head -10
```

#### Access from Browser

Navigate to your server's IP address:
- `http://your_server_ip`
- `http://192.168.1.192` (example)

#### Test Application Functionality

1. Open the web application in browser
2. Click the dice icon to generate new advice
3. Verify that new advice appears
4. Check browser developer tools for any API errors

### Step 8: Monitoring and Maintenance

#### View Access Logs

```bash
sudo tail -f /var/log/nginx/access.log
```

#### View Error Logs

```bash
sudo tail -f /var/log/nginx/error.log
```

#### Update Application

To update the application when changes are made to the repository:

```bash
# Navigate to original clone
cd ~/advicemate

# Pull latest changes
git pull origin main

# Copy updated files to web directory
sudo cp -r ./* /var/www/advicemate/

# Ensure proper permissions
sudo chown -R www-data:www-data /var/www/advicemate
sudo chmod -R 755 /var/www/advicemate

# Reload Nginx (optional, usually not needed for static content)
sudo systemctl reload nginx
```

### Optional Enhancements

#### SSL/HTTPS Setup with Let's Encrypt

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain SSL certificate (replace with your domain)
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Auto-renewal test
sudo certbot renew --dry-run
```

#### Custom Domain Configuration

If using a custom domain, update the Nginx configuration:

```nginx
server_name yourdomain.com www.yourdomain.com;
```

#### Performance Optimization

Add gzip compression to Nginx configuration:

```nginx
# Add inside server block
location ~* \.(js|css|html)$ {
    gzip on;
    gzip_vary on;
    gzip_types text/css application/javascript text/html;
}
```

### Troubleshooting

#### Common Issues and Solutions

##### 404 Not Found Error
- Verify file paths in Nginx configuration
- Check file permissions: `ls -la /var/www/advicemate/`
- Ensure index.html exists in the root directory

##### Permission Denied Error
- Check ownership: `sudo chown -R www-data:www-data /var/www/advicemate`
- Set proper permissions: `sudo chmod -R 755 /var/www/advicemate`

##### API Not Working
- Check browser console for CORS or network errors
- Verify internet connectivity from server
- Test API directly: `curl https://api.adviceslip.com/advice`

##### Nginx Won't Start
- Test configuration: `sudo nginx -t`
- Check for port conflicts: `sudo netstat -tulnp | grep :80`
- Review error logs: `sudo tail /var/log/nginx/error.log`

#### Useful Commands

```bash
# Restart all services
sudo systemctl restart nginx

# Check which process is using port 80
sudo lsof -i :80

# View real-time logs
sudo tail -f /var/log/nginx/error.log /var/log/nginx/access.log

# Test website response
curl -I http://localhost
```

### File Structure

After deployment, your file structure should look like:

```
/var/www/advicemate/
├── index.html          # Main HTML file
├── style.css          # Stylesheet
├── script.js          # JavaScript functionality
├── images/            # Image assets (if any)
└── README.md          # Project documentation
```

### Security Considerations

1. **File Permissions**: Keep files readable but not writable by web server
2. **Hidden Files**: Nginx is configured to deny access to dotfiles
3. **Directory Listing**: Disabled by default configuration
4. **HTTPS**: Recommended for production deployments
5. **Regular Updates**: Keep system and web server updated

## What I learned
A really fun project to practice API with JavaScript. The only issue is that sometimes after requesting new quote, it generates the same so the visitor wouldn't notice it and think it didn't work. Probablt there are ways to avoid it but I decided not to spend much on this right now. 

P.S. 

Seems like the issue was cache, not repetitive quotes which is fixed now!


## Useful resources

1. <a href="https://www.figma.com/">Figma</a> - Paste your design image to check the size of containers, width, etc.
2. <a href="https://chrome.google.com/webstore/detail/perfectpixel-by-welldonec/dkaagdgjmgdmbnecmcefdhjekcoceebi">Perfect Pixel</a> - Awesome Chrome extension that helps you to match the pixels of the provided design.
3. <a href="https://api.adviceslip.com">Advice Slip API</a> - random quote generator.
  
**Server**: Linux Mint  
**Web Server**: Nginx  
**Application**: AdviceMate (Frontend SPA)  
**API**: Advice Slip API (https://api.adviceslip.com)