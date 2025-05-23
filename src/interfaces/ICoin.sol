// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.23;

/* 
    !!!         !!!         !!!    
    !!!         !!!         !!!    
    !!!         !!!         !!!    
    !!!         !!!         !!!    
    !!!         !!!         !!!    
    !!!         !!!         !!!    

    WOW         WOW         WOW    
*/
interface ICoin {
    /// @notice Thrown when an operation is attempted with a zero address
    error AddressZero();

    /// @notice Thrown when an invalid market type is specified
    error InvalidMarketType();

    /// @notice Thrown when there are insufficient funds for an operation
    error InsufficientFunds();

    /// @notice Thrown when there is insufficient liquidity for a transaction
    error InsufficientLiquidity();

    /// @notice Thrown when the slippage bounds are exceeded during a transaction
    error SlippageBoundsExceeded();

    /// @notice Thrown when the initial order size is too large
    error InitialOrderSizeTooLarge();

    /// @notice Thrown when the ETH amount is too small for a transaction
    error EthAmountTooSmall();

    /// @notice Thrown when an ETH transfer fails
    error EthTransferFailed();

    /// @notice Thrown when an operation is attempted by an entity other than the pool
    error OnlyPool();

    /// @notice Thrown when an operation is attempted by an entity other than WETH
    error OnlyWeth();

    /// @notice Thrown when a market is not yet graduated
    error MarketNotGraduated();

    /// @notice Thrown when a market is already graduated
    error MarketAlreadyGraduated();

    /// @notice Thrown when the tick lower is not less than the maximum tick or not a multiple of 200
    error InvalidTickLower();

    /// @notice Represents the type of market
    enum MarketType {
        BONDING_CURVE,
        UNISWAP_POOL
    }

    /// @notice Represents the state of the market
    struct MarketState {
        MarketType marketType;
        address marketAddress;
    }

    /// @notice The rewards accrued from the market's liquidity position
    struct MarketRewards {
        uint256 totalAmountCurrency;
        uint256 totalAmountCoin;
        uint256 creatorPayoutAmountCurrency;
        uint256 creatorPayoutAmountCoin;
        uint256 platformReferrerAmountCurrency;
        uint256 platformReferrerAmountCoin;
        uint256 protocolAmountCurrency; 
        uint256 protocolAmountCoin;
    }

    /// @notice Emitted when market rewards are distributed
    /// @param creatorPayoutAddress The address of the creator payout recipient
    /// @param platformReferrer The address of the platform referrer
    /// @param protocolRewardRecipient The address of the protocol reward recipient
    /// @param currency The address of the currency
    /// @param marketRewards The rewards accrued from the market's liquidity position
    event CoinMarketRewards(
        address indexed creatorPayoutAddress,
        address indexed platformReferrer,
        address protocolRewardRecipient,
        address currency,
        MarketRewards marketRewards
    );

    /// @notice Emitted when a Wow token is bought
    /// @param buyer The address of the buyer
    /// @param recipient The address of the recipient
    /// @param orderReferrer The address of the order referrer
    /// @param totalEth The total ETH involved in the transaction
    /// @param ethFee The ETH fee for the transaction
    /// @param ethSold The amount of ETH sold
    /// @param tokensBought The number of tokens bought
    /// @param buyerTokenBalance The token balance of the buyer after the transaction
    /// @param comment A comment associated with the transaction
    /// @param totalSupply The total supply of tokens after the buy
    /// @param marketType The type of market
    event WowTokenBuy(
        address indexed buyer,
        address indexed recipient,
        address indexed orderReferrer,
        uint256 totalEth,
        uint256 ethFee,
        uint256 ethSold,
        uint256 tokensBought,
        uint256 buyerTokenBalance,
        string comment,
        uint256 totalSupply,
        MarketType marketType
    );

    /// @notice Emitted when coins are bought
    /// @param buyer The address of the buyer
    /// @param recipient The address of the recipient
    /// @param orderReferrer The address of the order referrer
    /// @param coinsPurchased The number of coins purchased
    /// @param currency The address of the currency
    /// @param amountFee The fee for the purchase
    /// @param amountSold The amount of the currency sold
    /// @param comment A comment associated with the purchase
    event CoinBuy(
        address indexed buyer,
        address indexed recipient,
        address indexed orderReferrer,
        uint256 coinsPurchased,
        address currency,
        uint256 amountFee,
        uint256 amountSold,
        string comment
    );

    /// @notice Emitted when a Wow token is sold
    /// @param seller The address of the seller
    /// @param recipient The address of the recipient
    /// @param orderReferrer The address of the order referrer
    /// @param totalEth The total ETH involved in the transaction
    /// @param ethFee The ETH fee for the transaction
    /// @param ethBought The amount of ETH bought
    /// @param tokensSold The number of tokens sold
    /// @param sellerTokenBalance The token balance of the seller after the transaction
    /// @param comment A comment associated with the transaction
    /// @param totalSupply The total supply of tokens after the sell
    /// @param marketType The type of market
    event WowTokenSell(
        address indexed seller,
        address indexed recipient,
        address indexed orderReferrer,
        uint256 totalEth,
        uint256 ethFee,
        uint256 ethBought,
        uint256 tokensSold,
        uint256 sellerTokenBalance,
        string comment,
        uint256 totalSupply,
        MarketType marketType
    );

