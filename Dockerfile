# Create our builder from latest rust image
FROM rust:latest as builder

# Copy everything in current app
COPY . ./app

# Set the working directory to the app folder that we just copied everything in to.
WORKDIR /app

# Build the image using release tag
RUN cargo build --release

# Pull down small debian image hosted on google container repo
FROM gcr.io/distroless/cc-debian11

# Copy release build from builder image
COPY --from=builder /app/target/release/Desk1Datamart /app/Desk1Datamart
WORKDIR /app

CMD ["./Desk1Datamart"]
