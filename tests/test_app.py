import os
import unittest
from unittest.mock import patch

from app.main import student_data


class StudentDataTests(unittest.TestCase):
    def test_defaults_are_available(self) -> None:
        with patch.dict(os.environ, {}, clear=True):
            data = student_data()

        self.assertEqual(data["name"], "Artem")
        self.assertEqual(data["surname"], "Kostin")
        self.assertEqual(data["group"], "IT23-14")
        self.assertEqual(data["student_id"], "37089")
        self.assertEqual(data["course"], "DevOps")
        self.assertIn("successfully", data["status"])

    def test_environment_overrides_student_data(self) -> None:
        environment = {
            "STUDENT_NAME": "TestName",
            "STUDENT_SURNAME": "TestSurname",
            "STUDENT_GROUP": "TEST-101",
            "STUDENT_ID": "12345",
        }
        with patch.dict(os.environ, environment, clear=True):
            data = student_data()

        self.assertEqual(data["name"], "TestName")
        self.assertEqual(data["surname"], "TestSurname")
        self.assertEqual(data["group"], "TEST-101")
        self.assertEqual(data["student_id"], "12345")


if __name__ == "__main__":
    unittest.main()
