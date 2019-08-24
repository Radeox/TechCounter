from tastypie import fields
from tastypie.authorization import Authorization
from tastypie.resources import ModelResource

from api.checker import check_page
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

        # Check which technologies are present
        check_page(page)

        return bundle
