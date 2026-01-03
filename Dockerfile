# ===================================
# Dockerfile untuk The Object Hour
# ===================================
# Menggunakan WAR file yang sudah di-build

FROM tomcat:9.0.112-jdk17

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file yang sudah di-build
COPY dist/PBO-Project.war /usr/local/tomcat/webapps/PBO-Project.war

# Expose Tomcat port
EXPOSE 8080

# Set environment variables for database (can be overridden in docker-compose)
# These will be loaded from .env file via docker-compose.yml
ENV DB_URL=${DB_URL}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV DB_DRIVER=${DB_DRIVER}
ENV SUPABASE_URL=${SUPABASE_URL}
ENV SUPABASE_SERVICE_KEY=${SUPABASE_SERVICE_KEY}
ENV SUPABASE_BUCKET=${SUPABASE_BUCKET}

# Start Tomcat
CMD ["catalina.sh", "run"]

