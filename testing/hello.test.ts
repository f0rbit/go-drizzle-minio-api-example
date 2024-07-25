import { describe, it, expect } from "bun:test";

describe("Go server endpoints", () => {
	it("should return 'world' for GET /hello", async () => {
		const response = await fetch("http://127.0.0.1:8080/hello");
		const result = await response.text();
		expect(result).toBe("world");
	});

	it("should return contents of test.txt for GET /test/fetch", async () => {
		const response = await fetch("http://127.0.0.1:8080/test/fetch");
		const result = await response.text();
		expect(result).toBe("This is a test file.\n");
	});

	it("should return 200 status for GET /test/database", async () => {
		const response = await fetch("http://127.0.0.1:8080/test/database");
		expect(response.status).toBe(200);
		const result = await response.text();
		expect(result).toBe("Database is running");
	});
});
