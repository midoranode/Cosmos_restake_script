#!/bin/bash

while true
    do
    
        SERVICE=hid-noded
        VALOPER=hidvaloper****
        WALLETNAME=hyperwallet
        WALLETADDRESS=hid1****
        DENOM=uhid
        FEES=2000
        MINBAL=20000
        PASSWORD=xxxxxxxxx
        CHAINID=jagrat
        NODEPORT=26657
        RESTAKETIME=21600
        
        echo $PASSWORD | $SERVICE tx distribution withdraw-rewards $VALOPER --from $WALLETNAME --fees $FEES$DENOM --commission -y --chain-id $CHAINID --node tcp://localhost:$NODEPORT
        sleep 30
        BALANCE=$($SERVICE q bank balances $WALLETADDRESS --chain-id $CHAINID --node tcp://localhost:$NODEPORT --output json | jq -r ".balances[] | select(.denom == \"$DENOM\")  | .amount")
        if [ "$BALANCE" -gt "$MINBAL" ] # or  (( $BALANCE > $MINBAL ))
         
            then
                SUM=$(( $BALANCE - $MINBAL ))
                sleep 3
                echo $PASSWORD | $SERVICE tx staking delegate $VALOPER $SUM$DENOM --from $WALLETNAME --fees $FEES$DENOM -y --chain-id $CHAINID --node tcp://localhost:$NODEPORT
                sleep $RESTAKETIME
            
            else
                sleep $RESTAKETIME
        fi

done
