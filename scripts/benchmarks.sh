#!/bin/bash

steps=50
repeat=20

statemineOutput=./axia-allychains/statemine/src/weights
statemintOutput=./axia-allychains/statemint/src/weights
westmintOutput=./axia-allychains/westmint/src/weights

statemineChain=statemine-dev
statemintChain=statemint-dev
westmintChain=westmint-dev

pallets=(
    pallet_assets
	pallet_balances
	pallet_collator_selection
	pallet_multisig
	pallet_proxy
	pallet_session
	pallet_timestamp
	pallet_utility
    pallet_uniques
    frame_system
)

for p in ${pallets[@]}
do
	./target/production/axia-collator benchmark \
		--chain=$statemineChain \
		--execution=wasm \
		--wasm-execution=compiled \
		--pallet=$p  \
		--extrinsic='*' \
		--steps=$steps  \
		--repeat=$repeat \
		--json \
        --header=./file_header.txt \
		--output=$statemineOutput

	./target/production/axia-collator benchmark \
		--chain=$statemintChain \
		--execution=wasm \
		--wasm-execution=compiled \
		--pallet=$p  \
		--extrinsic='*' \
		--steps=$steps  \
		--repeat=$repeat \
		--json \
        --header=./file_header.txt \
		--output=$statemintOutput

	./target/production/axia-collator benchmark \
		--chain=$westmintChain \
		--execution=wasm \
		--wasm-execution=compiled \
		--pallet=$p  \
		--extrinsic='*' \
		--steps=$steps  \
		--repeat=$repeat \
		--json \
        --header=./file_header.txt \
		--output=$westmintOutput
done
