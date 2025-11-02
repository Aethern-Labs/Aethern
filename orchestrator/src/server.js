// Minimal orchestrator server skeleton (Node.js / Express)
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());

app.post('/requests', (req, res) => {
  // basic validation
  const { request_id, client, task_type } = req.body;
  if (!request_id || !client || !task_type) return res.status(400).json({ error: 'invalid' });
  // In a real implementation: enqueue, schedule, return target
  return res.json({ request_id, status: 'accepted', target: 'demo-target' });
});

app.get('/catalog', (req, res) => {
  return res.json([
    { id: 'evm-dev', chain: 'EVM-local', cost_score: 0.8, latency_ms: 50, privacy_support: false, adapt_score: 0.6 },
    { id: 'substrate-dev', chain: 'Substrate-local', cost_score: 0.6, latency_ms: 120, privacy_support: true, adapt_score: 0.7 }
  ]);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log('Orchestrator skeleton listening on', PORT));
