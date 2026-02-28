# Etapa 1: Build
FROM node:18-alpine AS build-stage
WORKDIR /app

# Copiamos solo los archivos de dependencias primero para aprovechar el caché de capas de Docker
COPY package*.json ./
RUN npm install

# Copiamos el resto del código y generamos los archivos estáticos
COPY . .
RUN npm run build

# Etapa 2: Producción (Servidor Web)
FROM nginx:stable-alpine AS production-stage

# Copiamos los archivos compilados desde la etapa anterior a la carpeta de Nginx
COPY --from=build-stage /app/build /usr/share/nginx/html

# Exponemos el puerto 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]