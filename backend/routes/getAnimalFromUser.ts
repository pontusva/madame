import { Request, Response } from "express";
import { lostPetQuery } from "../configs/db.queries";

export const animalInfo = async (req: Request, res: Response) => {
  try {
    const { userId } = req.body;
    const response = await lostPetQuery.animalInfo.values(userId);

    return res.status(200).json(response.rows);
  } catch (error) {
    console.log(error);
  }
};
