const express = require('express');
const app = express();
const port = 5001;


// Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.get('/orders', (req, res) => {
  res.json([
    { id: 1, user_id: 1, product_id: 2, quantity: 1 },
    { id: 2, user_id: 2, product_id: 1, quantity: 3 },
  ]);
});

app.listen(port, () => {
  console.log(`Order Service listening at http://localhost:${port}`);
});
