# Create chef image that installs cargo chef
FROM rust:latest as chef
RUN cargo install cargo-chef
WORKDIR app

# Create our planner image
FROM chef as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
# Build dependencies - this is the caching docker layer!
RUN cargo chef cook --release --recipe-path recipe.json

# Copy everything in current app
COPY . ./app

# Set the working directory to the app folder that we just copied everything in to.
WORKDIR /app

# Build the image using release tag
RUN cargo build --release

# Pull down small debian image hosted on google container repo
FROM gcr.io/distroless/cc-debian11 AS runtime

# Copy release build from builder image
COPY --from=builder /app/target/release/Desk1Datamart /app/Desk1Datamart
WORKDIR /app

CMD ["./Desk1Datamart"]
