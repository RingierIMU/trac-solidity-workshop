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
    Counters.Counter private _tokenIdCounter;
    bytes32 private merkleRoot;
    
    constructor() ERC721("NFT Workshop", "RtcNft") {}

    function mint(bytes32[] calldata merkleProof) public {
       bytes32 node = keccak256(
            abi.encodePacked(msg.sender)
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
    
    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }
}
