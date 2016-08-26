# Hardware Information

Check total CPU core (Not confirmed)

```sh
prtdiag | grep MHz | wc -l
```

Check total physical RAM

```sh
prtconf | grep Memory
```

Check hard disk size via ZFS storage pools

```sh
zpool list
```


# System Information

Check resource usage summary for each processe and user, sorted by size of the process image

```sh
prstat -a -s size
```

Print resource usage for every 2 second for a total of 3 cycles, swap and free are in Kbytes

```sh
vmstat 2 3
```

Print summary information about total swap space usage

```sh
swap -s
```
