from py_ecc.secp256k1 import *
from eth_account import Account
from Crypto.Hash import keccak

# privkey: 0xd952fe0740d9d14011fc8ead3ab7de3c739d3aa93ce9254c10b0134d80d26a30
# address: 0x3CB39EA2f14B16B69B451719A7BEd55e0aFEcE8F
s = int(0xd952fe0740d9d14011fc8ead3ab7de3c739d3aa93ce9254c10b0134d80d26a30) # private key
S = secp256k1.privtopub(s.to_bytes(32, "big")) # public key

# privkey: 0x0000000000000000000000000000000000000000000000000000000000000001
# address: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
p = int(0x0000000000000000000000000000000000000000000000000000000000000002) # private key
P = secp256k1.privtopub(p.to_bytes(32, "big")) # public key

Q = secp256k1.multiply(S, p)
assert Q == secp256k1.multiply(P, s)
# hex the shared secret
k = keccak.new(digest_bits=256)
Q_hex = k.update(Q[0].to_bytes(32, "big")+Q[1].to_bytes(32, "big")).hexdigest() # note, toStr conversion
Q_hashed = bytearray.fromhex(Q_hex)

# Sender sends to ...
test = secp256k1.add(P, secp256k1.privtopub(Q_hashed))
k = keccak.new(digest_bits=256)
test_hex = k.update(test[0].to_bytes(32, "big")+test[1].to_bytes(32, "big")).hexdigest()
#print(test_hex)


# recipient stealth key
p_stealth = p + int(Q_hex, 16)
# print(hex(p_stealth))

# Recipient has private key to ...
P_stealth = secp256k1.privtopub(p_stealth.to_bytes(32, "big"))

print(Account.from_key(p_stealth.to_bytes(32, "big")).address)
