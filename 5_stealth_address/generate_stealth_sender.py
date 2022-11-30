from Crypto.PublicKey import ECC
from py_ecc.secp256k1 import *
from eth_account import Account
from Crypto.Hash import keccak
from eth_abi.packed import encode_packed

k = keccak.new(digest_bits=256)

# privkey: 0x503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb
# address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
senderPrivate = int(0x503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb) # private key
SenderPublic = secp256k1.privtopub(senderPrivate.to_bytes(32, "big")) # public key

# privkey: 0x7e5bfb82febc4c2c8529167104271ceec190eafdca277314912eaabdb67c6e5f
# address: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
receiverPrivate = int(0x00000000000000000000000000000000000000000000000000000000000000003) # private key
receiverPublic = secp256k1.privtopub(receiverPrivate.to_bytes(32, "big")) # public key

Q = secp256k1.multiply(SenderPublic, receiverPrivate)
assert Q == secp256k1.multiply(receiverPublic, senderPrivate)
Q_hex = k.update(Q[0].to_bytes(32, "big")+Q[1].to_bytes(32, "big")).hexdigest() # note, toStr conversion
Q_hashed = bytearray.fromhex(Q_hex)

# Sender sends to ...
points = secp256k1.add(receiverPublic, secp256k1.privtopub(Q_hashed))
print(points)


p_stealth = receiverPrivate + int(Q_hex, 16)

# Recipient has private key to ...
P_stealth = secp256k1.privtopub(p_stealth.to_bytes(32, "big"))
print(f'shared secret: {Q_hex}')
print(f'stealth private key: {hex(p_stealth)}')
print(f'stealth address: {Account.from_key((p_stealth).to_bytes(32, "big")).address}')
