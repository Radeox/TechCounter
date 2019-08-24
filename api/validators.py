import re

import requests
from tastypie.validation import Validation


class RegexValidator(Validation):
    """Check if submitted regex is valid"""

    def is_valid(self, bundle, request=None):
        for key, value in bundle.data.items():
            # Check if regex is valid
            if key == "regex":
                try:
                    # Restore escaped slashes
                    value.replace(r"\\", r"/\/")
                    re.compile(value)

                    # The regex is correct
                    error = False
                except re.error:
                    # Found an error in regular expression
                    error = True

        return error


class PageChecker(Validation):
    """Check which technologies are used in the webpage"""

    def is_valid(self, bundle, request=None):
        for key, value in bundle.data.items():
            if key == "url":
                try:
                    req = requests.get(value)

                    # Check page response
                    if req.status_code == 200:
                        error = False
                    else:
                        error = {"status": 400, "error": "Link return: {0}".format(req.status_code)}
                except:
                    # Could not parse the link
                    error = {"status": 400, "error": "Invalid link"}

        return error
