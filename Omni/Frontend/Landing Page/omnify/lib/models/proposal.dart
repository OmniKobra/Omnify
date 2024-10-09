import '../utils.dart';

class Proposal {
  final String proposalId;
  final String title;
  final String description;
  final String submitter;
  final Chain network;
  final DateTime dateSubmitted;
  final DateTime expiration;
  final bool allowedToVote;
  bool hasVoted;
  int yay;
  int nay;
  Proposal(
      {required this.proposalId,
      required this.title,
      required this.description,
      required this.submitter,
      required this.network,
      required this.dateSubmitted,
      required this.expiration,
      required this.hasVoted,
      required this.yay,
      required this.allowedToVote,
      required this.nay});
  void voteYes(int shares) {
    hasVoted = true;
    yay += shares;
  }

  void voteNo(int shares) {
    hasVoted = true;
    nay += shares;
  }
}
