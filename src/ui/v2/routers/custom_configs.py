from typing import List
from fastapi import APIRouter
import requests
from utils import set_res
from models import ResponseModel
import json
import os
from dotenv import load_dotenv

load_dotenv()
CORE_PORT = os.getenv("CORE_PORT")
CORE_IP = os.getenv("CORE_IP")
API = f'{CORE_IP}:{CORE_PORT}'


router = APIRouter(prefix="/api/custom_configs", tags=["custom_configs"])


@router.get(
    "",
    response_model=ResponseModel,
    summary="Get complete custom configs",
)
async def get_custom_configs():
    req = requests.get(f"{API}/custom_configs")
    res = set_res(req, "GET", "Retrieve custom configs")
    return res

@router.put(
    "",
    response_model=ResponseModel,
    summary="Update one or more custom configs",
)
async def update_custom_configs(custom_config: List[dict], method: str):
    data = json.dumps(custom_config, skipkeys=True, allow_nan=True, indent=6)
    req = requests.put(f"{API}/custom_configs?method={method}", data=data)
    res = set_res(req, "PUT", "Update custom configs")
    return res


@router.delete(
    "{custom_config_name}",
    response_model=ResponseModel,
    summary="Delete a custom config by name",
)
async def delete_custom_configs(method: str, custom_config_name: str):
    req = requests.delete(f"{API}/custom_configs/{custom_config_name}?method={method}")
    res = set_res(req, "DELETE", f"Delete custom config {custom_config_name}")
    return res
