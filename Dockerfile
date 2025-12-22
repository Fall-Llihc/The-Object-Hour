# Use Tomcat with JDK 17
FROM tomcat:9.0.112-jdk17

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy pre-built WAR file from dist directory
# Build the WAR locally first using NetBeans: ant clean dist
COPY dist/PBO-Project.war /usr/local/tomcat/webapps/PBO-Project.war

# Expose Tomcat port
EXPOSE 8080

# Set environment variables for database (can be overridden in docker-compose)
ENV DB_HOST=aws-1-ap-south-1.pooler.supabase.com
ENV DB_PORT=5432
ENV DB_NAME=postgres
ENV DB_USER=postgres.ykdfyoirtmkscsygyedr
ENV DB_PASSWORD=your_password_here

# Start Tomcat
CMD ["catalina.sh", "run"]
