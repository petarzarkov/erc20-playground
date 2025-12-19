// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

contract PeepoToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("PeepoToken", "PEEP") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    // Function to mint more tokens (only owner)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /// @dev Returns an inline, on-chain JSON metadata string.
    function metadata() public returns (string memory) {
        bytes memory json = abi.encodePacked(
            "{",
            '"name": "PeepoToken",',
            '"description": "Peepo is 100% on-chain!",',
            '"image": "https://cdn.betterttv.net/emote/5a16ee718c22a247ead62d4a/3x.webp"',
            "}"
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(json)));
    }
}
