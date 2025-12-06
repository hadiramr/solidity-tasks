// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Marketplace {
    address public owner;
    uint256 public commissionBP; // commission in basis points (e.g. 250 = 2.5%)
    uint256 public nextProductId;
    uint256 public nextOrderId;

    constructor(uint256 _commissionBP) {
        owner = msg.sender;
        commissionBP = _commissionBP;
    }


    struct Product {
        uint256 id;
        address seller;
        string name;
        uint256 price;   // price per unit in wei
        uint256 stock;
        uint256 sold;
        bool isActive;
    }

    enum OrderStatus {
        Pending,
        Paid,
        Shipped,
        Cancelled
    }

    struct Order {
        uint256 id;
        uint256 productId;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalPaid;
        OrderStatus status;
    }

    mapping(uint256 => Product) public products;      // productId => Product
    mapping(uint256 => Order) public orders;          // orderId => Order
    mapping(address => uint256) public sellerEarnings;
    mapping(address => uint256) public sellerSalesCount;

    uint256 public ownerBalance;

    event ProductListed(
        uint256 indexed productId,
        address indexed seller,
        string name,
        uint256 price,
        uint256 stock
    );

    event OrderCreated(
        uint256 indexed orderId,
        uint256 indexed productId,
        address indexed buyer,
        uint256 quantity,
        uint256 totalPaid
    );

    event EarningsWithdrawn(address indexed seller, uint256 amount);
    event OwnerWithdrawn(uint256 amount);


    modifier onlyOwner() {
        require(msg.sender == owner, "Not marketplace owner");
        _;
    }


    function listItem(
        string calldata name,
        uint256 price,
        uint256 stock
    ) external {
        require(price > 0, "Invalid price");
        require(stock > 0, "Invalid stock");

        products[nextProductId] = Product({
            id: nextProductId,
            seller: msg.sender,
            name: name,
            price: price,
            stock: stock,
            sold: 0,
            isActive: true
        });

        emit ProductListed(
            nextProductId,
            msg.sender,
            name,
            price,
            stock
        );

        nextProductId++;
    }

    
    function buy(uint256 productId, uint256 quantity)
        external
        payable
    {
        Product storage product = products[productId];

        require(product.isActive, "Product inactive");
        require(quantity > 0, "Invalid quantity");
        require(product.stock >= quantity, "Not enough stock");

        uint256 totalPrice = product.price * quantity;
        require(msg.value >= totalPrice, "Not enough ETH sent");

        // commission calculation
        uint256 commission = (totalPrice * commissionBP) / 10000;
        uint256 sellerAmount = totalPrice - commission;

        // Effects
        product.stock -= quantity;
        product.sold += quantity;

        sellerEarnings[product.seller] += sellerAmount;
        sellerSalesCount[product.seller] += quantity;
        ownerBalance += commission;

        // Create order
        orders[nextOrderId] = Order({
            id: nextOrderId,
            productId: productId,
            buyer: msg.sender,
            seller: product.seller,
            quantity: quantity,
            totalPaid: totalPrice,
            status: OrderStatus.Paid
        });

        emit OrderCreated(
            nextOrderId,
            productId,
            msg.sender,
            quantity,
            totalPrice
        );

        nextOrderId++;

        // Refund extra ETH automatically
        if (msg.value > totalPrice) {
            uint256 refund = msg.value - totalPrice;
            (bool success, ) = payable(msg.sender).call{value: refund}("");
            require(success, "Refund failed");
        }
    }

    
    function withdrawEarnings() external {
        uint256 amount = sellerEarnings[msg.sender];
        require(amount > 0, "No earnings");

        // Checks → Effects → Interactions
        sellerEarnings[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");

        emit EarningsWithdrawn(msg.sender, amount);
    }

    
    function withdrawOwner() external onlyOwner {
        uint256 amount = ownerBalance;
        require(amount > 0, "No commission");

        ownerBalance = 0;

        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Owner withdraw failed");

        emit OwnerWithdrawn(amount);
    }

    
    function getProduct(uint256 productId)
        external
        view
        returns (Product memory)
    {
        return products[productId];
    }

    function getOrder(uint256 orderId)
        external
        view
        returns (Order memory)
    {
        return orders[orderId];
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
}
