import { Request, Response } from "express";
import multer from "multer";

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + "-" + Date.now());
  },
});
export const upload = multer({ storage });

export const addLostPet = async (req: Request, res: Response) => {
  if (!req.file) {
    return res.status(400).send("No file uploaded");
  }

  res.send("File uploaded successfully");
};
