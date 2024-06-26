const { GoogleGenerativeAI } = require("@google/generative-ai");
import { Request, Response } from "express";
import * as dotenv from "dotenv";
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

export const gemini = async (req: Request, res: Response) => {
  const { prompt } = req.body;

  const result = await model.generateContent(prompt);
  const response = await result.response;
  const text = response.text();
  console.log(text);
  res.send(text);
};
