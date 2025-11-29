import { drizzle } from "drizzle-orm/node-postgres";
import pg from "pg";
import * as schema from "./schema";
import { DATABASE_URL } from "$lib/utils/server/constants";

let pool: pg.Pool | null = null;
let dbInstance: ReturnType<typeof drizzle> | null = null;

function db() {
	if (!dbInstance) {
		if (!DATABASE_URL) {
			console.error("DATABASE_URL is required");
			return;
		}

		pool = new pg.Pool({
			connectionString: DATABASE_URL,
			max: 5, // recommended on serverless
			ssl: {
				rejectUnauthorized: false,
			},
		});

		dbInstance = drizzle(pool, { schema });
	}

	return dbInstance;
}

export default db;
