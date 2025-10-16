# Simple static site container
FROM nginx:1.27-alpine

# Copy static files into Nginx HTML directory
COPY index.html /usr/share/nginx/html/index.html

# Optional: add favicon or css/js if you have more assets
COPY projects.html /usr/share/nginx/html/projects.html
COPY assets/ /usr/share/nginx/html/assets/
COPY js/ /usr/share/nginx/html/js/

EXPOSE 80

# Default Nginx entrypoint
CMD ["nginx", "-g", "daemon off;"]
# acces at http://localhost:8080/ or http://daviles-.42.fr:8080/
