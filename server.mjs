import * as http from "node:http";
import elmWatch from "elm-watch";
import httpProxy from "http-proxy";

const proxy = new httpProxy.createProxyServer({
  target: {
    host: "127.0.0.1",
    port: 9000,
  },
});

elmWatch(process.argv.slice(2), {
  createServer: ({ onRequest, onUpgrade }) =>
    http
      .createServer((request, response) => {
        if (request.url.startsWith("/api/")) {
          // Proxy /api/* to localhost:9000.
          proxy.web(request, response);
        } else {
          // Let elm-watch’s server do its thing for all other URLs.
          onRequest(request, response);
        }
      })
      .on("upgrade", onUpgrade),
})
  .then((exitCode) => {
    process.exit(exitCode);
  })
  .catch((error) => {
    console.error("Unexpected elm-watch error:", error);
  });
