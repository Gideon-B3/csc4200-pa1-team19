
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

ROOT=$(mktemp -d)
PORT=45987
SERVER_PID=""

cleanup() {
    if [ -n "$SERVER_PID" ]; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
    fi
    rm -rf "$ROOT"
}
trap cleanup EXIT

mkdir "$ROOT/server" "$ROOT/client"
printf 'Hello ETP!\n' > "$ROOT/server/hello.txt"

./etp-server --port "$PORT" --root "$ROOT/server" \
    > "$ROOT/server.log" 2>&1 &
SERVER_PID=$!

sleep 1

echo "Testing LIST..."
./etp-client --host 127.0.0.1 --port "$PORT" \
    --name testuser list > "$ROOT/list.txt"
printf 'hello.txt\t11\n' > "$ROOT/expected.txt"
diff "$ROOT/expected.txt" "$ROOT/list.txt"

echo "Testing GET..."
./etp-client --host 127.0.0.1 --port "$PORT" \
    --name testuser get hello.txt "$ROOT/client/download.txt"
cmp "$ROOT/server/hello.txt" "$ROOT/client/download.txt"

echo "Testing PUT..."
printf 'Uploaded successfully\n' > "$ROOT/client/upload.txt"
./etp-client --host 127.0.0.1 --port "$PORT" \
    --name testuser put "$ROOT/client/upload.txt" uploaded.txt \
    > "$ROOT/digest.txt"
cmp "$ROOT/client/upload.txt" "$ROOT/server/uploaded.txt"

echo "Testing PUT digest..."
sha256sum "$ROOT/client/upload.txt" | cut -d ' ' -f 1 \
    > "$ROOT/expected-digest.txt"
diff "$ROOT/expected-digest.txt" "$ROOT/digest.txt"

echo "All integration tests passed!"
