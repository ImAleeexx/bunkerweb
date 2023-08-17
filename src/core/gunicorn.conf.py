from os import sep
from os.path import join

wsgi_app = "app.main:app"
proc_name = "bunkerweb-core"
accesslog = "-"
errorlog = "-"
preload_app = True
pidfile = join(sep, "var", "run", "bunkerweb", "api.pid")
worker_class = "app.core.BwUvicornWorker"
graceful_timeout = 0
