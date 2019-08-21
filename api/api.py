from tastypie.resources import ModelResource
from tastypie.authorization import Authorization
from api.models import Technology, Webpage


class TechResource(ModelResource):
    class Meta:
        queryset = Technology.objects.all()
        resource_name = 'tech'
        authorization = Authorization()


class PageResource(ModelResource):
    class Meta:
        queryset = Webpage.objects.all()
        resource_name = 'webpage'
        authorization = Authorization()
