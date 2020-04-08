## Docker commands
Set up a Docker registry
```bash
# Start registry
docker run --name registry --publish published=5000,target=5000 --detach registry:2

# Check status
docker ps

# Check with `curl`
curl http://localhost:5000/v2/

# Remove service
docker stop registry
docker rm registry
```


## Docker swarm commands
Set up a Docker registry, referencing https://docs.docker.com/engine/swarm/stack-deploy/#set-up-a-docker-registry
```bash
# Start registry
docker service create --name registry --publish published=5000,target=5000 registry:2

# Check status
docker service ls

# Check with `curl`
curl http://localhost:5000/v2/

# Remove service
docker service rm registry
```
