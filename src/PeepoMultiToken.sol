// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract PeepoMultiToken is ERC1155, Ownable {
  using Strings for uint256;

  constructor() ERC1155("") Ownable(msg.sender) { }

  function mint(address to, uint256 id, uint256 amount) public onlyOwner {
    _mint(to, id, amount, "");
  }

  function uri(uint256 id) public view override returns (string memory) {
    // Build the dynamic image URL based on ID
    string memory imageUri =
    // solhint-disable quotes, gas-small-strings
    string(abi.encodePacked("https://cdn.betterttv.net/emote/5a16ee718c22a247ead62d4a/", id.toString(), "x.webp"));

    // solhint-disable quotes, gas-small-strings
    bytes memory json = abi.encodePacked(
      "{",
      '"name": "Peepo Multi #',
      id.toString(),
      '",',
      '"description": "Dynamic Peepo editions.",',
      '"image": "',
      imageUri,
      '"',
      "}"
    );

    return string(abi.encodePacked("data:application/json;base64,", Base64.encode(json)));
  }
}
