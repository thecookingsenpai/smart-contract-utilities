//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "./heritage/uniswap_interfaces.sol";

contract smart {
    address router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapRouter02 router = IUniswapRouter02(router_address);

    function create_weth_pair(address token) private returns (address, IUniswapV2Pair) {
       address pair_address = IUniswapFactory(router.factory()).createPair(token, router.WETH());
       return (pair_address, IUniswapV2Pair(pair_address));
    }

    function get_weth_reserve(address pair_address) private  view returns(uint, uint) {
        IUniswapV2Pair pair = IUniswapV2Pair(pair_address);
        uint112 token_reserve;
        uint112 native_reserve;
        uint32 last_timestamp;
        (token_reserve, native_reserve, last_timestamp) = pair.getReserves();
        return (token_reserve, native_reserve);
    }

    function get_weth_price_impact(address token, uint amount, bool sell) private view returns(uint) {
        address pair_address = IUniswapFactory(router.factory()).getPair(token, router.WETH());
        (uint res_token, uint res_weth) = get_weth_reserve(pair_address);
        uint impact;
        if(sell) {
            impact = (amount * 100) / res_token;
        } else {
            impact = (amount * 100) / res_weth;
        }
        return impact;
    }
}

