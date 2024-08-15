from utils import save_builder

from pages.reports import reports_builder

reports = [
    {
        "date": 1723491739954,
        "ip": "127.0.0.1",
        "country": "EN",
        "method": "POST",
        "url": "/admin",
        "code": "400",
        "user_agent": "Mozilla/5.0",
        "reason": "antibot",
        "data": "lore ipsum ad vitam aeternam",
        "server_name": "localhost",
    },
    {
        "date": 1723491738000,
        "ip": "127.0.0.2",
        "country": "EN",
        "method": "GET",
        "url": "/etc?",
        "code": "300",
        "user_agent": "Mozilla/0.1",
        "reason": "unknown",
        "data": "",
        "server_name": "localhost",
    },
]

# define a set
countries = set()
methods = set()
codes = set()
reasons = set()
for report in reports:
    countries.add(report["country"])
    methods.add(report["method"])
    codes.add(report["code"])
    reasons.add(report["reason"])

# convert set to list
countries = list(countries)
methods = list(methods)
codes = list(codes)
reasons = list(reasons)

builder = reports_builder(reports=reports, reasons=reasons, countries=countries, methods=methods, codes=codes)

save_builder(page_name="reports", output=builder, script_name="reports")