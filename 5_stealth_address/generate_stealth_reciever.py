from Crypto.Hash import keccak
from eth_account import Account
from py_ecc.secp256k1 import *

k = keccak.new(digest_bits=256)

# address: 0xefe069d5383CD50c814d1041727d6329A3f67445
SenderPublic = (10309162224665627235673894752924500834289478424146150260378336110461043342057, 37496110060917264869746889430630339257314574992249846300867824856135040563375)

# privkey: 0x0000000000000000000000000000000000000000000000000000000000000001
# address: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
receiverPrivate = int(0x0000000000000000000000000000000000000000000000000000000000000002) # private key
receiverPublic = secp256k1.privtopub(receiverPrivate.to_bytes(32, "big")) # public key

Q = secp256k1.multiply(SenderPublic, receiverPrivate)
Q_hex = k.update(Q[0].to_bytes(32, "big")+Q[1].to_bytes(32, "big")).hexdigest() # note, toStr conversion
Q_hashed = bytearray.fromhex(Q_hex)

# Sender sends to ...
points = secp256k1.add(receiverPublic, secp256k1.privtopub(Q_hashed))
p_stealth = receiverPrivate + int(Q_hex, 16)

# Recipient has private key to ...
P_stealth = secp256k1.privtopub(p_stealth.to_bytes(32, "big"))
print(f'shared secret: {Q_hex}')
print(f'stealth private key: {hex(p_stealth)}')
print(f'stealth address: {Account.from_key((p_stealth).to_bytes(32, "big")).address}')
