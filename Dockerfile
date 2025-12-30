# ===================================
# STAGE 1: Build WAR file
# ===================================
FROM eclipse-temurin:17-jdk-alpine AS builder

# Install Apache Ant
RUN apk add --no-cache wget && \
    wget -q https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.14-bin.tar.gz && \
    tar -xzf apache-ant-1.10.14-bin.tar.gz -C /opt && \
    rm apache-ant-1.10.14-bin.tar.gz && \
    ln -s /opt/apache-ant-1.10.14/bin/ant /usr/local/bin/ant

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Build WAR file using Ant
RUN ant clean dist

# ===================================
# STAGE 2: Runtime
# ===================================
FROM tomcat:9.0.112-jdk17

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from builder stage
COPY --from=builder /app/dist/PBO-Project.war /usr/local/tomcat/webapps/PBO-Project.war

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
