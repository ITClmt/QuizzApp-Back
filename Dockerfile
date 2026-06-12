FROM node:22-alpine
RUN apk add --no-cache python3 make g++
RUN npm install -g pnpm@9
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm prisma generate
EXPOSE 3000
CMD ["sh", "-c", "pnpm prisma migrate deploy && pnpm start:dev"]
