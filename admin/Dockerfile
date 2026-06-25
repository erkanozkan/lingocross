# --- Build aşaması ---
FROM node:20-alpine AS build
WORKDIR /app

# Bağımlılıklar (cache dostu)
COPY package.json package-lock.json* ./
RUN npm ci

# Kaynak + build
COPY . .
# VITE_API_BASE_URL build zamanında gömülür (Railway build arg / env)
ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
RUN npm run build

# --- Çalışma aşaması ---
FROM node:20-alpine AS runtime
WORKDIR /app
RUN npm i -g serve
COPY --from=build /app/dist ./dist

# Railway PORT env'ini okur; SPA fallback için serve -s
EXPOSE 3000
CMD ["sh", "-c", "serve -s dist -l ${PORT:-3000}"]
