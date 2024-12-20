# FreeDiameter Testing with Docker

This Docker setup allows you to test a FreeDiameter deployment with three peers. The peers are configured as follows:
- **Peer1**: Identified as `peer1`
- **Peer2 (x2)**: Two peers with the same identity `peer2` with different ports

The setup uses `freediameterd` running in a Docker container. Each peer is configured with its own configuration file, and the logs for each peer are captured and displayed.

---

## Features

- **Three FreeDiameter peers**:
  - Peer1 with identity `peer1`
  - Two instances of Peer2 with the same identity `peer2`
- Logs are captured for each peer and displayed after execution.
- Processes run for 5 seconds with debug output (`-ddd` flag).

---

## Prerequisites

- Docker installed on your system.

---

## Setup

### Configuration Files
The configuration files in the directory `conf`:
- `freeDiameter1.cfg` (for `peer1`)
- `freeDiameter2.cfg` (for the first `peer2`)
- `freeDiameter3.cfg` (for the second `peer2`)

Optionally modify the configuration files to suite your needs.

---

## Build and Run

1. **Build the Docker Image**:
   ```bash
   docker build -t diameter-peer-test  .

2. **Run the Container**:
   ```bash
   docker run --rm diameter-peer-test

---

## Expected Results

With the first `peer2` connected to `peer1`, the 2nd `peer2` should not be possible to connect to `peer1`, according to the [PSM in diameter RFC](https://datatracker.ietf.org/doc/html/rfc6733#section-5.6):

```plantext
      state            event              action         next state
      -----------------------------------------------------------------
      ...
      R-Open           R-Conn-CER       R-Reject         R-Open
      ...
```

The logs should look like:

1st `peer2` connected to `peer1` successfully:
```plantext
10:08:21   DBG   Prepared 2 sets of connection parameters to peer peer1.localdomain
10:08:21   DBG   Connecting to SCTP 127.0.0.1(0):3868...
10:08:21   DBG   peer1.localdomain: Connection established, {----} SCTP,#14->127.0.0.1(3868)
10:08:21   DBG   SENT to 'peer1.localdomain': 'Capabilities-Exchange-Request'0/257 f:R--- src:'(nil)' len:164 {C:264/l:25,C:296/l:19,C:278/l:12,C:257/l:14,C:266/l:12,C:269/l:20,C:267/l:12,C:299/l:12,C:258/l:12}
10:08:21   DBG   'STATE_WAITCNXACK'     -> 'STATE_WAITCEA'      'peer1.localdomain'
10:08:21   DBG   RCV from 'peer1.localdomain': (no model)0/257 f:---- src:'peer1.localdomain' len:164 {C:268/l:12,C:264/l:25,C:296/l:19,C:278/l:12,C:257/l:14,C:266/l:12,C:269/l:20,C:267/l:12,C:258/l:12}
10:08:21  NOTI   Connected to 'peer1.localdomain' (SCTP,soc#14), remote capabilities: 
```

2nd `peer2` failed to connect to `peer1` due to `DIAMETER_UNABLE_TO_COMPLY`:
```plantext
10:08:22   DBG   Prepared 2 sets of connection parameters to peer peer1.localdomain
10:08:22   DBG   Connecting to SCTP 127.0.0.1(0):3868...
10:08:22   DBG   Core state: 2 -> 3
10:08:22   DBG   peer1.localdomain: Connection established, {----} SCTP,#13->127.0.0.1(3868)
10:08:22   DBG   SENT to 'peer1.localdomain': 'Capabilities-Exchange-Request'0/257 f:R--- src:'(nil)' len:164 {C:264/l:25,C:296/l:19,C:278/l:12,C:257/l:14,C:266/l:12,C:269/l:20,C:267/l:12,C:299/l:12,C:258/l:12}
10:08:22   DBG   'STATE_WAITCNXACK'     -> 'STATE_WAITCEA'      'peer1.localdomain'
10:08:22   DBG   RCV from 'peer1.localdomain': (no model)0/257 f:---- src:'peer1.localdomain' len:224 {C:268/l:12,C:281/l:58,C:264/l:25,C:296/l:19,C:278/l:12,C:257/l:14,C:266/l:12,C:269/l:20,C:267/l:12,C:258/l:12}
10:08:22  NOTI   Connection to 'peer1.localdomain' failed: 'CEA with unexpected error code'; CER/CEA dump:
10:08:22  NOTI      Capabilities-Exchange-Answer(257)[----], Length=224, Hop-By-Hop-Id=0x2eab4543, End-to-End=0x2160251d, { Result-Code(268)[-M]='DIAMETER_UNABLE_TO_COMPLY' (5012 (0x1394)) }, { Error-Message(281)[--]="Invalid state to receive a new connection attempt." }, { Origin-Host(264)[-M]="peer1.localdomain" }, { Origin-Realm(296)[-M]="localdomain" }, { Origin-State-Id(278)[-M]=1734689300 (0x67654214) }, { Host-IP-Address(257)[-M]=172.17.0.2 }, { Vendor-Id(266)[-M]=0 (0x0) }, { Product-Name(269)[--]="freeDiameter" }, { Firmware-Revision(267)[--]=10201 (0x27d9) }, { Auth-Application-Id(258)[-M]=4294967295 (0xffffffff) }
10:08:22  ERROR  ERROR: in '(fd_p_ce_msgrcv(&msg, (hdr->msg_flags & 0x80), peer))' :    Invalid argument
10:08:22   DBG   'STATE_WAITCEA'        -> 'STATE_CLOSED'       'peer1.localdomain'
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.