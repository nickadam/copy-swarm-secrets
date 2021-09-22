# copy-swarm-secrets
Copy secrets between docker swarm clusters via ssh

# Install

```
docker run --rm --entrypoint=cat nickadam/copy-swarm-secrets copy-swarm-secrets.sh > copy-swarm-secrets.sh
chmod +x copy-swarm-secrets.sh
```

# Usage

```
./copy-swarm-secrets.sh SOURCE DESTINATION SECRET [SECRET]...
```

# Example

```
./copy-swarm-secrets.sh swarm.example.com localhost database_password ssl_key
```

# Notes

Secret names may not contain spaces. The user SSHing to the remote system must
have permissions to run docker.
