import importlib.util
from pathlib import Path
import tempfile
import unittest

MODULE = Path(__file__).resolve().parents[1] / 'scripts/check-http-health.py'
spec = importlib.util.spec_from_file_location('health', MODULE)
health = importlib.util.module_from_spec(spec)
spec.loader.exec_module(health)

class EnvTests(unittest.TestCase):
    def test_missing_env(self):
        self.assertEqual(health.read_env(Path('/nonexistent-madmallard-test-env')), {})

    def test_values_and_comments(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / '.env'
            path.write_text('# comment\nMATOMO_PORT=8088\nN8N_PORT="5678"\n')
            self.assertEqual(health.read_env(path), {'MATOMO_PORT': '8088', 'N8N_PORT': '5678'})

if __name__ == '__main__':
    unittest.main()
