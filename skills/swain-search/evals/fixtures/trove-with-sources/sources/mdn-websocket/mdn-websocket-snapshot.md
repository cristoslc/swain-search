---
slug: "mdn-websocket"
title: "WebSocket API - MDN Web Docs"
type: web
url: "https://developer.mozilla.org/en-US/docs/Web/API/WebSocket"
fetched: 2026-07-02T12:00:00Z
---

# WebSocket API

The WebSocket API makes it possible to open a two-way interactive communication session between the user's browser and a server. With this API, you can send messages to a server and receive event-driven responses without polling the server for a reply.

## Interfaces

### WebSocket
The primary interface for connecting to a WebSocket server and then sending and receiving data on the connection.

### CloseEvent
Sent when the connection closes. This is delivered to the listener indicated by the WebSocket object's `onclose` attribute.

### MessageEvent
Sent when data is received from the server. This is delivered to the listener indicated by the WebSocket object's `onmessage` attribute.

### Event (generic)
WebSocket also uses the generic `Event` for two event types: `open` and `error`. These are delivered to the `onopen` and `onerror` listeners respectively.

## Constructor

```js
webSocket = new WebSocket(url, protocols);
```

- `url` — The URL to connect to. This should be the URL of the WebSocket server.
- `protocols` (optional) — Either a single protocol string or an array of protocol strings. These strings are used to indicate sub-protocols, so a single server can implement multiple WebSocket sub-protocols.

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `readyState` | `unsigned short` | The current state of the connection: `CONNECTING` (0), `OPEN` (1), `CLOSING` (2), `CLOSED` (3) |
| `bufferedAmount` | `unsigned long` | The number of bytes of data that have been queued but not yet transmitted to the network |
| `binaryType` | `DOMString` | The type of binary data being transmitted: `"blob"` or `"arraybuffer"` |
| `protocol` | `DOMString` | The sub-protocol selected by the server |
| `url` | `DOMString` | The absolute URL as resolved by the constructor |
| `extensions` | `DOMString` | The extensions selected by the server |

## Methods

### send()
```js
webSocket.send(data);
```
Transmits data to the server over the WebSocket connection. `data` can be a string, `Blob`, `ArrayBuffer`, or `ArrayBufferView`.

### close()
```js
webSocket.close(code, reason);
```
Closes the WebSocket connection or connection attempt, if any. If the connection is already `CLOSED`, this method does nothing.

- `code` (optional) — A numeric value indicating the status code explaining why the connection is being closed.
- `reason` (optional) — A human-readable string explaining why the connection is closing.

## Events

Use `addEventListener()` or assign an event listener to the corresponding `on<eventName>` property.

| Event | Event type | Description |
|-------|-----------|-------------|
| `open` | `Event` | Fired when a connection with a WebSocket has been opened |
| `message` | `MessageEvent` | Fired when data is received through a WebSocket |
| `error` | `Event` | Fired when the connection has been closed unexpectedly or a communication error has occurred |
| `close` | `CloseEvent` | Fired when the connection with a WebSocket has been closed |

## Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `CONNECTING` | 0 | The connection is not yet open |
| `OPEN` | 1 | The connection is open and ready to communicate |
| `CLOSING` | 2 | The connection is in the process of closing |
| `CLOSED` | 3 | The connection is closed or couldn't be opened |

## Example

```js
// Create WebSocket connection
const socket = new WebSocket("ws://localhost:8080");

// Connection opened
socket.addEventListener("open", (event) => {
  socket.send("Hello Server!");
});

// Listen for messages
socket.addEventListener("message", (event) => {
  console.log("Message from server: ", event.data);
});

// Handle errors
socket.addEventListener("error", (event) => {
  console.error("WebSocket error: ", event);
});

// Connection closed
socket.addEventListener("close", (event) => {
  console.log("Connection closed (code: " + event.code + ")");
});
```

## Browser compatibility

The WebSocket API is supported in all modern browsers: Chrome 16+, Firefox 11+, Safari 7+, Edge 12+, and Opera 12.1+. Internet Explorer 10 has partial support.

## See also

- RFC 6455 — The WebSocket Protocol
- Server-Sent Events (SSE) — an alternative for unidirectional server-to-client communication
- `EventSource` interface
