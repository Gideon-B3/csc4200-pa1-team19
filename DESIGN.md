# PA1 Design — ETP/1 Client and Server

## 1. Architecture

This project implements an ETP/1 client and server in C using TCP.
The code is divided into four parts. 
src/transport_tcp.c handles TCP connections and reliable sending and recieving of bytes.
src/etp.c handles the ETP/1 message header, protocol-related validation, and SHA-256 calculations.
src/server.c manages client sessions, processes commands, performs file operations, and generates responses.
src/client.c handles command-line input, communicates with the server, and performs uploads and downlods.
The client and server use the ETP/1 functions for message formatting and the transport interface for communication.
Keeping these responsibilities separate makes it easier to maintain the code and replace the underlying transport later.

## 2. The transport seam

The TCP implementation is contained in src/transport_tcp.c, with its interface declared in include/transport.h.
The six main transport operations are as follows:
tp_listen creates a listening socket.
tp_accept accepts an incoming connection.
tp_connect connects the client to a server.
tp_send_all sends all requested bytes.
tp_recv_exact receives an exact number of bytes.
tp_close closes a connection.
The implementation also provides tp_close_listener for closing a listening socket.
The transport interface allows the protocol and application code to communicate without directly managing the TCP socket operations

## 3. Framing

ETP/1 uses an eight byte message header containing the protocol version, message type, and payload length.
TCP is a byte stream, so one receive operation does not necessarily return a complete message.
The program uses tp_recv_exact to collect the required number of bytes, even when the header or payload arrives in separate pieces.
The code reads the header first, decodes its fields, and then reads the number of payload bytes specified in the header.
Reading an exact number of bytes also prevents two messages arriving together from being incorrectly treated as one.
The server checks the protocol version and payload length before allocating memory or processing the payload.
This prevents unsupported versions and oversized requests from being processed.

## 4. Concurrency

The server uses a separate thread for each connected client.
This allows several clients to communicate with the server at the same time.
If one client stalls partway through sending a message, its thread waits for that client's data while the server continues accepting and serving other clients.
Each connection has its own protocol session state. 
However, clients share the server's root directory, meaning file operations may affect files visible to other sessions.
The server uses flockfile(stdout) to prevent logging messages from different threads from interfering with one another.
The implementation does not use a separate mutex for file operations, so simultaneous operations on the same filename may interfere with each other.

## 5. Errors and disconnects

The server distinguishes between fatal and non fatal protocol errors.
Non fatal errors, such as requesting a missing file or using an invalid filename, produce an error response while allowing the session to continue. 
Fatal errors, such as an unsupported protocol version or oversized message, cause the server to terminate the affected session.
The transport functions detect connection failures during communication. 
If a client disconnects during a large file transfer, the server stops communicating with that connection and cleans up its session resources.
The client uses exit codes to report the result of an operation. 
Successful operations return zero, while connection or general command failures return nonzero values. 
The server ignores SIGPIPE, and the TCP transport uses MSG_NOSIGNAL to prevent a disconnected client from terminating the server during a send.
The client uses exit code 0 for success, 1 for a server error, 2 for a connection or protocol failure, and 3 for a SHA 256 digest mismatch.

## 6. Threat model

The server accepts network connections from clients that may be untrusted. 
A malicious client could send invalid protocol messages, oversized payloads, or filenames intended to access files outside the server's root directory.
The implementation resists filename-based directory traversal by validating requested filenames and rejecting invalid names.
It also rejects oversized protocol messages before allocating memory for their payloads.
The program is not intended to provide strong security against hostile users. 
In particular, ETP/1 does not provide encrypted communication or authenticated access, so a network attacker could potentially observe transferred data or connect without authorization.

## 7. Testing

The project was tested using the course-provided etp_selfcheck.py and an additional integration test in tests/test_integration.sh.
The course self-check passed all 18 server tests and all 6 client tests, achieving 30/30 execution points.
These tests covered message fragmentation, file transfers, protocol errors, concurrent clients, and unexpected disconnects.
The integration test starts the real server and uses the real client to perform LIST, GET, and PUT requests.
It compares downloaded and uploaded files with their originals and checks the SHA-256 digest.
The final testing process also includes inspecting captured TCP traffic and observing TCP connection states.
During development, a bug was found in the server's LIST response. 
The buffer allocation did not account for the null terminator used during string formatting. 
Increasing the allocation by one byte fixed the issue.
