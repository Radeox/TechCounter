import re

import requests
from tastypie import fields
from tastypie.authorization import Authorization
from tastypie.resources import ModelResource

from api.models import Technology, Webpage
from api.validators import PageChecker, RegexValidator


class TechResource(ModelResource):
    """API response for 'tech' query"""

    class Meta:
        queryset = Technology.objects.all()
        resource_name = 'tech'

        # No authorization checks
        authorization = Authorization()

        # Validate the regex received from user
        validation = RegexValidator()


class PageResource(ModelResource):
    # Get present technologies for each webpage
    technologies = fields.ManyToManyField(
        TechResource, 'technologies', null=True)

    """API response for 'webpage' query"""
    class Meta:
        queryset = Webpage.objects.all()
        resource_name = 'webpage'

        # No authorization checks
        authorization = Authorization()

        # Check if the link received from user is valid
        validation = PageChecker()

    # Override method to check technologies during the creation of the object
    def obj_create(self, bundle, **kwargs):
        bundle = super(PageResource, self).obj_create(bundle, **kwargs)

        # Get last created page
        page = Webpage.objects.last()

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

        return bundle
