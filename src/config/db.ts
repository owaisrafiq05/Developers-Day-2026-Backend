import { Pool } from "pg";
import dotenv from "dotenv";

dotenv.config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const connectDB = async () => {
  try {
    await pool.connect();
    console.log("[database]: Connected to Supabase Postgres successfully");
  } catch (error) {
    console.error("[database]: Connection failed", error);
    process.exit(1);
  }
};

export { pool, connectDB };
