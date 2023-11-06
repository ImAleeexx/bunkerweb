# -*- coding: utf-8 -*-
from typing import Annotated
from fastapi import APIRouter, Body
from utils import get_core_format_res
from models import ResponseModel
import json
from os import environ
from ui import UiConfig

UI_CONFIG = UiConfig("ui", **environ)

CORE_API = UI_CONFIG.CORE_ADDR

router = APIRouter(prefix="/api/custom_configs", tags=["custom_configs"])


@router.get(
    "",
    response_model=ResponseModel,
    summary="Get complete custom configs",
)
async def get_custom_configs():
    return get_core_format_res(f"{CORE_API}/custom_configs", "GET", "", "Retrieve custom configs")


@router.put(
    "",
    response_model=ResponseModel,
    summary="Update one or more custom configs",
)
async def update_custom_configs(custom_config: Annotated[dict, Body()], method: str = "ui"):
    data = json.dumps(custom_config, skipkeys=True, allow_nan=True, indent=6)
    return get_core_format_res(f"{CORE_API}/custom_configs?method={method}", "PUT", data, "Update custom configs")


@router.delete(
    "{custom_config_name}",
    response_model=ResponseModel,
    summary="Delete a custom config by name",
)
async def delete_custom_configs(custom_config_name: str, method: str = "ui"):
    return get_core_format_res(f"{CORE_API}/custom_configs/{custom_config_name}?method={method}", "DELETE", "", f"Delete custom config {custom_config_name}")
