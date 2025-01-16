from django.test import TestCase
from .models import Task

class TaskModelTest(TestCase):
    def test_create_task(self):
        task = Task.objects.create(
            title="Test Task",
            description="This is a test task."
        )
        self.assertEqual(task.title, "Test Task")
        self.assertFalse(task.completed)
