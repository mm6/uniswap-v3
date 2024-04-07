// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

contract SimpleSwap {
    ISwapRouter public immutable swapRouter;
    uint24 public constant feeTier = 3000;
    
    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }
    
    function swapERCforERC(address from, address to, uint amountIn) external returns (uint256 amountOut) {

        // Transfer the specified amount of ERC to this contract.
        TransferHelper.safeTransferFrom(from, msg.sender, address(this), amountIn);
        // Approve the router to spend ERC.
        TransferHelper.safeApprove(from, address(swapRouter), amountIn);
        // Create the params that will be used to execute the swap
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: from,
                tokenOut: to,
                fee: feeTier,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
        return amountOut; 
    }
}
