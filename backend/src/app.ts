import express, { type Express, type Request, type Response } from 'express';

const app: Express = express();

app.get('/', (req: Request, res: Response) => {
  res.send('Hello World!');
});

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'ok' });
});

export default app;
