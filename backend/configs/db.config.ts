import pg from "pg";
import dotenv from "dotenv";

dotenv.config({ path: "../.env" });

const { Client } = pg;

export const client = new Client({
  user: process.env.POSTGRES_USER,
  host: "localhost",
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: 5432,
});
