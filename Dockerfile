# Imagen para Easypanel (o cualquier servidor con Docker)
FROM node:22-alpine

WORKDIR /app
ENV NODE_ENV=production \
    DATA_DIR=/app/data \
    PORT=3000

RUN apk add --no-cache su-exec

COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY . .
RUN sed -i 's/\r$//' docker-entrypoint.sh && chmod +x docker-entrypoint.sh && mkdir -p /app/data/uploads

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD wget -qO- http://127.0.0.1:3000/healthz || exit 1

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["node", "--disable-warning=ExperimentalWarning", "src/server.js"]
