/*
*  __  __               _
* |  \/  |_ __ ___   __| |_ __ ______ _
* | |\/| | '_ ` _ \ / _` | '__|_  / _` |
* | |  | | | | | | | (_| | |   / / (_| |
* |_|  |_|_| |_| |_|\__,_|_|  /___\__,_|
*
* Programmer Mmdrza
* Web Mmdrza.Com
* Email X4@Mmdrza.Com
* Dev.to/Mmdrza
* Github.Com/Pymmdrza
* 
* /////////////////////////////
* Optimization: [No]
* License: [None]
* Compiler version: [solidity 0.5.4]
* Network: [TRC20 - ERC20 ]
*//////////////////////////////


pragma solidity ^0.5.4;


interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    mapping (address => uint) public _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals, uint totalSupply) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = totalSupply;
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
    function balanceOf(address account) public view returns (uint) {
        return _balances[account];
    }
    function transfer(address recipient, uint amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _transfer(address sender, address recipient, uint amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _burn(address account, uint amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}


library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeERC20 {
    using SafeMath for uint;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract SingleToken is ERC20 {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint;
  
 
  constructor () public ERC20("SingleToken1", "SNG1", 18, 1022000000*10**18) {
       _balances[msg.sender] = totalSupply();
        emit Transfer(address(0), msg.sender, totalSupply());
  }


}



Cover image for Ethereum and BNB Wallet Generator , Balance Check
EditManageStats
MMDRZA profile imageMMDRZA
MMDRZA for MMDRZA
Posted on Mar 15

Ethereum and BNB Wallet Generator , Balance Check
Ethereum Wallet Address and Private Key Generated With Python And Check Balance On ethersan and BSCscan With APIKEY :
First install This Package On CMD or Terminal
pip install colorama
pip install hdwallet
for apikey follow this site :
Etherscan (ETHEREUM)
BNB(BSC)
mmdrza = '''

=========================[M M D Z A . C o M]==============================
             _ __ ___  _ __ ___   __| |_ __ ______ _
            | '_ ` _ \| '_ ` _ \ / _` | '__|_  / _` |
            | | | | | | | | | | | (_| | |   / / (_| |
            |_| |_| |_|_| |_| |_|\__,_|_|  /___\__,_|
=========================[M M D Z A . C o M]==============================
= Athur : MMDRZA
= Email : x4@Mmdrza.Com
= Web : https://Mmdrza.Com
= Dev.to/mmdrza
= Github.Com/Pymmdrza
=========================[M M D Z A . C o M]==============================
= Donat = Bitcoin 16p9y6EstGYcnofGNvUJMEGKiAWhAr1uR8
=========================[M M D Z A . C o M]==============================
        '''

from hdwallet import HDWallet
from hdwallet.symbols import ETH as SYMBOL
import random
import requests
import json
from colorama import Fore, Style
import time

# =========================[M M D Z A . C o M]==============================
print(Fore.GREEN,mmdrza,Style.RESET_ALL)
print('Start ...')
time.sleep(5)
# =========================[M M D Z A . C o M]==============================
z = 1
while True:
    c1 = str(random.choice('0123456789abcdefABCDEF'))
    c2 = str(random.choice('0123456789abcdefABCDEF'))
    c3 = str(random.choice('0123456789abcdefABCDEF'))
    c4 = str(random.choice('0123456789abcdefABCDEF'))
    c5 = str(random.choice('0123456789abcdefABCDEF'))
    c6 = str(random.choice('0123456789abcdefABCDEF'))
    c7 = str(random.choice('0123456789abcdefABCDEF'))
    c8 = str(random.choice('0123456789abcdefABCDEF'))
    c9 = str(random.choice('0123456789abcdefABCDEF'))
    c10 = str(random.choice('0123456789abcdefABCDEF'))
    c11 = str(random.choice('0123456789abcdefABCDEF'))
    c12 = str(random.choice('0123456789abcdefABCDEF'))
    c13 = str(random.choice('0123456789abcdefABCDEF'))
    c14 = str(random.choice('0123456789abcdefABCDEF'))
    c15 = str(random.choice('0123456789abcdefABCDEF'))
    c16 = str(random.choice('0123456789abcdefABCDEF'))
    c17 = str(random.choice('0123456789abcdefABCDEF'))
    c18 = str(random.choice('0123456789abcdefABCDEF'))
    c19 = str(random.choice('0123456789abcdefABCDEF'))
    c20 = str(random.choice('0123456789abcdefABCDEF'))
    c21 = str(random.choice('0123456789abcdefABCDEF'))
    c22 = str(random.choice('0123456789abcdefABCDEF'))
    c23 = str(random.choice('0123456789abcdefABCDEF'))
    c24 = str(random.choice('0123456789abcdefABCDEF'))
    c25 = str(random.choice('0123456789abcdefABCDEF'))
    c26 = str(random.choice('0123456789abcdefABCDEF'))
    c27 = str(random.choice('0123456789abcdefABCDEF'))
    c28 = str(random.choice('0123456789abcdefABCDEF'))
    c29 = str(random.choice('0123456789abcdefABCDEF'))
    c30 = str(random.choice('0123456789abcdefABCDEF'))
    c31 = str(random.choice('0123456789abcdefABCDEF'))
    c32 = str(random.choice('0123456789abcdefABCDEF'))
    c33 = str(random.choice('0123456789abcdefABCDEF'))
    c34 = str(random.choice('0123456789abcdefABCDEF'))
    c35 = str(random.choice('0123456789abcdefABCDEF'))
    c36 = str(random.choice('0123456789abcdefABCDEF'))
    c37 = str(random.choice('0123456789abcdefABCDEF'))
    c38 = str(random.choice('0123456789abcdefABCDEF'))
    c39 = str(random.choice('0123456789abcdefABCDEF'))
    c40 = str(random.choice('0123456789abcdefABCDEF'))
    c41 = str(random.choice('0123456789abcdefABCDEF'))
    c42 = str(random.choice('0123456789abcdefABCDEF'))
    c43 = str(random.choice('0123456789abcdefABCDEF'))
    c44 = str(random.choice('0123456789abcdefABCDEF'))
    c45 = str(random.choice('0123456789abcdefABCDEF'))
    c46 = str(random.choice('0123456789abcdefABCDEF'))
    c47 = str(random.choice('0123456789abcdefABCDEF'))
    c48 = str(random.choice('0123456789abcdefABCDEF'))
    c49 = str(random.choice('0123456789abcdefABCDEF'))
    c50 = str(random.choice('0123456789abcdefABCDEF'))
    c51 = str(random.choice('0123456789abcdefABCDEF'))
    c52 = str(random.choice('0123456789abcdefABCDEF'))
    c53 = str(random.choice('0123456789abcdefABCDEF'))
    c54 = str(random.choice('0123456789abcdefABCDEF'))
    c55 = str(random.choice('0123456789abcdefABCDEF'))
    c56 = str(random.choice('0123456789abcdefABCDEF'))
    c57 = str(random.choice('0123456789abcdefABCDEF'))
    c58 = str(random.choice('0123456789abcdefABCDEF'))
    c59 = str(random.choice('0123456789abcdefABCDEF'))
    c60 = str(random.choice('0123456789abcdefABCDEF'))
    c61 = str(random.choice('0123456789abcdefABCDEF'))
    c62 = str(random.choice('0123456789abcdefABCDEF'))
    c63 = str(random.choice('0123456789abcdefABCDEF'))
    c64 = str(random.choice('0123456789abcdefABCDEF'))
    magic = (c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10 + c11 + c12 + c13 + c14 + c15 + c16 + c17 + c18 + c19 + c20 + c21 + c22 + c23 + c24 + c25 + c26 + c27 + c28 + c29 + c30 + c31 + c32 + c33 + c34 + c35 + c36 + c37 + c38 + c39 + c40 + c41 + c42 + c43 + c44 + c45 + c46 + c47 + c48 + c49 + c50 + c51 + c52 + c53 + c54 + c55 + c56 + c57 + c58 + c59 + c60 + c61 + c62 + c63 + c64)
    # Start API
    # =========================[M M D Z A . C o M]==============================
    api1 = "&apikey=ENTER-YOUR-API-EtherScan.iO"
    api2 = "&apikey=ENTER-YOUR-API-EtherScan.iO"
    api3 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api4 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api5 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api6 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api7 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api8 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api9 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api10 = "&apiKey=ENTER-YOUR-API-EtherScan.iO"
    api11 = "&apiKey=UYUY9G3NBU8RU89D3SAREY9Q92BV31IC56"
    api12 = "&apiKey=FH5MNBV4XZH6TU4E2VE8FH9FEBVW1VF61N"
    # =========================[M M D Z A . C o M]==============================
    bapi1 = "&apikey=ENTER-YOUR-API-BSCSCAN.iO"
    bapi2 = "&apikey=ENTER-YOUR-API-BSCSCAN.iO"
    bapi3 = "&apiKey=ENTER-YOUR-API-BSCSCAN.iO"
    bapi4 = "&apiKey=ENTER-YOUR-API-BSCSCAN.iO"
    bapi5 = "&apiKey=ENTER-YOUR-API-BSCSCAN.iO"
    bapi6 = "&apiKey=ENTER-YOUR-API-BSCSCAN.iO"
    mylist1 = [str(bapi1), str(bapi2), str(bapi3), str(bapi4), str(bapi5), str(bapi6)]
    apikeysbnb = random.choice(mylist1)
    # =======================[M M D Z A . C o M]================================
    mylist = [str(api1), str(api2), str(api3), str(api4), str(api10), str(api11), str(api12),str(api5), str(api6), str(api7), str(api8), str(api9)]
    # =========================[M M D Z A . C o M]==============================
    apikeys = random.choice(mylist)
    # =========================[M M D Z A . C o M]==============================
    PRIVATE_KEY = str(magic)
    hdwallet: HDWallet = HDWallet(symbol=SYMBOL)
    hdwallet.from_private_key(private_key=PRIVATE_KEY)
    privatekey = hdwallet.private_key()
    ethaddr = hdwallet.p2pkh_address()  # 0xEF3589b72bd2f2e539843aa0Af67FEd18906A761
    blocs = requests.get("https://api.etherscan.io/api?module=account&action=balance&address=" + ethaddr + apikeys)
    ress = blocs.json()
    baleth = dict(ress)["result"]
    blocs1 = requests.get("https://api.bscscan.com/api?module=account&action=balance&address=" + ethaddr + apikeysbnb)
    ress1 = blocs1.json()
    balbnb = dict(ress1)["result"]
    # =========================[M M D Z A . C o M]==============================
    print(str(z),Fore.YELLOW,'ADDR =',Fore.WHITE,str(ethaddr),Fore.YELLOW,'PRIV =',Fore.GREEN,str(privatekey),Fore.RED,'[ ETH=',str(baleth),'BNB=',str(balbnb),']')
    z += 1
    # =========================[M M D Z A . C o M]==============================
    if int(balbnb) or int(baleth) > 0:
        print('Win Wallet --------- Save On Text File --------')
        print('----------------------[M M D Z A . C o M]----------------------')
        print('Address =>', ethaddr)
        print('PrivateKey =>', privatekey)
        f = open("ETHxBNB.txt","a")
        f.write('\nAddress = ' + ethaddr)
        f.write('\nPrivate = ' + privatekey)
        f.write('\n===================================[M M D Z A . C o M]===================================')
        f.close()
        continue



*/
* =========================[M M D Z A . C o M]==============================
* Programmer M M D R Z A 
* Web Mmdrza.Com
* Dev.to/Mmdrza
* Github.Com/Pymmdrza
* Donate = Bitcoin 16p9y6EstGYcnofGNvUJMEGKiAWhAr1uR8
* =========================[M M D Z A . C o M]========================
*/
