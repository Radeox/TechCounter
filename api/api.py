from tastypie import fields
from tastypie.authorization import Authorization
from tastypie.resources import ModelResource

from api.models import Technology, Webpage
from api.validators import RegexValidator


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
    technologies = fields.ManyToManyField(TechResource, 'technologies')

    """API response for 'webpage' query"""
    class Meta:
        queryset = Webpage.objects.all()
        resource_name = 'webpage'

        # No authorization checks
        authorization = Authorization()
