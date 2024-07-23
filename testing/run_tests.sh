#!/bin/sh
# This script should be run from the project root (/server/api)
home=$(pwd)

# Set up MinIO alias
mc alias set myminio http://minio:9000 $MINIO_ACCESS_KEY $MINIO_SECRET_KEY

# Check if the test bucket exists, if not, create it
if ! mc ls myminio/testbucket | grep -q "testbucket"; then
  echo "Creating test bucket..."
  mc mb myminio/testbucket
else
  echo "testbucket already exists."
fi

# List contents of the bucket to verify
echo "Contents of testbucket before uploading test.txt:"
mc ls myminio/testbucket

# Check if the test file exists in MinIO, if not, upload it
if ! mc ls myminio/testbucket | grep -q "test.txt"; then
  echo "Uploading test.txt to testbucket..."
  echo "This is a test file." > test.txt
  mc cp test.txt myminio/testbucket/test.txt
  upload_exit_code=$?
  rm test.txt
  if [ $upload_exit_code -eq 0 ]; then
    echo "Uploaded test.txt successfully"
  else
    echo "Failed to upload test.txt"
    exit 1
  fi
else
  echo "test.txt already in minio"
fi

# List contents of the bucket to verify
echo "Contents of testbucket after uploading test.txt:"
mc ls myminio/testbucket

# Run Go unit tests
echo "Running Go tests..."
cd "$home/app"
go test -v
GO_TEST_EXIT_CODE=$?

# Start the Go server in the background
cd "$home"
echo "Starting Go server..."
./docker-app &
GO_SERVER_PID=$!

# Wait for the server to be available
sleep 5

# Verify the file is indeed in MinIO
echo "Verifying the presence of test.txt in MinIO:"
if ! mc ls myminio/testbucket | grep -q "test.txt"; then
  echo "test.txt is not available in MinIO."
  kill $GO_SERVER_PID
  exit 1
fi

# Run Bun end-to-end testing
echo "Running Bun tests..."
cd "$home/testing"
bun test
BUN_TEST_EXIT_CODE=$?

# Kill the Go server
kill $GO_SERVER_PID

# Exit with the highest of the two exit codes
if [ $GO_TEST_EXIT_CODE -ne 0 ] || [ $BUN_TEST_EXIT_CODE -ne 0 ]; then
  echo "One or more tests failed."
  exit 1
else
  echo "All tests passed."
  exit 0
fi
