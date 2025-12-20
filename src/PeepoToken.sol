// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PeepoToken
 * @notice A simple ERC20 token that can be minted by the owner
 * @author Petar Zarkov
 */
contract PeepoToken is ERC20, Ownable {
  /**
   * @dev Constructor
   * @param initialSupply The initial supply of the token
   * @notice The owner is the initial minter
   */
  constructor(uint256 initialSupply) ERC20("PeepoToken", "PEEP") Ownable(msg.sender) {
    _mint(msg.sender, initialSupply);
  }

  /**
   * @dev Mint more tokens (only owner)
   * @param to The address to mint the tokens to
   * @param amount The amount of tokens to mint
   * @notice Only the owner can mint tokens
   */
  function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
  }
}
