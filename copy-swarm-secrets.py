import os
import sys
import json
import base64
import subprocess


secret_dir = '/run/secrets'


# import secrets
if len(sys.argv) > 1:
    secrets = json.loads(base64.b64decode(sys.argv[1]))

    if not os.path.isdir(secret_dir):
        os.mkdir(secret_dir)

    for secret in secrets.keys():
        file = os.path.join(secret_dir, secret)
        with open(file, 'wb') as f:
            f.write(base64.b64decode(secrets[secret]))

        command = ['docker', 'secret', 'create', secret, file]

        result = subprocess.run(command, capture_output=True)

        stderr = result.stderr.decode('utf-8').strip()
        if stderr:
            print(stderr, file=sys.stderr)

        stdout = result.stdout.decode('utf-8').strip()
        if stdout:
            print(stdout)

    sys.exit()


# export secrets
secrets = {}

for file in os.listdir(secret_dir):
    with open(os.path.join(secret_dir, file), 'rb') as f:
        secrets[file] = str(base64.b64encode(f.read()), 'utf-8')

print(str(base64.b64encode(json.dumps(secrets).encode('utf-8')), 'utf-8'))
