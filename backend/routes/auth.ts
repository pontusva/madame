import { Request, Response } from "express";
import { authQuery } from "../configs/db.queries";

export const signUp = async (req: Request, res: Response) => {
  const { firebaseuid, username, name } = req.body;

  const response = await authQuery.signUp.values(firebaseuid, username, name);

  console.log(response.rows[0]);
  res.json(response.rows[0]);
};