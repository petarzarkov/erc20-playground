// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { PeepoMultiToken } from "../src/PeepoMultiToken.sol";
import { BaseScript } from "./Base.s.sol";
import { console2 } from "forge-std/src/console2.sol";

contract DeployMulti is BaseScript {
  function run() public broadcast returns (PeepoMultiToken multi) {
    multi = new PeepoMultiToken();

    // Mint 3 different editions
    multi.mint(msg.sender, 1, 100); // 1x.webp
    multi.mint(msg.sender, 2, 50); // 2x.webp
    multi.mint(msg.sender, 3, 10); // 3x.webp

    console2.log("PeepoMultiToken deployed at:", address(multi));
  }
}
