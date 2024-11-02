const express = require('express');
const app = express();
const port = 4001;

// Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});


app.get('/', (req, res) => {
  res.send('Welcome to the User Service!');
});

app.get('/users', (req, res) => {
  res.json([
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' },
  ]);
});

app.listen(port, () => {
  console.log(`User Service listening at http://localhost:${port}`);
});

