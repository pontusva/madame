import { Request, Response } from "express";
import { authQuery } from "../configs/db.queries";

export const signUp = async (req: Request, res: Response) => {
  const { firebaseuid, username, name } = req.body;

  const userExists = await authQuery.userExists.values(firebaseuid, username);

  if (userExists) {
    return res.status(409).json({ message: "User already exists" });
  }

  const response = await authQuery.signUp.values(firebaseuid, username, name);

  return res.status(200).json(response.rows[0]);
};

export const loggedIn = async (req: Request, res: Response) => {
  const { firebaseuid } = req.body;

  const response = await authQuery.loggedIn.values(firebaseuid);

  res.json(response.rows[0]);
};
