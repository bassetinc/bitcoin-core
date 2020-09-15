# Bitcoin Core container

## Building node
```
docker build --rm -t bitcoin .
```

## Running node
Bitcoin Core typically requires more than 350GB of storage with fully synchronized blockchain. You should bind a volume or any host directory to the container to keep the blockchain external to the container.
```
docker rm -f bitcoin-node
docker run --name=bitcoin-node -v /mnt/bitcoin:/home/user/.bitcoin -d bitcoin
```

Consider providing `bitcoin.conf` for the node. You can find an example in the [official Bitcoin Core repository](https://github.com/bitcoin/bitcoin/blob/master/share/examples/bitcoin.conf). A user-friendly generator is also available [here](https://jlopp.github.io/bitcoin-core-config-generator/).


### If you need to expose ports
Add following parameters to the commandline `docker run` above.
```
-p 8333:8333 -p 127.0.0.1:8332:8332
```

## Open docker log files
```
docker logs -f bitcoin-node
```

## Execute shell within the container
If you want to execute commands inside the container, run following.
```
docker exec -ti bitcoin-node bash
```
