import os
from setuptools import setup

buildNumber = os.environ.get("CI_PIPELINE_IID")
if not buildNumber:
    buildNumber = "0"

setup(
    version=f"2.0.0.{buildNumber}"
)
