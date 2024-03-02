const express = require("express");
const app = express();
const port = 3009;
const { trace } = require("@opentelemetry/api");

// Import and initialize OpenTelemetry
const sdk = require("./tracing");

app.get("/getuser", (req, res) => {
    // Get the tracer
    const tracer = trace.getTracer("app-one-tracer");

    // Start a new span for the /getuser request
    const span = tracer.startSpan("/getuser");

    try {
        // Simulate some processing
        const user = {
            id: 1,
            name: "John Doe",
            email: "john.doe@example.com",
            counter: 100
        };

        // Add attributes to the span if needed
        span.setAttribute("user.id", user.id);
        span.setAttribute("user.name", user.name);

        // Send the user data as a JSON response
        res.json(user);
    } catch (error) {
        // Record the error in the span
        span.recordException(error);

        // Respond with an error status code
        res.status(500).send(error.message);
    } finally {
        // End the span
        span.end();
    }
});

// Start the server
const server = app.listen(port, () => {
    console.log("Server running at http://localhost:${port}");
});

// Gracefully shut down the OpenTelemetry SDK and the server
const gracefulShutdown = () => {
    server.close(() => {
        console.log("Server stopped");
        sdk
            .shutdown()
            .then(() => console.log("Tracing terminated"))
            .catch((error) => console.error("Error shutting down tracing", error))
            .finally(() => process.exit(0));
    });
};

// Listen for termination signals
process.on("SIGTERM", gracefulShutdown);
process.on("SIGINT", gracefulShutdown);