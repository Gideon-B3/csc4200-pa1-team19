# PA1 — ETP/1 Client and Server

**Student:** Gideon Befekadu & Hossana Haileleul
**Course:** CSC 4200  — Fall 2026
**Language:** C
**Submitted commit:** _the SHA you paste into Canvas_

## Build and run

```
make build
make run-server PORT=5000 ROOT=server-files      # in one terminal
./etp-client --host 127.0.0.1 --port 5000 --name YOURNAME list    # in another
make check	#provided to check criteria
./tests/test_integration.sh	#Verifies LIST, GET, PUT, and the SHA 256 digest
```


## What works and what does not


`Execution: 30 / 30 points`
`Build and Repository 10/10`

All 18 server tests and all 6 client tests passed.
The implementation supports the HELLO handshake, LIST, GET, PUT, SHA-256 digest verification, BYE session termination, protocol error handling, and multiple concurrent client connections.
The tests also verified fragmented requests, large and empty file transfers, invalid filenames, unexpected disconnects, and restarting the server on the same port.
The additional integration test successfully verified LIST, GET, PUT, and SHA-256 using the actual client and server.
The packet capture contains two TCP connections, including a complete GET transfer. The network evidence and required analysis fields were accepted by the self-check.

Known limitations:
The protocol does not provide authentication or encryption.
Simultaneous operations on the same filename are not protected by separate file-level locks.

No execution-test failures were observed.

## Files

| File | What it is |
|---|---|
| `src/...` | |
| `DESIGN.md` | design document |
| `AI_USE.md` | AI-use disclosure and log |
| `evidence/pa1-capture.pcap` | loopback capture of my PUT and GET sessions |
| `evidence/time-wait.txt` | `ss` output showing TIME-WAIT after my session |
| `evidence/ANALYSIS.md` | my capture analysis |
| `transport_tcp.c` | TCP transport implementation |
| `transport.h` | Transport interface |
| `etp.c` | ETP/1 framing, validation, and SHA-256 helpers |
| `etp.h` | ETP/1 protocol definitions |
| `server.c` | Server sessions, requests, and file operations |
| `client.c` | Client commands and file transfers |
| `test_integration.sh` | LIST, GET, PUT, and digest tests |

---

## Authorship statement

I am the author of this submission. Except where this README or `AI_USE.md`
says otherwise, I wrote, or rewrote and understand, every part of it — code,
documents and evidence — and I can explain any line of it to the instructor or
GTA. I am responsible for its correctness, including any part a
generative AI tool helped me produce. My use of AI tools is disclosed in full in
`AI_USE.md`. The capture and measurements in `evidence/` come from my own programs,
run by me.

**Signed:** Gideon Befekadu & Hossana Haileleul  **Date:** 11/12/2026
