// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { PeepoToken } from "../src/PeepoToken.sol";

import { BaseScript } from "./Base.s.sol";

contract Deploy is BaseScript {
  function run() public broadcast returns (PeepoToken peepoToken) {
    uint256 initialSupply = 0.1 ether;
    peepoToken = new PeepoToken(initialSupply);
  }
}
