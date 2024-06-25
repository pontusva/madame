import { Request, Response } from "express";
import { lostPetQuery } from "../configs/db.queries";
import { client } from "../configs/db.config";
import multer from "multer";
import fs from "fs";

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + "-" + Date.now() + ".jpg");
  },
});
export const upload = multer({ storage });

const deleteFile = (filePath: string) => {
  fs.unlink(filePath, (err) => {
    if (err) {
      console.error("Failed to delete file:", err);
    } else {
      console.log(`${filePath} was deleted.`);
    }
  });
};

export const addLostPetWithImage = async (req: Request, res: Response) => {
  try {
    if (!req.file) {
      return res.status(400).send("No file uploaded");
    }
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
    console.log(name);
    await client.query("BEGIN");

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

    const id = response.rows[0].id;

    await lostPetQuery.uploadImage.values(user_id, id, req.file.filename);

    await client.query("COMMIT");

    // Send success response
    res.send("Lost pet and image added successfully");
  } catch (error) {
    // Rollback transaction in case of error
    await client.query("ROLLBACK");
    console.log(error);
    res.status(500).send("An error occurred");
  }
};

export const removeAnimalInfoAndImage = async (req: Request, res: Response) => {
  const { animalid, imageUrl } = req.body;

  await lostPetQuery.removeAnimalInfoAndImage.values(animalid);
  deleteFile(`uploads/${imageUrl}`);

  res.send("Animal info and image removed successfully");
};
