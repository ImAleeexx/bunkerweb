import json
import base64

from builder.instances import instances_builder


# Create instance class using keys from the instances list
class Instance:
    def __init__(self, _type, health, _id, hostname, name):
        self._type = _type
        self.health = health
        self._id = _id
        self.hostname = hostname
        self.name = name


instances = [
    Instance("manual", True, "bunkerweb", "bunkerweb", "bunkerweb"),
    Instance("manual", True, "bunkerweb", "bunkerweb", "bunkerweb"),
]


builder = instances_builder(instances)

# store on a file
with open("instances.json", "w") as f:
    json.dump(builder, f)

output_base64_bytes = base64.b64encode(bytes(json.dumps(builder), "utf-8"))
output_base64_string = output_base64_bytes.decode("ascii")

with open("instances.txt", "w") as f:
    f.write(output_base64_string)