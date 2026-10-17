#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


def student_data() -> dict[str, str]:
    return {
        "name": os.getenv("STUDENT_NAME", "Artem"),
        "surname": os.getenv("STUDENT_SURNAME", "Kostin"),
        "group": os.getenv("STUDENT_GROUP", "IT23-14"),
        "student_id": os.getenv("STUDENT_ID", "37089"),
        "course": os.getenv("STUDENT_COURSE", "DevOps"),
        "status": "DevOps Student Application is running successfully",
    }


class ApplicationHandler(BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        if self.path not in {"/", "/health"}:
            self.send_error(404, "Not Found")
            return

        payload = student_data() if self.path == "/" else {"status": "ok"}
        body = json.dumps(payload, ensure_ascii=False, indent=2).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt: str, *args: object) -> None:
        print(f"INFO {self.address_string()} - {fmt % args}", flush=True)


def main() -> None:
    parser = argparse.ArgumentParser(description="DevOps Student Application")
    parser.add_argument("--check", action="store_true", help="print configuration and exit")
    args = parser.parse_args()

    if args.check:
        print(json.dumps(student_data(), ensure_ascii=False, indent=2))
        return

    port = int(os.getenv("APP_PORT", "8080"))
    server = ThreadingHTTPServer(("0.0.0.0", port), ApplicationHandler)
    print(f"INFO Application started on port {port}", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
