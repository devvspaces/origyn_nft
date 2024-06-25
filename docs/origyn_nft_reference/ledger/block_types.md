# origyn_nft_reference/ledger/block_types

## Function `supported_blocktypes`
``` motoko no-repl
func supported_blocktypes() : [(Text, Text)]
```


## Function `upgrade_block_to_icrc3`
``` motoko no-repl
func upgrade_block_to_icrc3(block : MigrationTypes.Current.TransactionRecord, former_phash : ?Blob) : (ICRC3.Value, ?ICRC3.Value)
```

