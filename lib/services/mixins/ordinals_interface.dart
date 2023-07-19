import 'package:stackwallet/dto/ordinals/feed_response.dart';
import 'package:stackwallet/dto/ordinals/inscription_response.dart';
import 'package:stackwallet/dto/ordinals/sat_response.dart';
import 'package:stackwallet/dto/ordinals/transaction_response.dart';
import 'package:stackwallet/dto/ordinals/output_response.dart';
import 'package:stackwallet/dto/ordinals/address_response.dart';
import 'package:stackwallet/dto/ordinals/block_response.dart';
import 'package:stackwallet/dto/ordinals/content_response.dart';
import 'package:stackwallet/dto/ordinals/preview_response.dart';
import 'package:stackwallet/services/ordinals_api.dart'; // Assuming this import is necessary

mixin OrdinalsInterface {
  final OrdinalsAPI ordinalsAPI = OrdinalsAPI(baseUrl: 'https://ord-litecoin.stackwallet.com');

  Future<FeedResponse> fetchLatestInscriptions() async {
    try {
      final feedResponse = await ordinalsAPI.getLatestInscriptions();
      // Process the feedResponse data as needed
      // print('Latest Inscriptions:');
      // for (var inscription in feedResponse.inscriptions) {
      //   print('Title: ${inscription.title}, Href: ${inscription.href}');
      // }
      return feedResponse;
    } catch (e) {
      // Handle errors
      throw Exception('Error in OrdinalsInterface fetchLatestInscriptions: $e');
    }
  }

  Future<InscriptionResponse> getInscriptionDetails(String inscriptionId) async {
    try {
      return await ordinalsAPI.getInscriptionDetails(inscriptionId);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getInscriptionDetails: $e');
    }
  }

  Future<SatResponse> getSatDetails(int satNumber) async {
    try {
      return await ordinalsAPI.getSatDetails(satNumber);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getSatDetails: $e');
    }
  }

  Future<TransactionResponse> getTransaction(String transactionId) async {
    try {
      print(1);
      return await ordinalsAPI.getTransaction(transactionId);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getTransaction: $e');
    }
  }

  Future<OutputResponse> getTransactionOutputs(String transactionId) async {
    try {
      return await ordinalsAPI.getTransactionOutputs(transactionId);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getTransactionOutputs: $e');
    }
  }

  Future<AddressResponse> getInscriptionsByAddress(String address) async {
    try {
      return await ordinalsAPI.getInscriptionsByAddress(address);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getInscriptionsByAddress: $e');
    }
  }

  Future<BlockResponse> getBlock(int blockNumber) async {
    try {
      return await ordinalsAPI.getBlock(blockNumber);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getBlock: $e');
    }
  }

  Future<ContentResponse> getInscriptionContent(String inscriptionId) async {
    try {
      return await ordinalsAPI.getInscriptionContent(inscriptionId);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getInscriptionContent: $e');
    }
  }

  Future<PreviewResponse> getInscriptionPreview(String inscriptionId) async {
    try {
      return await ordinalsAPI.getInscriptionPreview(inscriptionId);
    } catch (e) {
      throw Exception('Error in OrdinalsInterface getInscriptionPreview: $e');
    }
  }
}