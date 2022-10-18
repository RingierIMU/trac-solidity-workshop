const keccak256 = require("keccak256");
const { MerkleTree } = require("merkletreejs");

let addresses = [
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0xea674fdde714fd979de3edf0f56aa9716b898ec8",
];

const leafNodes = addresses.map((address) =>
    keccak256(address)
);

const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

console.log("---------");
console.log("Merke Tree");
console.log("---------");
console.log(merkleTree.toString());
console.log("---------");
console.log("Merkle Root: " + merkleTree.getHexRoot());

console.log("Proof 1: " + merkleTree.getHexProof(leafNodes[0]));
console.log("Proof 2: " + merkleTree.getHexProof(leafNodes[1]));