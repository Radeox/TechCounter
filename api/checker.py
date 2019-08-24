import re

import requests

from api.models import Technology


def check_page(page):
    # Get page
    req = requests.get(page.url)

    # Check which tecnhnology is present
    for tech in Technology.objects.all():
        # Compile regular expression
        regex = re.compile(tech.regex)

        if regex.search(req.text):
            # Regex matched something in the page
            # Add it to the Webpage's technologies
            page.technologies.add(tech)

    # Save changes to page
    page.save()
