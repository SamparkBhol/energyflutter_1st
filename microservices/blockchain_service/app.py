from fastapi import FastAPI, HTTPException
from web3 import Web3
from pydantic import BaseModel

app = FastAPI()

# Connect to local Ethereum node
w3 = Web3(Web3.HTTPProvider("http://localhost:8545"))

# Contract ABI and address (replace with your own)
with open("contracts/EnergyTrading.json", "r") as file:
    contract_data = json.load(file)
contract_abi = contract_data["abi"]
contract_address = Web3.toChecksumAddress("0xYourContractAddress")

contract = w3.eth.contract(address=contract_address, abi=contract_abi)

class CreateTradeRequest(BaseModel):
    seller_address: str
    amount: int  # in kWh
    price: int   # in Wei per kWh

class CompleteTradeRequest(BaseModel):
    buyer_address: str
    trade_id: int

@app.post("/create_trade")
async def create_trade(request: CreateTradeRequest):
    try:
        transaction = contract.functions.createTrade(request.amount, request.price).buildTransaction({
            'from': Web3.toChecksumAddress(request.seller_address),
            'nonce': w3.eth.getTransactionCount(request.seller_address),
            'gas': 2000000,
            'gasPrice': w3.toWei('50', 'gwei')
        })
        signed_txn = w3.eth.account.signTransaction(transaction, private_key="0xYourPrivateKey")
        txn_hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
        return {"txn_hash": txn_hash.hex()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating trade: {str(e)}")

@app.post("/complete_trade")
async def complete_trade(request: CompleteTradeRequest):
    try:
        trade = contract.functions.getTrade(request.trade_id).call()
        transaction = contract.functions.completeTrade(request.trade_id).buildTransaction({
            'from': Web3.toChecksumAddress(request.buyer_address),
            'value': trade[1] * trade[2],  # amount * price
            'nonce': w3.eth.getTransactionCount(request.buyer_address),
            'gas': 2000000,
            'gasPrice': w3.toWei('50', 'gwei')
        })
        signed_txn = w3.eth.account.signTransaction(transaction, private_key="0xYourPrivateKey")
        txn_hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
        return {"txn_hash": txn_hash.hex()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error completing trade: {str(e)}")

@app.get("/trade/{trade_id}")
async def get_trade(trade_id: int):
    try:
        trade = contract.functions.getTrade(trade_id).call()
        return {
            "seller": trade[0],
            "buyer": trade[1],
            "amount": trade[2],
            "price": trade[3],
            "completed": trade[4]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error retrieving trade: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
