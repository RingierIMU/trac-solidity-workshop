const keccak256 = require("keccak256");
const { MerkleTree } = require("merkletreejs");

let balances = [
    "0xb7e390864a90b7b923c9f9310c6f98aafe43f707",
    "0xea674fdde714fd979de3edf0f56aa9716b898ec8",
];

const leafNodes = balances.map((balance) =>
    keccak256(balance)
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
