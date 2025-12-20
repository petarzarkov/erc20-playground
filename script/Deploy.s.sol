// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { console2 } from "forge-std/src/console2.sol";
import { PeepoToken } from "../src/PeepoToken.sol";
import { PeepoNFT } from "../src/PeepoNFT.sol";
import { BaseScript } from "./Base.s.sol";

/**
 * @title Deploy
 * @notice Dynamic deployment script for Peepo tokens
 */
contract Deploy is BaseScript {
  function run() public broadcast returns (PeepoToken peepoToken, PeepoNFT peepoNft) {
    // --- ERC-20 Deployment ---
    uint256 initialSupply = vm.envOr("INITIAL_SUPPLY", uint256(0.1 ether));
    peepoToken = new PeepoToken(initialSupply);

    // --- ERC-721 Deployment ---
    peepoNft = new PeepoNFT();

    // Mint initial NFT to the broadcaster (who is the owner)
    peepoNft.safeMint(msg.sender);

    console2.log("---------------------------");
    console2.log("PeepoToken deployed at:", address(peepoToken));
    console2.log("PeepoNFT deployed at:", address(peepoNft));
    console2.log("Initial NFT Minted to:", msg.sender);
    console2.log("---------------------------");
  }
}
