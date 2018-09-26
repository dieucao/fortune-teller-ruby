Fortune Teller Demo (Ruby)
===

A rewrite of the [Spring Fortune Teller demo](https://github.com/spring-cloud-samples/fortune-teller) in Ruby, made of two components, the UI and the Fortune Service.

Running the demo locally
---

Both applications are simple [Sinatra](http://sinatrarb.com/) applications using the [Rack](https://rack.github.io/). 

1. Start the Fortune Service

```
cd fortune-teller-server
rackup -p 9293
```

2. In a sercond terminal, start the UI


```
cd fortune-teller-ui
rackup
```

3. Access the UI at [http://localhost:9292](http://localhost:9292)


Connecting the UI to the Fortune Service
----

By default, the UI will look for the Fortune Service at [http://localhost:9293](http://localhost:9293), however this can be changed when deployed to Cloud Foundry using a [User-Provided Service](https://docs.cloudfoundry.org/devguide/services/user-provided.html) and binding it to the deployed version of the UI.

```
cf create-user-provided-service fortune-server -p '{"url":"http://fortune-server.cfapps.io"}'

cf bind-service fortune-ui fortune-server
```