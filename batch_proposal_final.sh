#!/bin/bash

GAS_ADJUSTMENT=1.5
GAS_PRICES=500000000inj
GAS=50000000
WASM_BIN=injectived

# TESTNET
DEPOSIT="50000000000000000000inj"
WASM_NODE=https://testnet.sentry.tm.injective.network:443
WASM_CHAIN_ID=injective-888
WASM_WALLET=main
WASM_EXTRA=" "

# MAINNET
# DEPOSIT="100000000000000000000inj"
# WASM_NODE=https://injective-rpc.publicnode.com:443
# WASM_CHAIN_ID=injective-1
# WASM_WALLET=xcall_wallet
# WASM_EXTRA=" --keyring-backend test "

WASM_COMMON_ARGS=" --deposit=${DEPOSIT} --from ${WASM_WALLET} ${WASM_EXTRA} --chain-id ${WASM_CHAIN_ID} --broadcast-mode sync --node ${WASM_NODE} --gas ${GAS} --gas-adjustment ${GAS_ADJUSTMENT} --gas-prices ${GAS_PRICES} --log-format json  --yes"

mkdir -p artifacts

# 
function check_txn_result() {
	local tx_hash=$1
	while :; do
		(${WASM_BIN} query tx ${tx_hash} --node $WASM_NODE --chain-id $WASM_CHAIN_ID --output json &>/dev/null) && break || sleep 2
	done

	local code=$(${WASM_BIN} query tx ${tx_hash} --node $WASM_NODE --chain-id $WASM_CHAIN_ID --output json | jq -r .code)
	if [ $code == "0" ]; then 
		echo "txn successful"
	else
		echo "txn failure"
	fi
}

function create_proposal() {
    local contract_files="$1"
    local proposal_file="$2"
    echo "Contracts to store: " 
    echo "            " $contract_files
    echo " "
    echo "Proposal file"
    echo "             " $proposal_file
    echo 

    read -p "Do you want to continue with the proposal? (y/n): " choice
    if [ "$choice" != "y" ]; then
        echo "Exiting..."
        exit 1
    fi

    local txn_data=$(${WASM_BIN} tx xwasm batch-store-code-proposal \
        --contract-files=${contract_files} \
        --batch-upload-proposal=${proposal_file} ${WASM_COMMON_ARGS})
    local code=$(echo "$txn_data" | grep -o 'code: [0-9]*' | cut -d ' ' -f 2)

    if [ "$code" != "0" ]; then
        echo "Error storing proposal"
        echo $txn_data
        exit 1
    fi

    local txhash=$(echo "$txn_data" | grep -o 'txhash: [0-9A-F]\{64\}' | cut -d ' ' -f 2)
    echo "tx_hash: " $txhash
    check_txn_result $txhash
    echo "Proposal Created!"
}

# create_proposal "./artifacts/cw_asset_manager.wasm,./artifacts/cw_hub_bnusd.wasm" "./batch_store_proposal_testnet_final.json"
create_proposal "./cw_asset_manager.wasm,./cw_hub_bnusd.wasm" "./batch_store_proposal_1.json"
create_proposal "./cw_xcall_manager.wasm,./cw_xcall_2.1.1.wasm" "./batch_store_proposal_2.json"

