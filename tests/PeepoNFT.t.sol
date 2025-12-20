// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { Test } from "forge-std/src/Test.sol";

import { PeepoNFT } from "../src/PeepoNFT.sol";

/**
 * @title PeepoNFTTest
 * @notice Tests for the on-chain PeepoNFT contract
 */
contract PeepoNFTTest is Test {
  PeepoNFT public nft;
  address public owner = address(1);
  address public user = address(2);

  function setUp() public {
    vm.prank(owner);
    nft = new PeepoNFT();
  }

  /**
   * @notice Verifies that the owner can mint and the recipient receives the NFT
   */
  function test_Mint() public {
    vm.prank(owner);
    nft.safeMint(user);
    assertEq(nft.ownerOf(1), user);
    assertEq(nft.balanceOf(user), 1);
  }

  /**
   * @notice Verifies that non-owners cannot mint
   */
  function test_OnlyOwnerCanMint() public {
    vm.prank(user);
    vm.expectRevert(); // Should revert because of Ownable
    nft.safeMint(user);
  }

  /**
   * @notice Validates that tokenURI correctly generates on-chain JSON
   */
  function test_TokenURI() public {
    vm.prank(owner);
    nft.safeMint(user);

    string memory uri = nft.tokenURI(1);
    string memory expectedPrefix = "data:application/json;base64,";

    // Extract the first 29 bytes manually to avoid the slicing error
    bytes memory uriBytes = bytes(uri);
    bytes memory prefixBytes = new bytes(29);

    for (uint256 i = 0; i < 29; ++i) {
      prefixBytes[i] = uriBytes[i];
    }

    // Convert back to string for comparison
    assertEq(string(prefixBytes), expectedPrefix, "URI prefix mismatch");
  }

  /**
   * @notice Ensures each token has a unique URI (different names/IDs)
   */
  function test_UniqueTokenURIs() public {
    vm.startPrank(owner);
    nft.safeMint(user); // ID 1
    nft.safeMint(user); // ID 2
    vm.stopPrank();

    bytes32 uri0Hash = keccak256(abi.encodePacked(nft.tokenURI(1)));
    bytes32 uri1Hash = keccak256(abi.encodePacked(nft.tokenURI(2)));

    assertTrue(uri0Hash != uri1Hash, "Token URIs should be unique");
  }
}
