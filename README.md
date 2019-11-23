# About CastleCMS

[CastleCMS](https://castlecms.io/) is an enhanced distribution of Plone,
the open source web CMS that was created in 2001 and that has an unparalleled security track record.

## Features of CastleCMS
- Login/lockout support
- Content archival to Amazon S3 storage
- Large files automatically moved to S3 storage
- Redis cache support
- Advanced content layout editor
- Improved management toolbar
- Intuitive content creation and organization
- Elasticsearch integration
- Search results tuned by social media impact
- Search results pinning
- Celery task queue integration (asynchronous actions)
    - PDF generation
    - Video conversion
    - Amazon S3 interaction
    - copying and pasting of large batches of items
    - deletion and renaming of large batches of items
- Advanced content tiles:
    - maps
    - videos
    - audio
    - sliders
    - galleries
    - table of contents
- Audio and video content
- Automatic conversion of videos to web compatible format
- Search weighting based on popularity using Google Analytics API
- Content alias management
- Disqus commenting integration
- reCAPTCHA integration
- fullcalendar integration
- Google Business metadata
- Emergency notification system with optional SMS support
- Preview content on a variety of device sizes
- Map content
- KML feeds
- Social media integration with Twitter, Facebook, Pinterest
- Etherpad collaborative spaces support
- Stripping metadata from files
- Ability to view the site as another user
- Audit log, user activity reports
- Session management, inspection and termination
- Analytics dashboard
- De-duplication of uploaded images and files
- Trash can / recycle bin
- Two factor authentication

## Dependencies

- Redis (Docker Support)
- avconv (needs to be updated for ffmpeg again)
- ElasticSearch 2.3 (Docker Support)

### Running local dependencies with docker

```
$ docker run -d -p 6379:6379 redis
$ docker run -d -p 9200:9200 elasticsearch:2.3.5
```

# CastleCMS Docker Support

## Image Features

- Images for Castle 2.5.x
- Enable add-ons via environment variables
- Only supports [Debian](https://www.debian.org/) based images


## Supported tags and respective `Dockerfile` links for CastleCMS

- [`2.5.0`, `2.5`, `2`, `latest` (*2.5.0/Dockerfile*)](https://github.com/JamaicanDeveloeprs/castle.docker/blob/master/2.5/2.5.0/debian/Dockerfile)


## Prerequisites

Make sure you have Docker installed and running for your platform. You can download Docker from https://hub.docker.com.


## Usage

Choose either single Castle instance or ZEO cluster.

**It is inadvisable to use following configurations for production.**


### Standalone Castle Instance

Castle standalone instances are best suited for testing Castle and development.

Download and start the latest Castle 5 container, based on [Debian](https://www.debian.org/).

```console
$ docker run -p 8080:8080 castlecms
```

This image includes `EXPOSE 8080` (the Castle port), so standard container linking will make it automatically available to the linked containers. Now you can add a Castle Site at http://localhost:8080 - default Zope user and password are **`admin/admin`**.


### Castle As ZEO Cluster

ZEO cluster are best suited for production setups, you will **need** a loadbalancer.

Start ZEO server in the background

```console
$ docker run -d --name=zeo castlecms zeo
```

Start 2 Castle clients (also in the background)

```console
$ docker run -d --name=instance1 --link=zeo -e ZEO_ADDRESS=zeo:8080 -p 8081:8080 castlecms
$ docker run -d --name=instance2 --link=zeo -e ZEO_ADDRESS=zeo:8080 -p 8082:8080 castlecms
```

### Start Castle In Debug Mode

You can also start Castle in debug mode (`fg`) by running

```console
$ docker run -p 8080:8080 castlecms fg
```

Debug mode may also be used with ZEO

```console
$ docker run --link=zeo -e ZEO_ADDRESS=zeo:8080 -p 8080:8080 castlecms fg
```

## Supported Environment Variables

The Castle image uses several environment variable that allow to specify a more specific setup.

### For Basic Usage

* `ADDONS` - Customize Castle via Castle add-ons using this environment variable
* `ZEO_ADDRESS` - This environment variable allows you to run Castle image as a ZEO client.
* `SITE` - Add Castle with this id to `Data.fs` on first run. If NOT provided, you'll have to manually add a Castle Site via web UI
* `VERSIONS` - Use specific versions of Castle Add-on or python libraries

Run Castle and install two addons (eea.facetednavigation and collective.easyform)

```console
$ docker run -p 8080:8080 -e SITE="mysite" -e ADDONS="eea.facetednavigation collective.easyform" castlecms
```

To use specific add-ons versions:

```console
 -e ADDONS="eea.facetednavigation collective.easyform" -e VERSIONS="eea.facetednavigation=13.3 collective.easyform=2.1.0"
```

RestAPI:

```console
$ docker run -p 8080:8080 -e SITE=castle castlecms

$ curl -H 'Accept: application/json' http://localhost:8080/castle
```

### For Advanced Usage

**Castle:**

* `PLONE_ADDONS`, `ADDONS` - Customize Castle via Castle add-ons using this environment variable
* `PLONE_SITE`, `SITE` - Add Castle with this id to `Data.fs` on first run. If NOT provided, you'll have to manually add a Castle Site via web UI
* `PLONE_VERSIONS`, `VERSIONS` - Use specific versions of Castle Add-on or python libraries
* `PLONE_PROFILES, PROFILES` - GenericSetup profiles to include when `SITE` environment provided.
* `PLONE_ZCML`, `ZCML` - Include custom Castle add-ons ZCML files
* `PLONE_DEVELOP`, `DEVELOP` - Develop new or existing Castle add-ons

**ZEO:**

* `ZEO_ADDRESS` - This environment variable allows you to run Castle image as a ZEO client.
* `ZEO_READ_ONLY` - Run Castle as a read-only ZEO client. Defaults to `off`.
* `ZEO_CLIENT_READ_ONLY_FALLBACK` - A flag indicating whether a read-only remote storage should be acceptable as a fallback when no writable storages are available. Defaults to `false`.
* `ZEO_SHARED_BLOB_DIR` - Set this to on if the ZEO server and the instance have access to the same directory. Defaults to `off`.
* `ZEO_STORAGE` - Set the storage number of the ZEO storage. Defaults to `1`.
* `ZEO_CLIENT_CACHE_SIZE` - Set the size of the ZEO client cache. Defaults to `128MB`.
* `ZEO_PACK_KEEP_OLD` - Can be set to false to disable the creation of *.fs.old files before the pack is run. Defaults to true.

**CORS:**

* `CORS_ALLOW_ORIGIN` - Origins that are allowed access to the resource. Either a comma separated list of origins, e.g. `http://example.net,http://mydomain.com` or `*`. Defaults to `http://localhost:3000,http://127.0.0.1:3000`
* `CORS_ALLOW_METHODS` - A comma separated list of HTTP method names that are allowed by this CORS policy, e.g. `DELETE,GET,OPTIONS,PATCH,POST,PUT`. Defaults to `DELETE,GET,OPTIONS,PATCH,POST,PUT`
* `CORS_ALLOW_CREDENTIALS` - Indicates whether the resource supports user credentials in the request. Defaults to `true`
* `CORS_EXPOSE_HEADERS` - A comma separated list of response headers clients can access, e.g. `Content-Length,X-My-Header`. Defaults to `Content-Length,X-My-Header`
* `CORS_ALLOW_HEADERS` - A comma separated list of request headers allowed to be sent by the client, e.g. `X-My-Header`. Defaults to `Accept,Authorization,Content-Type,X-Custom-Header`
* `CORS_MAX_AGE` - Indicates how long the results of a preflight request can be cached. Defaults to `3600`


### Docker Image Development

New images can be generated by running the following command:
```
./generate-template.sh 2.5 0 6
```

Using the root files as templates for each version of Castle CMS,
the command above will generate several subfolders representing version 2.5.0 to 2.5.6.
The structure of the command is as the following:
```
# ./generate-template.sh <major>.<minor> <start-patch-range> <end-patch-range>
```

Once generated, you can modify each Docker version.

#### Testing Docker Images

Each docker image can be tested by running the following command:
```
./test-template.sh
```


## Contribute


- Issue Tracker: http://github.com/JamaicanDeveloeprs/castle.docker/issues
- Source Code: http://github.com/JamaicanDeveloeprs/castle.docker


## Support


If you are having issues, please let us know at https://community.plone.org


## License

The project is licensed under the GPLv2.
