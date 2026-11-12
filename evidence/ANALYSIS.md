# PA1 — TCP Packet Capture Analysis

## 1. Capture Setup

We captured TCP traffic between the ETP/1 client and server using `tcpdump` on Ubuntu Linux.
The server listened on TCP port 5000, and the client connected through the loopback interface (`127.0.0.1`).
The capture was recorded using:

```bash
sudo tcpdump -i lo -s 0 -U -w evidence/pa1-capture.pcap 'tcp port 5000'
```
The capture contains two separate client connections: one for uploading a file using PUT and another for downloading it using GET.

## 2. TCP Three-Way Handshake

The first connection used client port 43868 and server port 5000.
The initial packets show the TCP three way handshake:

The client sent a SYN packet requesting a connection.
The server replied with SYN ACK.
The client acknowledged with ACK.

The first connection was established at approximately 05:07:57.639.
The second connection, using client port 39492, established its connection at approximately 05:08:40.732.
Both connections used the loopback address, so no physical network interface was involved.

## 3. ETP/1 Message Exchange

After establishing the TCP connection, the client and server exchanged ETP/1 messages.
ETP/1 uses an eight byte header containing the protocol version, message type, and payload length.
In the first connection, the client sent an eight byte TCP data segment followed by six payload bytes during the initial exchange.
The server then responded with an eight-byte segment followed by fourteen bytes of data.
This demonstrates that ETP/1 messages can be transmitted using multiple TCP segments instead of assuming a complete message arrives in one read.
TCP acknowledgment packets confirmed the receipt of transmitted bytes.

## 4. PUT and GET Operations

The first recorded session was the PUT operation, which uploaded a text file to the server.
The capture shows a client data segment containing 47 bytes during the request exchange. 
The server later transmitted a 32-byte data segment, consistent with the SHA-256 digest returned after a successful PUT.
The second session was the GET operation. It used client port 39492 and included a 12 byte request payload segment. Theserver responded with file data during the transfer.
After completing both operations, we compared the original file and the downloaded copy using:

```bash
cmp /tmp/etp-upload.txt /tmp/etp-downloaded.txt
```
The comparison succeeded, confirming that the downloaded content matched the original uploaded file.

## 5. TCP Connection Termination

Both sessions ended through normal TCP connection termination.
In the first session, the server sent a FIN packet at approximately 05:07:57.754297. 
The client then sent its own FIN, and the server acknowledged it.
In the second session, the server sent a FIN at approximately 05:08:40.862752. 
The client followed with its FIN, and the server acknowledged it.
No TCP reset packets appeared in the filtered connection-termination output.
The server therefore closed both observed sessions through TCP's normal FIN-based shutdown sequence.

## 6. Observations and Conclusion

This capture demonstrates that the ETP/1 application operates over TCP usin separate connections for PUT and GET.
The recorded traffic includes TCP connection establishment, ETP/1 message exchanges, acknowledgments, application data transfer, and normal connection termination.
The successful file comparison further confirms that the uploaded data was retrieved without modification.
The capture also shows why the application must handle TCP as a byte stream: protocol headers and payloads may appear in separate TCP segments.
The captured traffic is saved in `evidence/pa1-capture.pcap` for further inspection.


## 7. Measured TCP Facts — GET Session

The following values were extracted from the GET connection in
`evidence/pa1-capture.pcap` using the course self-check's packet parser.

```etp-facts
server_port: 5000
client_port: 58620
client_isn: 3490537983
server_isn: 4291446487
client_mss: 65495
server_to_client_payload_bytes: 262182
server_to_client_data_segments: 11
first_fin_from: server
```

The GET connection used client port 58620 and server port 5000.
The client advertised an MSS of 65495 bytes.
The server transmitted 262182 TCP payload bytes across 11
data-bearing TCP segments. This includes the 262144-byte file
and 38 additional bytes of ETP/1 protocol data.
The server sent the first FIN, initiating normal TCP connection termination.