    /// @notice Emitted when coins are sold
    /// @param seller The address of the seller
    /// @param recipient The address of the recipient
    /// @param orderReferrer The address of the order referrer
    /// @param coinsSold The number of coins sold
    /// @param currency The address of the currency
    /// @param amountFee The fee for the sale
    /// @param amountPurchased The amount of the currency purchased
    /// @param comment A comment associated with the sale
    event CoinSell(
        address indexed seller,
        address indexed recipient,
        address indexed orderReferrer,
        uint256 coinsSold,
        address currency,
        uint256 amountFee,
        uint256 amountPurchased,
        string comment
    );

    /// @notice Emitted when Wow tokens are transferred
    /// @param from The address of the sender
    /// @param to The address of the recipient
    /// @param amount The amount of tokens transferred
    /// @param fromTokenBalance The token balance of the sender after the transfer
    /// @param toTokenBalance The token balance of the recipient after the transfer
    /// @param totalSupply The total supply of tokens after the transfer
    event WowTokenTransfer(
        address indexed from,
        address indexed to,
        uint256 amount,
        uint256 fromTokenBalance,
        uint256 toTokenBalance,
        uint256 totalSupply
    );

    /// @notice Emitted when a coin is transferred
    /// @param sender The address of the sender
    /// @param recipient The address of the recipient
    /// @param amount The amount of coins
    /// @param senderBalance The balance of the sender after the transfer
    /// @param recipientBalance The balance of the recipient after the transfer
    event CoinTransfer(
        address indexed sender,
        address indexed recipient,
        uint256 amount,
        uint256 senderBalance,
        uint256 recipientBalance
    );

    /// @notice Emitted when fees are distributed
    /// @param tokenCreator The address of the token creator
    /// @param platformReferrer The address of the platform referrer
    /// @param orderReferrer The address of the order referrer
    /// @param protocolFeeRecipient The address of the protocol fee recipient
    /// @param tokenCreatorFee The fee for the token creator
    /// @param platformReferrerFee The fee for the platform referrer
    /// @param orderReferrerFee The fee for the order referrer
    /// @param protocolFee The protocol fee
    event WowTokenFees(
        address indexed tokenCreator,
        address indexed platformReferrer,
        address indexed orderReferrer,
        address protocolFeeRecipient,
        uint256 tokenCreatorFee,
        uint256 platformReferrerFee,
        uint256 orderReferrerFee,
        uint256 protocolFee
    );

    /// @notice Emitted when trade rewards are distributed
    /// @param creatorPayoutRecipient The address of the creator payout recipient
    /// @param platformReferrer The address of the platform referrer
    /// @param orderReferrer The address of the order referrer
    /// @param protocolRewardRecipient The address of the protocol reward recipient
    /// @param creatorReward The reward for the creator
    /// @param platformReferrerReward The reward for the platform referrer
    /// @param orderReferrerReward The reward for the order referrer
    /// @param protocolReward The reward for the protocol
    /// @param currency The address of the currency
    event CoinTradeRewards(
        address indexed creatorPayoutRecipient,
        address indexed platformReferrer,
        address indexed orderReferrer,
        address protocolRewardRecipient,
        uint256 creatorReward,
        uint256 platformReferrerReward,
        uint256 orderReferrerReward,
        uint256 protocolReward,
        address currency
    );

    /// @notice Emitted when a market graduates
    /// @param tokenAddress The address of the token
    /// @param poolAddress The address of the pool
    /// @param totalEthLiquidity The total ETH liquidity in the pool
    /// @param totalTokenLiquidity The total token liquidity in the pool
    /// @param lpPositionId The ID of the liquidity position
    /// @param marketType The type of market
    event WowMarketGraduated(
        address indexed tokenAddress,
        address indexed poolAddress,
        uint256 totalEthLiquidity,
        uint256 totalTokenLiquidity,
        uint256 lpPositionId,
        MarketType marketType
    );

    /// @notice Executes an order to buy coins with ETH
    /// @param recipient The recipient address of the coins
    /// @param orderReferrer The address of the order referrer
    /// @param comment A comment associated with the buy order
    /// @param minOrderSize The minimum coins to prevent slippage
    /// @param sqrtPriceLimitX96 The price limit for Uniswap V3 pool swap
    function buy(
        address recipient,
        address /* refundRecipient - deprecated */,
        address orderReferrer,
        string memory comment,
        MarketType /* expectedMarketType - deprecated */,
        uint256 minOrderSize,
        uint160 sqrtPriceLimitX96
    ) external payable returns (uint256);

    /// @notice Executes an order to sell coins for ETH
    /// @param amount The number of coins to sell
    /// @param recipient The address to receive the ETH
    /// @param orderReferrer The address of the order referrer
    /// @param comment A comment associated with the sell order
    /// @param minPayoutSize The minimum ETH payout to prevent slippage
    /// @param sqrtPriceLimitX96 The price limit for Uniswap V3 pool swap
    function sell(
        uint256 amount,
        address recipient,
        address orderReferrer,
        string memory comment,
        MarketType /* expectedMarketType - deprecated */,
        uint256 minPayoutSize,
        uint160 sqrtPriceLimitX96
    ) external returns (uint256);

    /// @notice Enables a user to burn their tokens
    /// @param amount The amount of tokens to burn
    function burn(uint256 amount) external;

    /// @notice Returns the current state of the market
    /// @return The market state
    function state() external view returns (MarketState memory);

    /// @notice Returns the URI of the token
    /// @return The token URI
    function tokenURI() external view returns (string memory);

    /// @notice Returns the address of the token creator
    /// @return The token creator's address
    function tokenCreator() external view returns (address);

    /// @notice Returns the address of the platform referrer
    /// @return The platform referrer's address
    function platformReferrer() external view returns (address);
}
