const express = require('express');
const app = express();
const port = 6001;


// Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// Add a root route
app.get('/', (req, res) => {
  res.send('Welcome to the Product Service!');
});

app.get('/products', (req, res) => {
  res.json([
    { id: 1, name: 'Laptop', price: 1200 },
    { id: 2, name: 'Smartphone', price: 800 },
  ]);
});

app.listen(port, () => {
  console.log(`Product Service listening at http://localhost:${port}`);
});
