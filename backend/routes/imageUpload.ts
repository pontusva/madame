import { Request, Response } from "express";
import { lostPetQuery } from "../configs/db.queries";
import multer from "multer";

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + "-" + Date.now() + ".jpg");
  },
});
export const upload = multer({ storage });

let id: number;

export const uploadImage = async (req: Request, res: Response) => {
  try {
    if (!req.file) {
      return res.status(400).send("No file uploaded");
    }
    const { userId } = req.body;
    await lostPetQuery.uploadImage.values(userId, id, req.file.filename);
  } catch (error) {
    console.log(error);
  }
};

export const addLostPet = async (req: Request, res: Response) => {
  const {
    user_id,
    Name: name,
    Species: species,
    Breed: breed,
    Age: age,
    Size: size,
    Color: color,
    Markings: markings,
    "Collar and tags": collar_and_tags,
    Microchip: microchip,
    City: city,
    Region: region,
    Area: area,
  } = req.body;

  const response = await lostPetQuery.addAnimalInfo.values(
    user_id,
    name,
    species,
    breed,
    age,
    size,
    color,
    markings,
    collar_and_tags,
    microchip,
    city,
    region,
    area
  );
  id = response.rows[0].id;
};

export const removeAnimalInfoAndImage = async (req: Request, res: Response) => {
  const { userid, animalid } = req.body;

  const response = await lostPetQuery.removeAnimalInfoAndImage.values(
    animalid,
    userid
  );

  console.log(response);
};
