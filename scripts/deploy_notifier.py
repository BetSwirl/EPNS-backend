#!/usr/bin/env python

from brownie import (
    Notifier,
    TransparentUpgradeableProxy,
    ProxyAdmin,
    config,
    network,
    Contract,
)
from scripts.helpful_scripts import get_account, encode_function_data


def main():
    account = get_account()
    print(f"Deploying to {network.show_active()}")
    notifier = Notifier.deploy(
        {"from": account},
        publish_source=config["networks"][network.show_active()]["verify"],
    )
    proxy_admin = ProxyAdmin.deploy(
        {"from": account},
    )
    notifier_encoded_initializer_func = encode_function_data(initializer=notifier.initialize)
    proxy = TransparentUpgradeableProxy.deploy(
        notifier.address,
        proxy_admin.address,
        notifier_encoded_initializer_func,
        {"from": account, "gas_limit": 1000000},
    )
    print(f"Proxy deployed to {proxy}!")
    proxy_notifier = Contract.from_abi("Notifier", proxy, Notifier.abi)
    print(f"CID: {proxy_notifier.identity(2)}")
