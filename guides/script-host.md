---
description: Jupyter→ Zero <--> Multiple Workers
---

# Script Host



The idea is to have a solid ZMQ Broker, to which several Workers can be connected, offering different script engines. Each script engine is identified by the name of the service. There can even be multiple workers for each engine

. When the broker receives a query from the client, it redirects it to the appropriate worker and returns the response. Workers can be on the same server or on other servers and can be dynamically connected or disconnected.
