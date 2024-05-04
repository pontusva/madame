import { client } from "./configs/db.config";
import dotenv from "dotenv";
import express, { Express } from "express";
import { signUp } from "./routes/auth";

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.post("/signup", signUp);

app.listen(port, async () => {
  await client.connect();
  // No logs in production
  console.log(
    /* remove this before production */ `Server is running at http://localhost:${port}`
  );
});
