FROM rust:1.54 as builder

RUN cargo install mdbook --vers "^0.4.15"

WORKDIR /app
COPY . .
RUN mdbook build

FROM nginx:stable-alpine as production-stage
COPY --from=builder /app/book /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
