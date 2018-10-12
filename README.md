Fortune Teller Demo (Ruby)
===

A rewrite of the [Spring Fortune Teller demo](https://github.com/spring-cloud-samples/fortune-teller) in Ruby, made of two components, the UI and the Fortune Service.

Running the demo on Cloud Foundry
---
Requires cf networking, polyglot service discovery enabled.

Optionally use the experimental zdt restart and push with cflinuxfs3 stack and ruby buildpack

1. Push both apps
```
cf push fortune-teller-ui -b ruby_buildpack -m 100M -i 3 
cf push fortune-teller-server -b ruby_buildpack --no-route -m 100M -i 2
```
2. Access the UI, for example on bosh-lite, http://fortune-teller-ui.bosh-lite.com/, and enable auto-refresh

2. Map an internal route to the fortune-teller-server
```
cf map-route fortune-teller-server apps.internal --hostname fortune-teller-server
```
3. Create a service and, bind it to fortune-teller-ui
```
cf cups fortune-server -p '{"url":"http://fortune-teller-server.apps.internal:8080"}'
cf bs fortune-teller-ui fortune-server
```
4. Restart your app

If you don't have capi deployments enabled
```
cf restart fortune-teller-ui
```
If you do have the experimental capi deployments enabled
```
cf v3-zdt-restart fortune-teller-ui
```
5. Add app to app network policy
```
cf add-network-policy fortune-teller-ui --destination-app fortune-teller-server
```
6. Bonus! If you have cflinuxfs3 stack and ruby buildpack available, do a zero down time update of dependencies of the fortune-teller-ui
```
cf v3-zdt-push fortune-teller-ui -s cflinuxfs3 --wait-for-deploy-complete
```

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
