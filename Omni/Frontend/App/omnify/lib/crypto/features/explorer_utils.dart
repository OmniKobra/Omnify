import 'package:web3dart/web3dart.dart';

import '../../models/asset.dart';
import '../../models/escrow_contract.dart';
import '../../models/explorer_bridge.dart';
import '../../models/explorer_escrow.dart';
import '../../models/explorer_payment.dart';
import '../../models/explorer_transfer.dart';
import '../../models/explorer_trust.dart';
import '../../utils.dart';
import '../utils/chain_utils.dart';
import '../contracts/bridgesAbi.g.dart';
import '../contracts/escrowAbi.g.dart';
import '../contracts/paymentsAbi.g.dart';
import '../contracts/transfersAbi.g.dart';
import '../contracts/trustAbi.g.dart';
import '../utils/aliases.dart';

class ExplorerUtils {
  static Future<ExplorerTransfer?> getTransfer(
      Chain c, String id, Web3Client client) async {
    final alias = Aliases.getAlias(c);
    final TransfersAbi transferContract = alias.transfersContract(c, client);
    try {
      var res = await transferContract.lookupTransfer((id: id));
      final exists = res[6];
      if (exists) {
        var id = res[0];
        var sender = ChainUtils.hexFromEthAddress(c, res[1]);
        var recipient = ChainUtils.hexFromEthAddress(c, res[2]);
        var asset = ChainUtils.hexFromEthAddress(c, res[3]);
        CryptoAsset? cAsset =
            await ChainUtils.getCoinFromAddress(c, asset, client);
        CryptoAsset a = cAsset ?? Utils.generateNativeToken(c);
        var amount = res[4];
        var date = ChainUtils.chainDateToDt(res[5]);
        return ExplorerTransfer(
            id: id,
            recipient: recipient,
            sender: sender,
            amount: ChainUtils.uintToDecimal(c, a, amount),
            asset: a,
            status: "status",
            date: date);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ExplorerPayment?> getPayment(
    Chain c,
    String id,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final PaymentsAbi paymentContract = alias.paymentsContract(c, client);
    try {
      var res = await paymentContract.lookupPayment((id: id));
      var isPaid = res[4];
      if (isPaid) {
        var amount = res[1];
        var customer = ChainUtils.hexFromEthAddress(c, res[2]);
        var vendor = ChainUtils.hexFromEthAddress(c, res[3]);
        var date = ChainUtils.chainDateToDt(res[12]);
        var a = Utils.generateNativeToken(c);
        return ExplorerPayment(
            payer: customer,
            id: id,
            amount: ChainUtils.uintToDecimal(c, a, amount),
            status: "status",
            recipient: vendor,
            date: date);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ExplorerTrust?> getTrust(
    Chain c,
    String id,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final TrustAbi trustContract = alias.trustContract(c, client);
    try {
      var owners = await trustContract.lookupDepositOwners((id: id));
      if (owners.isNotEmpty) {
        var depositor = ChainUtils.hexFromEthAddress(c, owners[0][0]);
        var amount = await trustContract.lookupDepositRemainingAmount((id: id));
        var asset = await trustContract.lookupDepositAsset((id: id));
        var cAsset = await ChainUtils.getCoinFromAddress(
            c, ChainUtils.hexFromEthAddress(c, asset), client);
        var a = cAsset ?? Utils.generateNativeToken(c);
        var date = await trustContract.lookupDepositDateCreated((id: id));
        var beneficiaries =
            await trustContract.lookupDepositBeneficiaries((id: id));
        List<String> ownerAddresses = [];
        List<Beneficiary> _benfs = [];
        for (var owner in owners) {
          var ownerAddress = owner[0];
          // var isOwner = owner[1];
          var ownerAddressHex = ownerAddress.hex;
          if (!ownerAddresses.contains(ownerAddressHex) &&
              ownerAddressHex != Utils.zeroAddress) {
            ownerAddresses.add(ChainUtils.hexFromEthAddress(c, ownerAddress));
          }
        }
        for (var benef in beneficiaries) {
          var benefAddress = benef[0];
          var bAddress = ChainUtils.hexFromEthAddress(c, benefAddress);
          var allowance = ChainUtils.uintToDecimal(c, a, benef[1]);
          var isLimited = benef[2];
          var lastWithdrawal = benef[3];
          if (!_benfs.any((xb) => xb.address == bAddress) &&
              bAddress != Utils.zeroAddress) {
            Beneficiary b = Beneficiary(
                address: bAddress,
                allowancePerDay: allowance,
                isLimited: isLimited,
                dateLastWithdrawal: ChainUtils.chainDateToDt(lastWithdrawal));
            _benfs.add(b);
          }
        }
        return ExplorerTrust(
            id: id,
            depositor: depositor,
            asset: a,
            status: "status",
            amount: ChainUtils.uintToDecimal(c, a, amount),
            date: ChainUtils.chainDateToDt(date),
            owners: ownerAddresses,
            beneficiaries: _benfs);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ExplorerBridge?> getBridge(
    Chain c,
    String id,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final BridgesAbi bridgeContract = alias.bridgesContract(c, client);
    try {
      final res = await bridgeContract
          .lookupBridgeTransaction((id: BigInt.from(int.tryParse(id) ?? 0)));
      var asset = res[0];
      var assetAddress = ChainUtils.hexFromEthAddress(c, asset);
      if (assetAddress != Utils.zeroAddress) {
        CryptoAsset? cAsset =
            await ChainUtils.getCoinFromAddress(c, assetAddress, client);
        CryptoAsset a = cAsset ?? Utils.generateNativeToken(c);
        var amount = ChainUtils.uintToDecimal(c, a, res[1]);
        var sourceChain = Utils.lzEidToChain(res[2].toInt());
        var destinationChain = Utils.lzEidToChain(res[3].toInt());
        var sourceAddress = ChainUtils.hexFromEthAddress(sourceChain, res[4]);
        var destinationAddress = ChainUtils.hexFromEthAddress(destinationChain, res[5]);
        var date = ChainUtils.chainDateToDt(res[6]);
        ExplorerBridge btx = ExplorerBridge(
            id: id,
            sourceChain: sourceChain,
            destinationChain: destinationChain,
            sourceAddress: sourceAddress,
            destinationAddress: destinationAddress,
            amount: amount,
            asset: a,
            date: date);
        return btx;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ExplorerEscrow?> getEscrow(
    Chain c,
    String id,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final EscrowAbi escrowContract = alias.escrowContract(c, client);
    try {
      var owner = await escrowContract.lookupContractOwner((id: id));
      var ownerAddress = ChainUtils.hexFromEthAddress(c, owner);
      if (ownerAddress != Utils.zeroAddress) {
        var _asset = await escrowContract.lookupContractAsset((id: id));
        CryptoAsset? cAsset = await ChainUtils.getCoinFromAddress(
            c, ChainUtils.hexFromEthAddress(c, _asset), client);
        CryptoAsset ca = cAsset ?? Utils.generateNativeToken(c);
        var _amount = await escrowContract.lookupContractAssetAmount((id: id));
        var cAmount = ChainUtils.uintToDecimal(c, ca, _amount);
        var isDeleted = await escrowContract.lookupContractIsDeleted((id: id));
        var isCompleted =
            await escrowContract.lookupContractIsComplete((id: id));
        var d = await escrowContract.lookupContractDateCreated((id: id));
        var date = ChainUtils.chainDateToDt(d);
        List<EscrowBid> bids = [];
        var chainBids = await escrowContract.lookupContractBids((id: id));
        if (chainBids.isNotEmpty) {
          for (var bid in chainBids) {
            var exists = bid[6];
            if (exists) {
              var bidder = bid[0];
              var bidderAddress = ChainUtils.hexFromEthAddress(c, bidder);
              var asset = bid[1];
              var assetAddress = ChainUtils.hexFromEthAddress(c, asset);
              CryptoAsset? bAsset =
                  await ChainUtils.getCoinFromAddress(c, assetAddress, client);
              CryptoAsset ba = bAsset ?? Utils.generateNativeToken(c);
              var bAmount = bid[2];
              var amountVal = ChainUtils.uintToDecimal(c, ba, bAmount);
              var dateBid = bid[3];
              var bidDate = ChainUtils.chainDateToDt(dateBid);
              var isAccepted = bid[4];
              var isCancelled = bid[5];
              bids.add(EscrowBid(
                  amount: amountVal,
                  bidderAddress: bidderAddress,
                  assetAddress: ba.address,
                  coinName: ba.symbol,
                  imageUrl: ba.logoUrl,
                  bidAccepted: isAccepted,
                  bidCancelled: isCancelled,
                  decimals: ba.decimals,
                  dateBid: bidDate));
            }
          }
        }
        var e = ExplorerEscrow(
            id: id,
            owner: ownerAddress,
            amount: cAmount,
            asset: ca,
            isDeleted: isDeleted,
            isCompleted: isCompleted,
            bids: bids,
            date: date);
        return e;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
