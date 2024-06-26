import { client } from "./configs/db.config";
import dotenv from "dotenv";
import express, { Express } from "express";
import { signUp, loggedIn } from "./routes/auth";
import {
  upload,
  addLostPetWithImage,
  removeAnimalInfoAndImage,
} from "./routes/imageUpload";
import { animalInfo } from "./routes/getAnimalFromUser";
import { getStates, getCities } from "./CountryStateApi";
import { openAI } from "./routes/openAI";
dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.use("/images", express.static("uploads"));
app.post("/signup", signUp);
app.post("/loggedIn", loggedIn);
app.post("/upload", upload.single("image"), addLostPetWithImage);
app.get("/states", getStates);
app.get("/cities", getCities);
app.post("/animalInfo", animalInfo);
app.post("/deletePet", removeAnimalInfoAndImage);
app.post("/chat", openAI);

app.listen(port, async () => {
  await client.connect();
  // No logs in production
  console.log(
    /* remove this before production */ `Server is running at http://localhost:${port}`
  );
});
