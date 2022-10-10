// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RtcNft is
ERC721,
Ownable
{
    using Counters for Counters.Counter;
    using MerkleProof for MerkleProof;
    Counters.Counter private _tokenIdCounter;
    bytes32 private immutable merkleRoot;
    
    constructor() ERC721("NFT Workshop", "RtcNft") {}

    function mint() public {
       bytes32 node = keccak256(
            abi.encodePacked(account, amount)
        );
        bool isValidProof = MerkleProof.verifyCalldata(
            merkleProof,
            merkleRoot,
            node
        );
        require(isValidProof, 'Invalid proof.');
        
       _tokenIdCounter.increment();
      uint256 tokenId = _tokenIdCounter.current();

      _safeMint(msg.sender, tokenId);
    }
    
    function setMerkleRoot(bytes32 _merkleRoot) onlyOwner {
        merkleRoot = _merkleRoot;
    }
}
