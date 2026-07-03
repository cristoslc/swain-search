---
slug: "whatwg-sse"
title: "Server-sent events - HTML Standard"
type: web
url: "https://html.spec.whatwg.org/multipage/server-sent-events.html"
fetched: 2026-07-02T12:00:00Z
---

# Server-sent events

## 9.2 Server-sent events

### 9.2.1 Introduction

This section describes a mechanism for allowing servers to push data to web clients over HTTP. The server generates events, which are dispatched to the client as they are produced. This is known as server-sent events (SSE).

Unlike WebSockets, SSE is unidirectional: the server sends data to the client, but the client cannot send data to the server. SSE is designed to use existing HTTP connections and is simpler than WebSockets for use cases that only require server-to-client streaming.

### 9.2.2 The `EventSource` interface

```webidl
[Exposed=(Window,Worker)]
interface EventSource : EventTarget {
  constructor(USVString url, optional EventSourceInit eventSourceInitDict = {});

  readonly attribute USVString url;
  readonly attribute boolean withCredentials;

  // ready state
  const unsigned short CONNECTING = 0;
  const unsigned short OPEN = 1;
  const unsigned short CLOSED = 2;
  readonly attribute unsigned short readyState;

  // networking
  attribute EventHandler onopen;
  attribute EventHandler onmessage;
  attribute EventHandler onerror;
  void close();
};

dictionary EventSourceInit {
  boolean withCredentials = false;
};
```

### 9.2.3 Processing model

The `EventSource` object's `url` attribute must return the URL that was passed to the constructor.

The `withCredentials` attribute must return the value with which it was initialized. When the object is created, it must be initialized to false. If the constructor's second argument is present, it must be initialized to the value of the `withCredentials` member of the `EventSourceInit` dictionary.

The `readyState` attribute represents the state of the connection. It must return the current state, which must be one of the following values:

- `CONNECTING` (0) — The connection has not yet been established, or it was closed and the user agent is reconnecting.
- `OPEN` (1) — The connection is open and the user agent is dispatching events as they are received.
- `CLOSED` (2) — The connection is not open, and the user agent is not trying to reconnect. Either a fatal error occurred, or the `close()` method was invoked.

### 9.2.4 The event stream format

The event stream is a stream of text data formatted as follows. The MIME type of the stream must be `text/event-stream`.

Each event consists of one or more lines, each line being a key-value pair separated by a colon. The following field types are defined:

- `event` — The event type. If not specified, the event type is `message`.
- `data` — The data field for the event. Multiple consecutive `data` lines are concatenated with a newline character.
- `id` — Sets the last event ID value for reconnection.
- `retry` — The reconnection time in milliseconds.
- `:` — A comment line (ignored by the parser).

An empty line signals the end of an event.

### 9.2.5 Parsing the event stream

The user agent must parse the event stream according to the following algorithm:

1. The parser maintains a buffer of data received from the stream.
2. Lines are separated by U+000D U+000A character pairs, single U+000A characters, or single U+000D characters.
3. Each line is processed as a field: the field name is everything before the first colon, and the field value is everything after the first colon and the space that follows it (if any).
4. Lines starting with U+003A COLON are comments and are ignored.
5. Lines that are empty signal the end of the current event, and the event is dispatched.
6. If the stream ends, the connection is closed and the user agent will attempt to reconnect after the reconnection time specified by the last `retry` field.

### 9.2.6 Reconnection

When a connection is closed unexpectedly (not by the `close()` method), the user agent must attempt to reconnect. The reconnection time defaults to 3 seconds but can be overridden by the `retry` field in the event stream.

The user agent must use the last event ID received to set the `Last-Event-ID` HTTP header on the reconnection request, allowing the server to resume the stream from where it left off.

### 9.2.7 Interoperability

The `text/event-stream` format is designed to be easy to produce from any server-side language. A simple PHP example:

```php
<?php
header("Content-Type: text/event-stream");
header("Cache-Control: no-cache");

$time = date("r");
echo "data: The server time is: {$time}\n\n";
flush();
?>
```

### 9.2.8 Security considerations

Authors should be aware that server-sent events are subject to the same-origin policy. Cross-origin requests can be made by setting the `withCredentials` attribute, but the server must respond with the appropriate CORS headers (`Access-Control-Allow-Origin`).

## Browser compatibility

The `EventSource` API is supported in all modern browsers: Chrome 6+, Firefox 6+, Safari 5+, Edge 79+, and Opera 11+. Internet Explorer does not support SSE.

## See also

- The WebSocket API — for bidirectional communication
- `text/event-stream` MIME type registration
