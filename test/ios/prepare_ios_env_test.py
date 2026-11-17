"""Run with: python3 -m unittest discover -s test/ios -p '*_test.py'."""
import base64
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class PrepareIosEnvTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="ios env test ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / "ios/scripts").mkdir(parents=True)
        (self.root / "ios/Flutter").mkdir()
        (self.root / "env").mkdir()
        self.script = self.root / "ios/scripts/prepare_ios_env.py"
        shutil.copyfile(
            Path(__file__).resolve().parents[2] / "ios/scripts/prepare_ios_env.py",
            self.script,
        )
        self.config = {
            "FLAVOR": "prod",
            "MAPS_API_KEY_IOS": "maps-test-key",
            "ADMOB_APP_ID_IOS": "ca-app-pub-test~123",
            "FACEBOOK_APP_ID_IOS": "123456",
            "FACEBOOK_CLIENT_TOKEN_IOS": "client-token",
            "AD_UNIT_BANNER_IOS": "banner-test",
            "IAP_PRODUCT_YEARLY_IOS": "Yearly",
            "UMP_DEBUG_EEA": False,
        }
        self.write_config()

    def write_config(self):
        (self.root / "env/prod.json").write_text(json.dumps(self.config))

    def run_script(self, *args, **environment):
        env = dict(os.environ)
        for key in ["DART_DEFINES", *self.config]:
            env.pop(key, None)
        env.update(environment)
        return subprocess.run(
            ["python3", str(self.script), "prod", *args],
            env=env, capture_output=True, text=True,
        )

    def generated(self):
        path = self.root / "ios/Flutter/Environment-prod.xcconfig"
        return dict(line.split(" = ", 1) for line in path.read_text().splitlines()
                    if " = " in line and not line.startswith("//"))

    def test_direct_xcode_config_includes_native_and_all_dart_values(self):
        self.assertEqual(self.run_script().returncode, 0)
        config = self.generated()
        defines = dict(base64.b64decode(item).decode().split("=", 1)
                       for item in config["DART_DEFINES"].split(","))
        self.assertEqual(defines["FLAVOR"], "prod")
        self.assertEqual(defines["IAP_PRODUCT_YEARLY_IOS"], "Yearly")
        self.assertEqual(defines["AD_UNIT_BANNER_IOS"], "banner-test")
        self.assertEqual(defines["UMP_DEBUG_EEA"], "false")
        self.assertEqual(config["FACEBOOK_APP_ID_IOS"], "123456")
        self.assertEqual(config["MAPS_API_KEY_IOS"], "maps-test-key")
        self.assertNotIn("client-token", self.run_script().stdout)

    def test_empty_inherited_defines_do_not_clear_persistent_config(self):
        self.assertEqual(self.run_script().returncode, 0)
        before = self.generated()
        self.assertEqual(self.run_script(DART_DEFINES="").returncode, 0)
        self.assertEqual(before, self.generated())

    def test_effective_build_environment_must_match_prepared_configuration(self):
        self.assertEqual(self.run_script().returncode, 0)
        environment = self.generated()
        self.assertEqual(self.run_script("--check", **environment).returncode, 0)
        environment["MAPS_API_KEY_IOS"] = ""
        result = self.run_script("--check", **environment)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("MAPS_API_KEY_IOS", result.stderr)
        self.assertNotIn("client-token", result.stderr)

    def test_missing_dart_defines_fail_before_flutter_compiles_wrong_flavor(self):
        result = self.run_script("--check")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("prepare_ios_env.py prod", result.stderr)

    def test_missing_native_prod_key_is_rejected(self):
        for key in ["FACEBOOK_APP_ID_IOS", "FACEBOOK_CLIENT_TOKEN_IOS", "MAPS_API_KEY_IOS"]:
            with self.subTest(key=key):
                value = self.config.pop(key)
                self.write_config()
                self.assertNotEqual(self.run_script().returncode, 0)
                self.config[key] = value

    def test_wrong_flavor_and_invalid_facebook_id_are_rejected(self):
        self.config["FLAVOR"] = "dev"
        self.write_config()
        self.assertNotEqual(self.run_script().returncode, 0)
        self.config["FLAVOR"] = "prod"
        self.config["FACEBOOK_APP_ID_IOS"] = "fb123"
        self.write_config()
        self.assertNotEqual(self.run_script().returncode, 0)


if __name__ == "__main__":
    unittest.main()
