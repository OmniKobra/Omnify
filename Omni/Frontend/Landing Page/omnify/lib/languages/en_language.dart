// ignore_for_file: camel_case_types, annotate_overrides

import 'app_language.dart';

class EN_Language implements AppLanguage {
  final String home1 = "Home";
  final String home2 = "Explorer";
  final String home3 = "Governance";
  final String home4 = "Fees";
  final String home5 = "  Launch app  ";
  final String home6 = "Connect wallet";
  final String home7 = "New proposal";
  final String home8 = "Connected";
  final String home9 = "Coins";
  final String carTitle0 = "Omnify";
  final String carTitle1 = "Omni Transfer";
  final String carTitle2 = "Omni Trust";
  final String carTitle3 = "Omni Bridge";
  final String carTitle4 = "Omni Lottery";
  final String carTitle5 = "Omni Loans";
  final String carTitle6 = "Omni Governance";
  final String carTitle7 = "Omni Pay";
  final String carTitle8 = "Omni Escrow";
  final String carTitle9 = "Omni Refuel";
  final carDescription0 =
      "Omnify hosts a multi-chain suite of defi products and services faciliating seamless transactions through the security of smart contracts.";
  final carDescription1 =
      "Use Omnify's transfers to throttle, multi-send, and mediate your transfers";
  final carDescription2 =
      "Full-scale payments hub covering all your payment needs: pay and get paid in full, or in installments with OmniPay";
  final carDescription3 =
      "Create your own deposit with ERC20 compatible or native tokens on OmniTrust. Add beneficiaries with or without a specific allowance";
  final carDescription4 =
      "Migrate or return bridged tokens between Avalanche, Optimism, Binance Smart Chain, Fantom, Mantle, Gnosis, Celo, Tron, Arbitrum, Polygon, Base, Linea, Scroll, Blast, and ZKsync.\nUses lock and mint / burn on return functionality";
  final carDescription5 = "LOTTERY ";
  final carDescription6 = "LOANS ";
  final carDescription7 =
      "Participate in Omnify's governance and get a cut of its collected fees by holding its utility token: \$OFY";
  final carDescription8 =
      "Create new escrow contracts to offer assets and receive bids or place bids on existing contracts";
  final carDescription9 =
      "Running low on native gas token? We've got you covered. Get gas tokens by swapping local ERC20 compatible coins or by swapping another network's gas token (Refueler is in development) ";
  final transferCard1 = "Instant settlement (same transaction)";
  final transferCard2 = "Uncapped ERC20 compatible coin transfers";
  final transferCard3 = "Uncapped native token transfers";
  final transferCard4 = "Multiple unique recipients";
  final transferCard5 =
      "Smart contract supports unlimited number of transfers in same transaction";
  final payCard1 = "One-time payments";
  final payCard2 = "Downpayments";
  final payCard3 = "Monthly installments (max. 10 years)";
  final payCard4 = "Instant revenue withdrawals with 0.00% fees";
  final payCard5 = "Payments Gateway api (redirect via url)";
  final payCard6 = "Scan to Pay";
  final trustCard1 = "Specify who has owner privileges to modify the deposit";
  final trustCard2 =
      "Retractable deposits can be retracted by any of the owners";
  final trustCard3 =
      "Modifiable deposits can be modified (add funds, add or remove beneficiaries, modify beneficiary allowance)";
  final trustCard4 = "Deposits should be marked active to start withdrawing";
  final trustCard5 = "Specified allowance can be withdrawn once per day";
  final bridgeCard1 = "Supports any ERC20 compatible asset";
  final bridgeCard2 = "Lock assets on source network";
  final bridgeCard3 = "Mint assets on destination network";
  final bridgeCard4 =
      "Burn bridged tokens when returning assets to source chain";
  final bridgeCard5 = "1:1 peg between source and OFY bridged assets";
  final escrowCard1 = "Instant agreement settlement on completion";
  final escrowCard2 = "Accepted bidder receives assets offered in contract";
  final escrowCard3 = "Owner receives bidder's offered assets";
  final escrowCard4 = "Unlimited contracts per address";
  final escrowCard5 = "1 bid per address on the same contract";
  final refuelCard1 = "Cross-chain gas token swap";
  final refuelCard2 = "ERC20 gas token swap";
  final theme0 = "Bright mode";
  final theme1 = "Dark mode";
  final theme3 = "Docs";
  final avalancheDescription =
      "Avalanche is a smart contracts platform that scales infinitely and regularly finalizes transactions in less than one second.";
  final optimismDescription =
      "OP Mainnet is a Layer 2 Optimistic Rollup network designed to utilize the strong security guarantees of Ethereum while reducing its cost and latency.";
  final ethereumDescription =
      "Ethereum is a technology that's home to digital money, global payments, and applications.";
  final bscDescription =
      "Binance Smart Chain (BSC) is a blockchain network launched by Binance in September 2020.";
  final arbitrumDescription =
      "Arbitrum is the leading Layer 2 technology that empowers you to explore and build in the largest Layer 1 ecosystem, Ethereum.";
  final polygonDescription =
      "Polygon is a blockchain platform which aims to create a multi-chain blockchain system compatible with Ethereum.";
  final fantomDescription =
      "Fantom is a highly scalable blockchain platform for DeFi, crypto dApps, and enterprise applications.";
  final tronDescription =
      "TRON is a decentralized, blockchain-based operating system with smart contract functionality, proof-of-stake principles as its consensus algorithm and a cryptocurrency native to the system, known as Tronix (TRX).";
  final baseDescription =
      "Base is an Ethereum Layer 2 solution developed by cryptocurrency exchange Coinbase, in partnership with Optimism to provide a secure, cost-effective and developer-friendly environment to build on-chain applications.";
  final lineaDescription =
      "Linea is designed to streamline blockchain adoption for businesses, emphasizing ease of use, scalability, and security. It supports a wide range of enterprise applications, from finance to supply chain.";
  final cronosDescription =
      "Cronos is a blockchain-based operating system with smart contract functionality, proof-of-stake principles as its consensus algorithm and a cryptocurrency native to the system, known as CRO.";
  final mantleDescription =
      "Mantle Network is a Layer-2 scaling solution compatible with Ethereum Virtual Machine (EVM).";
  final gnosisDescription =
      "Gnosis is a collective of aligned projects revolutionizing payments infrastructure to make decentralized financial tools accessible and usable for all.";
  final kavaDescription =
      "Kava is a decentralized blockchain platform that combines the fast transaction speeds of Cosmos with Ethereum's developer-friendly environment.";
  final roninDescription =
      "Ronin Network is an EVM (Ethereum Virtual Machine)-compatible blockchain forged for gaming.";
  final zksyncDescription =
      "zkSync is a trustless Layer 2 protocol for scalable low-cost payments on Ethereum, powered by zkRollup technology.";
  final celoDescription =
      "Celo is a blockchain-based ecosystem specializing in mobile-first decentralized applications and smart contracts.";
  final scrollDescription =
      "Scroll is a security-focused scaling solution for Ethereum, using innovations in scaling design and zero knowledge proofs to build a new layer on Ethereum.";
  final hederaDescription =
      "Hedera is a fully open source public distributed ledger that utilizes the fast, fair, and secure hashgraph consensus.";
  final blastDescription =
      "The Fullstack Chain - the only EVM chain with native yield for ETH and stablecoins.";
  final apeDescription =
      "ApeChain is a new Layer-3 blockchain developed as an Arbitrum Orbit chain by ApeCoin DAO.";
  final explorer0 = "Transfers";
  final explorer1 = "Value transferred";
  final explorer2 = "Deposits";
  final explorer3 = "Value Deposited";
  final explorer4 = "Withdrawals";
  final explorer5 = "Value withdrawn";
  final explorer6 = "Value Loaned";
  final explorer7 = "Lottery draws";
  final explorer8 = "Winners";
  final explorer9 = "Prizes distributed";
  final explorer10 = "Value Borrowed";
  final explorer11 = "Transfers";
  final explorer12 = "Trust";
  final explorer13 = "Lottery";
  final explorer14 = "Loans";
  final explorer15 = "Payments";
  final explorer16 = "Bids";
  final explorer17 = "Owners";
  final explorer18 = "Beneficiaries";
  final explorerHint0 = "Transfer ID";
  final explorerHint1 = "Deposit ID";
  final explorerHint2 = "ID";
  final explorerHint3 = "Contract ID";
  final explorerHint4 = "Payment ID";
  final explorerSearch = "Search";
  final table0 = "Recipient";
  final table1 = 'Amount';
  final table2 = 'Date';
  final table3 = 'Date Scheduled';
  final table4 = 'Status';
  final table5 = 'Fee';
  final table6 = 'ID';
  final table7 = 'Depositor';
  final table8 = 'Amount';
  final table9 = 'Date';
  final table10 = 'Date Unlocked';
  final table11 = 'Fee';
  final table12 = 'Status';
  final table13 = 'ID';
  final table14 = 'Draw ID';
  final table15 = 'Prize';
  final table16 = 'Date';
  final table17 = 'Winners';
  final table18 = 'Loaner/Borrower';
  final table19 = 'Amount';
  final table20 = 'Collateral';
  final table21 = 'Date Issued';
  final table22 = 'Status';
  final table23 = 'Date Settled';
  final table24 = 'Loan ID';
  final table25 = 'Payer';
  final table26 = 'Amount';
  final table27 = 'Status';
  final table28 = 'Recipient';
  final table29 = 'Date Paid';
  final table30 = 'No data';
  final table31 = "Amount";
  final table32 = "Source network";
  final table33 = "Source address";
  final table34 = "Destination network";
  final table35 = "Destination address";
  final table36 = "Deleted";
  final table37 = "Complete";
  final table38 = "Ongoing";
  final table39 = "Owner";
  final table40 = "Amount";
  final table41 = "Asset address";
  final table42 = "Sender";
  final subtable1 = "Accepted";
  final subtable2 = "Not Accepted";
  final subtable3 = "Unlimited";
  final subtable4 = "Address";
  final subtable5 = "Bidder";
  final subtable6 = "Amount";
  final subtable7 = "Asset Address";
  final subtable8 = "Status";
  final subtable9 = "Date";
  final subtable10 = "Address";
  final subtable11 = "Allowance/day";
  final subtable12 = "Cancelled";
  final subtable13 = "Latest Withdrawal";
  String governance0(int roundInterval, int coinholdDuration) =>
      "Omnify is governed by \$OFY, its utility token. Profits collected are distributed in distribution rounds.\n\$OFY is also needed to vote on proposals.\n1 OFY = 1 SHARE = 1 VOTE";
  final governance1 = "Proposals";
  final governance2 = "Milestones";
  final governance3 = "Shares";
  final governance4 = "Proposal Fee: ";
  final fees1 = "Transfers";
  final fees2 = "Payments";
  final fees3 = "Trust";
  final fees4 = "Bridge";
  final fees5 = "Escrow";
  final fees6 = "Lottery";
  final fees7 = "Loans";
  final fees8 = "Amount";
  final fees9 = "Base fee";
  final fees10 = "Scheduling fee (optional)";
  final fees11 = "Network fee";
  final fees12 = "Amount";
  final fees13 = "Percentage (%)";
  final fees14 = "Network fee";
  final fees15 = "Amount";
  final fees16 = "Base fee";
  final fees17 = "Scheduling fee (optional)";
  final fees18 = "Network fee";
  final fees19 = "Amount";
  final fees20 = "Fee (on source network)";
  final fees21 = "Network fee";
  final fees22 = "Assets value";
  final fees23 = "Contract fee";
  final fees24 = "Network fee";
  final fees25 = "Price/combination";
  final fees26 = "Network fee (minting + gas)";
  final fees27 = "Amount";
  final fees28 = "Interest (%)";
  final fees29 = "Altcoins: ";
  final fees30 = "/payment";
  final fees31 = "/installment";
  final fees32 = "/deposit";
  final fees33 = "/beneficiary";
  final fees34 = "/transaction";
  final fees35 = "/contract";
  final fees36 = "Refuel";
  final shares = "Your shares: ";
  final shares2 = "Your profits: ";
  final shares3 = "Profits Distributed: ";
  String shares4(int d) =>
      "Disclaimer: Omni tokens should be received $d days prior to withdrawing profits from a distribution round.";
  final shares5 = "Distribution Rounds";
  final shares6 =
      "Connect your wallet to see your shares and profits available for withdrawal";
  final shares7 = "Round";
  final shares8 = "Withdrawn ";
  final shares9 = "Remaining ";
  final shares10 = "Fees Collected: ";
  final shares11 = "Profit/share: ";
  final shares12 = "Profits Withdrawn: ";
  final shares13 = "Profits Remaining: ";
  final shares14 = "Your Cut: ";
  final shares15 = "Open";
  final shares16 = "Closed";
  final shares17 = "Withdrawn";
  final shares18 = "Withdraw";
  final shares19 = "Current Profits: ";
  String shares20(int d) =>
      "Omnify distribution rounds are triggered every $d days when current profits are 1 coin and above.";
  final yes = "YES";
  final no = "NO";
  final proposal1 = "Submit";
  final proposal2 = "Proposal Name";
  final proposal3 = "Proposal Description";
  final paste = "Paste";
  final toasts21 = "Validation failed";
  final toasts22 = "Could not get ";
  final toasts23 = "allowance for Omnify";
  final toasts24 = "Allowance Request Failed";
  final toasts25 = "Could not request allowances for Omnify";
  final toasts26 = "Insufficent Funds";
  final toasts27 = "Insufficient balance of: ";
  final toasts28 = "Reconnect Failed";
  final toasts29 = "Could not reconnect to previous wallet session, try again";
  final toasts30 = "Could not conduct transaction, try again";
  final toasts31 = "Allowance Withdrawn";
  final toasts32 = "Come back after ";
  final toasts33 = " minutes";
  final changingNetwork = "Switching Network";
  final transacting = "Transacting...";
  final transactionSent = "Transaction sent";
  final transactionSent2 = "Transaction sent to the blockchain!";
  final toast11 = "Approvals Requested";
  final toast12 = "Sign from wallet to approve allowance";
  final error1 = "Connection failed";
  final retry = "RETRY";
  final wcsheet1 = "Connect a wallet";
  final wcsheet2 = "Show Code";
  final wcsheet3 = "Connect by scanning a shown QR code.";
  final wcsheet4 = "Select Wallet";
  final wcsheet5 = "Connect by navigating to the wallet.";
  final toast5 = "Link copied";
  final wcDescription = "DeFi suite of services";
  final wcRequest1 = "Connection Requested";
  final wcRequest2 =
      "Open the wallet to connect using the previously connected wallet.";
  final toast15 = "Unsupported networks";
  final toasts16 =
      "The wallet you are trying to connect does not support any of our deployed networks";
  final toasts17 = "Session expired";
  final toasts18 = "Wallet session has expired, reconnection needed";
  final toast13 = "Error";
  final toast14 = "Could not disconnect wallet";
  final showMore = 'Show more';
  final timer1 = "Next Round: ";
  final timer2 = "ICO start: ";
  final timer3 = "ICO ends: ";
  final timer4 = "You can withdraw profits after: ";
  final timer5 = "Round ends: ";
  final checkWallet = "Check connected wallet";
  final votingEnds = "Voting ends:";
  final coinseller1 = "Total Supply: ";
  final coinseller2 = "Sold coins: ";
  final coinseller3 = "Remaining coins: ";
  final coinseller4 = "Price / OFY: ";
  final coinseller5 = "Total";
  final coinseller6 = "buy \$OFY";
  final coinseller7 = "Token address";
  final coinseller8 = "Token name";
  final coinseller9 = "Token symbol";
  final coinseller10 = "Token decimals";
  final profit = "Profit";
  final next = "Next";
  final previous = "Previous";
}
