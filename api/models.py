
from django.db import models


class Technology(models.Model):
    """Model that represent a web technology

    The regex will be used to check if a given page use that tech.
    """
    name = models.CharField("Technology name", max_length=20)
    regex = models.CharField("Regular expression", max_length=100)

    def __str__(self):
        return self.name


class Webpage(models.Model):
    """Model that represent a Webpage(name, link).

    This page probably use some web technologies
    (discoverd through regex matching).
    """
    name = models.CharField("Page name", max_length=20)
    url = models.CharField("Page URL", max_length=200, blank=False)
    technologies = models.ManyToManyField(Technology, blank=True)

    def __str__(self):
        return self.name
