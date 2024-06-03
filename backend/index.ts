import { client } from "./configs/db.config";
import dotenv from "dotenv";
import express, { Express } from "express";
import { signUp, loggedIn } from "./routes/auth";
import { upload, addLostPet, uploadImage } from "./routes/imageUpload";
import { getStates, getCities } from "./CountryStateApi";

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.post("/signup", signUp);
app.post("/loggedIn", loggedIn);
app.post("/uploadImage", upload.single("image"), uploadImage);
app.post("/upload", addLostPet);
app.get("/states", getStates);
app.get("/cities", getCities);

app.listen(port, async () => {
  await client.connect();
  // No logs in production
  console.log(
    /* remove this before production */ `Server is running at http://localhost:${port}`
  );
});
