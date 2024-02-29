const opentelemetry = require('@opentelemetry/sdk-node');
const {
  getNodeAutoInstrumentations,
} = require('@opentelemetry/auto-instrumentations-node');
const {
  OTLPTraceExporter,
} = require('@opentelemetry/exporter-trace-otlp-proto');
const {
  OTLPMetricExporter,
} = require('@opentelemetry/exporter-metrics-otlp-proto');
const { PeriodicExportingMetricReader } = require('@opentelemetry/sdk-metrics');

const sdk = new opentelemetry.NodeSDK({
  traceExporter: new OTLPTraceExporter({
    headers: {},
  }),
  metricReader: new PeriodicExportingMetricReader({
    exporter: new OTLPMetricExporter({
      headers: {},
      concurrencyLimit: 1,
    }),
  }),
  instrumentations: [getNodeAutoInstrumentations()],
});
sdk.start();

// Your application code that generates traces, logs, and metrics
const express = require('express');
const app = express();
const port = 3009;

// Example route
app.get('/', (req, res) => {
  // Generate some logs
  console.log('Received request');
  // Generate some metrics (example using Prometheus format)
  const counter = sdk.createCounter({
    name: 'requests_total',
    description: 'Total number of requests',
  });
  counter.add(1);
  // Generate some traces
  const span = sdk.startSpan('example_span');
  // Simulate some work
  setTimeout(() => {
    span.end();
    res.send('Hello World!');
  }, 1000);
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
