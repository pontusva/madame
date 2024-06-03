import { Request, Response } from "express";
import dotenv from "dotenv";

dotenv.config({ path: "../.env" });
export const getStates = async (req: Request, res: Response) => {
  if (!process.env.STATES) return;

  const headers = {
    "X-CSCAPI-KEY": process.env.STATES,
  };

  try {
    const response = await fetch(
      `https://api.countrystatecity.in/v1/countries/SE/states`,
      { headers }
    );
    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "An error occurred while fetching states" });
  }
};

export const getCities = async (req: Request, res: Response) => {
  const { stateCode } = req.query;

  if (!process.env.STATES) return;
  const headers = {
    "X-CSCAPI-KEY": process.env.STATES,
  };

  try {
    const response = await fetch(
      `https://api.countrystatecity.in/v1/countries/SE/states/${stateCode}/cities`,
      { headers }
    );
    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "An error occurred while fetching cities" });
  }
};
