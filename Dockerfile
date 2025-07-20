# Stage 1: Build the React client application
FROM node:18-alpine AS client-build
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build


# Stage 2: Build the Node.js server and copy the client into it
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV production

COPY package*.json ./
RUN npm install
COPY . .
# Copy the built client from the previous stage
COPY --from=client-build /app/client/build ./client/build

# Expose the port and start the server
EXPOSE 10000
CMD [ "node", "server.js" ]
