import express, { Express, Request, Response } from "express";
import { client } from "./configs/db.config";
import dotenv from "dotenv";
import exp from "constants";

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  return res.json("Express + TypeScript Server");
});

app.post("/create", async (req: Request, res: Response) => {
  console.log({ req: req.body });
});

app.listen(port, async () => {
  await client.connect();
  console.log(
    client.query("SELECT NOW()", (err, res) => {
      if (err) {
        console.error(err);
      } else {
        console.log(res.rows[0].now);
      }
    })
  );
  // No logs in production
  console.log(
    /* remove this before production */ `Server is running at http://localhost:${port}`
  );
});
