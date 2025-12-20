// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title PeepoNFT
 * @notice An on-chain NFT collection featuring Peepo
 * @author Petar Zarkov
 */
contract PeepoNFT is ERC721, Ownable {
  using Strings for uint256;

  uint256 private _nextTokenId;

  /**
   * @dev Constructor initializes the NFT collection name and symbol
   */
  constructor() ERC721("PeepoNFT", "PEEP") Ownable(msg.sender) { }

  /**
   * @dev Public mint function for the owner
   * @param to The address that will receive the NFT
   */
  function safeMint(address to) public onlyOwner {
    uint256 tokenId = ++_nextTokenId;
    _safeMint(to, tokenId);
  }

  /**
   * @dev Returns the metadata for a specific token ID as a Base64 encoded JSON
   * @param tokenId The ID of the token to fetch metadata for
   */
  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    _requireOwned(tokenId);

    // solhint-disable quotes, gas-small-strings
    bytes memory json = abi.encodePacked(
      "{",
      '"name": "Peepo #',
      tokenId.toString(),
      '",',
      '"description": "This Peepo lives entirely on the blockchain.",',
      '"image": "https://cdn.betterttv.net/emote/5a16ee718c22a247ead62d4a/3x.webp",',
      '"attributes": [{"trait_type": "Platform", "value": "Sepolia"}]',
      "}"
    );

    return string(abi.encodePacked("data:application/json;base64,", Base64.encode(json)));
  }
}
