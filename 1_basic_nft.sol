// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RtcNft is
ERC721,
Ownable
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
     constructor() ERC721("NFT Workshop", "RtcNft") {}

     function mint() public {
         _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(msg.sender, tokenId);
    }
}
